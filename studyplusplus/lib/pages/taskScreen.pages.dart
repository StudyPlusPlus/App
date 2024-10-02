import 'package:flutter/material.dart';
import 'package:studyplusplus/pages/login.page.dart';
import 'addTask.pages.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // List of today's tasks
  final List<Map<String, dynamic>> _todayTasks = [
    {'name': 'Grafos', 'date': '4 Oct', 'completed': true},
    {'name': 'LDDM', 'date': '4 Oct', 'completed': true},
    {'name': 'I.A', 'date': '4 Oct', 'completed': false},
  ];

  // List of tomorrow's tasks
  final List<Map<String, dynamic>> _tomorrowTasks = [
    {'name': 'Estatística', 'date': '5 Oct', 'completed': false},
    {'name': 'TI.IV', 'date': '5 Oct', 'completed': false},
    {'name': 'Grafos', 'date': '5 Oct', 'completed': false},
  ];

  // Helper method to calculate the percentage of completed tasks
  double _calculateCompletionPercentage(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task['completed']).length;
    return completedTasks / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    double todayProgress = _calculateCompletionPercentage(_todayTasks);

    return Scaffold(
      appBar: AppBar(
        title: Text('You have got 5 tasks today to complete'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                // Aqui, o usuário clica no avatar e é levado para a página de login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
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
            SizedBox(height: 20),

            // Progress Bar
            _buildProgressBar(todayProgress),

            SizedBox(height: 20),

            // Today's Task Header
            _buildSectionHeader('Today\'s Task'),

            // Task List for Today
            _buildTaskList(context, _todayTasks),

            SizedBox(height: 20),

            // Tomorrow's Task Header
            _buildSectionHeader('Tomorrow\'s Task'),

            // Task List for Tomorrow
            _buildTaskList(context, _tomorrowTasks),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Task screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  // Function to build the progress bar section
  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Task',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                '${(_calculateCompletionPercentage(_todayTasks) * 3).toInt()}/3 Task Completed'),
            Text('${(progress * 100).toInt()}%'),
          ],
        ),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[800],
          color: Colors.purpleAccent,
        ),
      ],
    );
  }

  // Function to build a section header
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text('See All'),
        ),
      ],
    );
  }

  // Function to build a task list
  Widget _buildTaskList(
      BuildContext context, List<Map<String, dynamic>> tasks) {
    return Column(
      children: tasks.map((task) {
        return Card(
          color: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(task['name']),
            subtitle: Text(task['date']),
            trailing: Checkbox(
              value: task['completed'],
              onChanged: (bool? value) {
                setState(() {
                  task['completed'] = value;
                });
              },
              activeColor: Colors.purpleAccent,
            ),
          ),
        );
      }).toList(),
    );
  }
}
