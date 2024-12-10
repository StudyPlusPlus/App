import 'package:flutter/material.dart';
import '../services/database_services.dart';

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = DataBaseService.instance.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
            ),
            const SizedBox(height: 20),
            Text('Username: ${user['username']}',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: ${user['email']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
