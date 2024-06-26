import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_app/methods/auth_methods.dart';
import 'package:your_app/methods/user_storage.dart'; 

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  Uint8List? _image;
  final StorageMethods _storageMethods = StorageMethods();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _passwordVisible = true;

  void selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = Uint8List.fromList(await pickedFile.readAsBytes());
      });
    }
  }

  void selectImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = Uint8List.fromList(await pickedFile.readAsBytes());
      });
    }
  }

  void uploadProfilePicture() async {
    if (_image != null) {
      String downloadUrl = await _storageMethods.uploadImageToStorage(
        false, // Not a post, adjust as per your needs
        "profile_pictures", // Child name in Firebase Storage
        _image!,
      );

      // Handle saving downloadUrl to user profile or wherever needed
      // Example: Update user profile picture in Firestore or Firebase Auth
      // This is just an example, adjust as per your app's logic
      // Example:
      AuthMethods authMethods = AuthMethods();
      String result = await authMethods.signUpUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
        file: _image,
      );

      if (result == 'success') {
        // Navigate to home screen or next screen after successful profile picture upload
        // Example:
        Navigator.pushReplacementNamed(context, '/home'); // Replace with your route
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile picture: $result')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Profile Picture'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: uploadProfilePicture, // Function to upload profile picture
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? MemoryImage(_image!) : const AssetImage('assets/images/default_profile.png'), // Replace with your default image
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: selectImageFromCamera, // Function to select image from camera
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo_library),
                    onPressed: selectImageFromGallery, // Function to select image from gallery
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
