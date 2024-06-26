import 'dart:io';
import 'dart:typed_data';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/providers/user_provider.dart';
import 'package:holbegram/screens/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  AddPicture({
    Key? key,
    required this.email,
    required this.password,
    required this.username,
  }) : super(key: key);

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  void selectImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 28,
              ),
              const Text(
                'Holbegram',
                style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
              ),
              Image.asset(
                'assets/images/Sample_User_Icon.png',
                width: 80,
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    Text("Hello, ${widget.username}"),
                    const Text("choose imagee from gallery"),
                    const SizedBox(
                      height: 10,
                    ),
                    _image == null
                        ? Image.asset(
                            "assets/images/Sample_User_Icon.png",
                            height: 250,
                            width: 250,
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(
                                      _image!) // XFileImage(_image!),
                                  ),
                            )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.photo_size_select_large_outlined),
                            onPressed: (() => selectImageFromCamera())),
                        IconButton(
                            icon: const Icon(Icons.photo_size_select_large_outlined),
                            onPressed: (() => selectImageFromGallery())),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    SizedBox(
                      height: 48,
                      //width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(218, 226, 37, 24),
                          ),
                        ),
                        onPressed: () async {
                          String resulat = await AuthMethods().signUpUser(
                              email: widget.email,
                              password: widget.password,
                              username: widget.username,
                              file: _image);

                          if (resulat == "success") {
                            await userProvider.refreshUser();

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              ((route) => false),
                            );
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //   content: Text(resulat),
                            //   ));
                          }
                        },
                        child: const Text(
                          'next',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}