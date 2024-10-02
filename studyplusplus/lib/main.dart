import 'package:flutter/material.dart';
import 'package:studyplusplus/pages/aboutPage.pages.dart';
import 'pages/taskScreen.pages.dart';
// import 'pages/taskScreen.pages.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary:
              Colors.purpleAccent, // Use 'secondary' para a cor de destaque
        ),
      ),
      home: TaskScreen(),
    );
  }
}
