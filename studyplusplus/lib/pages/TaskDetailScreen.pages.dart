import 'package:flutter/material.dart';
import 'package:studyplusplus/services/database_services.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late Map<String, dynamic> _taskDetails;

  @override
  void initState() {
    super.initState();
    _loadTaskDetails();
  }

  // Função para carregar os detalhes da tarefa
  Future<void> _loadTaskDetails() async {
    _taskDetails = await DataBaseService.instance.getTaskById(widget.taskId);
    setState(() {});
  }

  // Função para excluir a tarefa
  Future<void> _deleteTask() async {
    await DataBaseService.instance.deleteTask(widget.taskId);
    Navigator.pop(context); // Volta para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Task Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: _taskDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da Tarefa (Agora centralizado e maior)
                    Text(
                      _taskDetails['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Seção de Descrição
                    _buildSectionHeader('Description'),
                    Text(
                      _taskDetails['description'] ?? 'No Description',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 16),

                    // Seção de Datas
                    _buildSectionHeader('Dates'),
                    Text(
                      'Start Date: ${_taskDetails['start_date']}',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'End Date: ${_taskDetails['end_date']}',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 16),

                    // Seção de Prioridade
                    _buildSectionHeader('Priority'),
                    Text(
                      _taskDetails['priority'] ?? 'No Priority Set',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Volta para a tela anterior
                        },
                        child: const Text('Back to Tasks'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 245, 243,
                              243), // Contraste com o fundo preto
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 5.0),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget para o título das seções
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.purpleAccent,
        ),
      ),
    );
  }
}
