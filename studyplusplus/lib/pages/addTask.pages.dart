import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../services/database_services.dart';

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
		final TextEditingController _titleController = TextEditingController();
		final TextEditingController _descriptionController = TextEditingController();

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
			const Text('Task Title', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
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

	Future<void> _createTask() async {
		final title = _titleController.text;
		final description = _descriptionController.text;
		final startTime = _startTime.format(context);
		final endTime = _endTime.format(context);
		final priority = _priority;
		final alert = _getAlert;

		await DataBaseService.instance.insertTask(title, description, startTime, endTime, priority, alert);

		Navigator.pop(context);


		final List<Map<String, dynamic>> tasks = await DataBaseService.instance.getTasks();
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