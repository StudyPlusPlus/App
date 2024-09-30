import 'package:flutter/material.dart';

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
        // accentColor: Colors.purpleAccent,
      ),
      home: TaskScreen(),
    );
  }
}

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
            Text('${(_calculateCompletionPercentage(_todayTasks) * 3).toInt()}/3 Task Completed'),
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
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String _title = '';
  String _schedule = 'Power Set';
  TimeOfDay _startTime = TimeOfDay(hour: 11, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 12, minute: 0);
  String _priority = 'High';
  bool _getAlert = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study++'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
            Text('Schedule', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(_schedule, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Task Title
            Text('Task Title', style: TextStyle(fontSize: 16)),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter task title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Start and End Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Time', style: TextStyle(fontSize: 16)),
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
                      child: Text('${_startTime.format(context)}', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('End Time', style: TextStyle(fontSize: 16)),
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
                      child: Text('${_endTime.format(context)}', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Priority
            Text('Priority', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPriorityButton('High'),
                _buildPriorityButton('Medium'),
                _buildPriorityButton('Low'),
              ],
            ),
            SizedBox(height: 20),

            // Alert toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Get alert for this task', style: TextStyle(fontSize: 16)),
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  child: Text('Exit'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement task creation logic here
                    // For example, you might want to add the task to a list and return to the previous screen
                  },
                  child: Text('Create Task'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build a priority button
  Widget _buildPriorityButton(String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _priority = label;
        });
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: _priority == label ? Colors.purple : Colors.grey,
      ),
    );
  }
}
