	import 'package:flutter/material.dart';
	import 'package:studyplusplus/pages/login.page.dart';
	import 'package:studyplusplus/pages/aboutPage.pages.dart';
	import 'addTask.pages.dart';

	class TaskScreen extends StatefulWidget {

		const TaskScreen({super.key});

		@override
		// ignore: library_private_types_in_public_api
		_TaskScreenState createState() => _TaskScreenState();
	}

	class _TaskScreenState extends State<TaskScreen> {
	final List<Map<String, dynamic>> _todayTasks = [
		{'name': 'Grafos', 'date': '4 Oct', 'completed': true},
		{'name': 'LDDM', 'date': '4 Oct', 'completed': true},
		{'name': 'I.A', 'date': '4 Oct', 'completed': false},
	];

	final List<Map<String, dynamic>> _tomorrowTasks = [
		{'name': 'Estatística', 'date': '5 Oct', 'completed': false},
		{'name': 'TI.IV', 'date': '5 Oct', 'completed': false},
		{'name': 'Grafos', 'date': '5 Oct', 'completed': false},
	];

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
				title: Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						const Text('Study++'), // Título
						const SizedBox(width: 8), // Espaço entre título e botão
						IconButton(
							icon: const CircleAvatar(
								child: Icon(Icons.info, color: Colors.white), // Ícone 'i'
								backgroundColor: Colors.purpleAccent, // Cor de fundo do círculo
							),
							onPressed: () {
								// Navegar para a AboutPage
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
								// Navegar para a página de login
								Navigator.push(
									context,
									MaterialPageRoute(builder: (context) => LoginPage()),
								);
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

			floatingActionButton: FloatingActionButton(
				onPressed: () {
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
						Text('${(_calculateCompletionPercentage(_todayTasks) * 3).toInt()}/3 Task Completed'),
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
					onPressed: () {},
					child: Text('See All'),
				),
			],
		);
	}

	Widget _buildTaskList(BuildContext context, List<Map<String, dynamic>> tasks) {

		return Column(
			children: tasks.map((task) {
				return Card(
					color: Colors.black26,
					shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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