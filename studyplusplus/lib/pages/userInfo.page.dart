import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../services/database_services.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  Uint8List? _profileImageBytes;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    user = DataBaseService.instance.getCurrentUser();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    if (user != null) {
      final profilePictureBytes = await DataBaseService.instance
          .getUserProfilePicture(user!['user_id']);
      if (profilePictureBytes != null) {
        setState(() {
          _profileImageBytes = profilePictureBytes;
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _profileImageBytes = bytes;
      });
      await DataBaseService.instance.updateUserProfilePicture(
        user!['user_id'],
        bytes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('Take a picture'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Choose from gallery'),
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImageBytes != null
                    ? MemoryImage(_profileImageBytes!)
                    : NetworkImage('https://example.com/avatar.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Text('Username: ${user?['username'] ?? ''}',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Email: ${user?['email'] ?? ''}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
