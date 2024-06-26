import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart'; // Adjust imports as per your project structure
import 'package:holbegram/providers/user_provider.dart'; // Adjust imports as per your project structure
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authMethods = AuthMethods();

    // Example user data; replace with actual data retrieval from provider or auth methods
    String username = userProvider.user.username ?? 'Username';
    String email = userProvider.user.email ?? 'Email';
    String profileImage = userProvider.user.photoUrl ?? 'assets/images/default_profile.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authMethods.logout().then((_) {
                // Navigate to login screen or any other screen after logout
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(profileImage),
            ),
            SizedBox(height: 16),
            Text(
              username,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
  


