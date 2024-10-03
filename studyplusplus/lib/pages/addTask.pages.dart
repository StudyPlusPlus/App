import 'package:flutter/material.dart';

void main() { runApp(const TaskApp()); }

class TaskApp extends StatelessWidget {

	const TaskApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			debugShowCheckedModeBanner: false,
			theme: ThemeData.dark().copyWith(
				primaryColor: Colors.deepPurple,
				// accentColor: Colors.purpleAccent,
			),
			home: const TaskScreen(),
		);
	}
}

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
			title: const Text('You have got 5 tasks today to complete'),
			actions: const [
			Padding(
				padding: EdgeInsets.all(8.0),
				child: CircleAvatar(
				backgroundImage: NetworkImage(
					'https://example.com/avatar.jpg'), // Replace with your image URL
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
					prefixIcon: const Icon(Icons.search),
					filled: true,
					fillColor: Colors.black26,
					border: OutlineInputBorder(
					borderRadius: BorderRadius.circular(30),
					borderSide: BorderSide.none,
					),
				),
				),
				const SizedBox(height: 20),

				// Progress Bar
				_buildProgressBar(todayProgress),

				const SizedBox(height: 20),

				// Today's Task Header
				_buildSectionHeader('Today\'s Task'),

				// Task List for Today
				_buildTaskList(context, _todayTasks),

				const SizedBox(height: 20),

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
				MaterialPageRoute(builder: (context) => const AddTaskScreen()),
			);
			},
			backgroundColor: Colors.purple,
			child: const Icon(Icons.add),
		),
		);
	}

	// Function to build the progress bar section
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

	// Function to build a section header
	Widget _buildSectionHeader(String title) {
		return Row(
		mainAxisAlignment: MainAxisAlignment.spaceBetween,
		children: [
			Text(
			title,
			style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
			),
			TextButton(
			onPressed: () {},
			child: const Text('See All'),
			),
		],
		);
	}

	// Function to build a task list
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

	// AddTaskScreen widget
	class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

	@override
	// ignore: library_private_types_in_public_api
	_AddTaskScreenState createState() => _AddTaskScreenState();
	}

	class _AddTaskScreenState extends State<AddTaskScreen> {
	final String _schedule = 'Power Set';
	TimeOfDay _startTime = const TimeOfDay(hour: 11, minute: 0);
	TimeOfDay _endTime = const TimeOfDay(hour: 12, minute: 0);
	String _priority = 'High';
	bool _getAlert = false;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
		appBar: AppBar(
			title: const Text('Study++'),
			leading: IconButton(
			icon: const Icon(Icons.arrow_back),
			onPressed: () {
				Navigator.pop(context); // Go back to the previous screen
			},
			),
		),
		body: Padding(
			padding: const EdgeInsets.all(16.0),
			child: Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				// Schedule Title
				const Text('Schedule', style: TextStyle(fontSize: 16)),
				const SizedBox(height: 8),
				Text(_schedule, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
				const SizedBox(height: 20),

				// Task Title
				const Text('Task Title', style: TextStyle(fontSize: 16)),
				TextField(
				decoration: const InputDecoration(
					hintText: 'Enter task title',
					border: OutlineInputBorder(),
				),
				onChanged: (value) {
					setState(() {
					});
				},
				),
				const SizedBox(height: 20),

				// Start and End Time
				Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('Start Time', style: TextStyle(fontSize: 16)),
						TextButton(
						onPressed: () async {
							TimeOfDay? selectedTime = await showTimePicker(
							context: context,
							initialTime: _startTime,
							);
							if (selectedTime != null) {
							setState(() {
								_startTime = selectedTime;
							});
							}
						},
						child: Text(_startTime.format(context), style: const TextStyle(fontSize: 16)),
						),
					],
					),
					Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						const Text('End Time', style: TextStyle(fontSize: 16)),
						TextButton(
						onPressed: () async {
							TimeOfDay? selectedTime = await showTimePicker(
							context: context,
							initialTime: _endTime,
							);
							if (selectedTime != null) {
							setState(() {
								_endTime = selectedTime;
							});
							}
						},
						child: Text(_endTime.format(context), style: const TextStyle(fontSize: 16)),
						),
					],
					),
				],
				),
				const SizedBox(height: 20),

				// Priority
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

				// Alert toggle
				Row(
				mainAxisAlignment: MainAxisAlignment.start,
				children: [
					const Text('Get alert for this task', style: TextStyle(fontSize: 16)),
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
						Navigator.pop(context); // Go back to the previous screen
					},
					style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
					child: const Text('Exit'),
					),
					ElevatedButton(
					onPressed: () {
						// Implement task creation logic here
						// For example, you might want to add the task to a list and return to the previous screen
					},
					child: const Text('Create Task'),
					),
				],
				),
			],
			),
		),
		);
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