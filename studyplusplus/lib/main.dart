import 'package:flutter/material.dart';
import 'pages/taskScreen.pages.dart';

void main() { runApp(const TaskApp()); }

class TaskApp extends StatelessWidget {

	const TaskApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			theme: ThemeData.dark().copyWith(
				primaryColor: Colors.deepPurple,
				colorScheme: const ColorScheme.dark(
				primary: Colors.deepPurple,
				secondary:
					Colors.purpleAccent,
				),
			),
			home: TaskScreen(),
		);
	}
}