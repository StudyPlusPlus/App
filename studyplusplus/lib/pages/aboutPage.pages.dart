import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Study++', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Sobre o App',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Study++ é uma ferramenta feita para estudantes, com o objetivo de ajudá-los a organizar suas tarefas e anotações de estudo de forma eficiente. \n Com o nosso app, você pode:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '• Diluir suas tarefas ao longo do tempo.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '• Gerenciar seu cronograma de estudos diários.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '• Manter suas anotações organizadas.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              '• Configurar alertas e prioridades para suas tarefas.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Desenvolvedores',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Gabriel Quaresma',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Text(
              'Pedro Alves',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Text(
              'Lucas Gualtieri',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
