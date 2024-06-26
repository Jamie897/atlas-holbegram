import 'package:flutter/material.dart';

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 28,
              ),
            ),
            SizedBox(width: 8),
            Image.asset(
              'assets/images/your_logo.png', // Replace with your logo asset path
              width: 40,
              height: 40,
              // Adjust width and height as needed
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search action
            },
          ),
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              // Implement add post action
            },
          ),
        ],
      ),
      body: Posts(), // Assuming Posts widget will be implemented later
    );
  }
}
