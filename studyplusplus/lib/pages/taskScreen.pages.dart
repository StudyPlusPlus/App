import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studyplusplus/pages/login.page.dart';
import 'package:studyplusplus/pages/aboutPage.pages.dart';
import 'package:studyplusplus/pages/userInfo.page.dart';
import 'addTask.pages.dart';
import '../services/database_services.dart';
import 'TaskDetailScreen.pages.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Map<String, dynamic>> _todayTasks = [];
  List<Map<String, dynamic>> _tomorrowTasks = [];
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadTasks();
  }

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = await DataBaseService.instance.isLoggedIn();
    setState(() {});
  }

  // Função para carregar tarefas para hoje e amanhã
  Future<void> _loadTasks() async {
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String tomorrow =
        DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 1)));

    // Converte o resultado para listas independentes
    _todayTasks = List<Map<String, dynamic>>.from(
        await DataBaseService.instance.getTasksByDate(today));
    _tomorrowTasks = List<Map<String, dynamic>>.from(
        await DataBaseService.instance.getTasksByDate(tomorrow));

    setState(() {
      double todayProgress = _calculateCompletionPercentage(_todayTasks);
    });
  }

  // Função para calcular o progresso das tarefas
  double _calculateCompletionPercentage(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) return 1.0;
    int completedTasks = tasks.where((task) => task['status'] == 1).length;
    return completedTasks / tasks.length;
  }

  Future<void> _fetchAndCreateSuggestedTask() async {
    try {
      final activity = await DataBaseService.instance.fetchSuggestedActivity();
      await DataBaseService.instance.insertTask(
        activity['activity'],
        'Suggested by BoredAPI',
        DateFormat('dd/MM/yyyy').format(DateTime.now()),
        DateFormat('dd/MM/yyyy').format(DateTime.now().add(Duration(days: 1))),
        'Medium',
        false,
      );
      _loadTasks();
    } catch (e) {
      print('Failed to fetch activity: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double todayProgress = _calculateCompletionPercentage(_todayTasks);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Study++'),
            const SizedBox(width: 8),
            IconButton(
              icon: const CircleAvatar(
                child: Icon(Icons.info, color: Colors.white),
                backgroundColor: Colors.purpleAccent,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                if (_isLoggedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserInfoPage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Task Here',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildProgressBar(todayProgress),
            const SizedBox(height: 20),
            _buildSectionHeader('Today\'s Task'),
            _buildTaskList(context, _todayTasks),
            const SizedBox(height: 20),
            _buildSectionHeader('Tomorrow\'s Task'),
            _buildTaskList(context, _tomorrowTasks),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _fetchAndCreateSuggestedTask,
            child: Icon(Icons.lightbulb),
            backgroundColor: Colors.orange,
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Task',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${(_calculateCompletionPercentage(_todayTasks) * _todayTasks.length).toInt()}/${_todayTasks.length} Task Completed'),
            Text('${(progress * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[800],
          color: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: _loadTasks,
          child: Text('See All'),
        ),
      ],
    );
  }

  Widget _buildTaskList(
      BuildContext context, List<Map<String, dynamic>> tasks) {
    return Column(
      children: tasks.map((task) {
        // Definir o estado do checkbox baseado no valor de 'completed'
        bool isCompleted = task['status'] == 1;

        return Card(
          color: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(task['title'] ?? 'No Title'),
            subtitle: Text('${task['start_date']} - ${task['end_date']}'),
            trailing: Checkbox(
              value: isCompleted,
              onChanged: (bool? value) async {
                // Atualiza o status de 'completed' no banco de dados
                await DataBaseService.instance
                    .updateTaskStatus(task['task_id'], value ?? false);

                // Recarrega a lista de tarefas para refletir a mudança
                _loadTasks();
              },
              activeColor: isCompleted
                  ? Colors.pink
                  : Colors.grey, // Cor rosa para completada
              checkColor: Colors.white, // Cor do checkmark
            ),
            onTap: () {
              // Navega para a TaskDetailScreen ao clicar na tarefa
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TaskDetailScreen(taskId: task['task_id']),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
