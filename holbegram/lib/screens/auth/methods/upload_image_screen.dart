import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/screens/auth/methods/user_storage.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddPictureState createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null) ...[
              Image.memory(_image!, height: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String downloadUrl = await StorageMethods().uploadImageToStorage(
                    false, // Not a post image
                    'profile_images', // Example path for profile images
                    _image!,
                  );
                  // Use downloadUrl as needed (e.g., save to user profile)
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Image uploaded successfully!'),
                  ));
                },
                child: const Text('Upload Image'),
              ),
            ] else ...[
              const Text('No image selected.'),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: selectImageFromGallery,
              child: const Text('Select Image from Gallery'),
            ),
            ElevatedButton(
              onPressed: selectImageFromCamera,
              child: const Text('Take a Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
