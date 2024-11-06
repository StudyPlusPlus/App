import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar a data
import '../services/database_services.dart';

// AddTaskScreen widget
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  String _priority = 'High';
  bool _getAlert = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Formata a data para exibição
  String getFormattedDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study++'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Voltar à tela anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Task Title', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Descrição da tarefa
            const Text('Description', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter task description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Data de Início e Fim
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Date', style: TextStyle(fontSize: 16)),
                    TextButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _startDate = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        getFormattedDate(_startDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End Date', style: TextStyle(fontSize: 16)),
                    TextButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _endDate = selectedDate;
                          });
                        }
                      },
                      child: Text(
                        getFormattedDate(_endDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Prioridade
            const Text('Priority', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriorityButton('High'),
                _buildPriorityButton('Medium'),
                _buildPriorityButton('Low'),
              ],
            ),
            const SizedBox(height: 20),

            // Alerta
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Get alert for this task',
                    style: TextStyle(fontSize: 16)),
                Switch(
                  value: _getAlert,
                  onChanged: (value) {
                    setState(() {
                      _getAlert = value;
                    });
                  },
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Voltar à tela anterior
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Exit'),
                ),
                ElevatedButton(
                  onPressed: _createTask,
                  child: const Text('Create Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Função para criar uma tarefa no banco de dados
  Future<void> _createTask() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final startDate = getFormattedDate(_startDate);
    final endDate = getFormattedDate(_endDate);
    final priority = _priority;
    final alert = _getAlert;

    await DataBaseService.instance
        .insertTask(title, description, startDate, endDate, priority, alert);

    Navigator.pop(context);

    final List<Map<String, dynamic>> tasks =
        await DataBaseService.instance.getTasks();
    print("Tarefas atuais no banco de dados:");
    for (var task in tasks) {
      print(task);
    }
  }

  Widget _buildPriorityButton(String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _priority = label;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _priority == label ? Colors.purple : Colors.grey,
      ),
      child: Text(label),
    );
  }
}
