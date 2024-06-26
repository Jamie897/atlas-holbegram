import 'package:flutter/material.dart';
import 'package:holbegram/methods/auth_methods.dart';
import 'package:holbegram/screens/auth/login_screen.dart';
import 'package:holbegram/screens/auth/upload_image_screen.dart';
import 'package:holbegram/widgets/text_field_input.dart';

class SignUp extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  bool _passwordVisible;

  SignUp({
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.passwordConfirmController,
    this._passwordVisible = true,
  });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
    // Initialize state if needed
  }

  @override
  void dispose() {
    // Dispose of controllers
    widget.emailController.dispose();
    widget.usernameController.dispose();
    widget.passwordController.dispose();
    widget.passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 28),
              const Text(
                'Sign Up for Holbegram',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 28),
              TextFieldInput(
                controller: widget.emailController,
                isPassword: false,
                hintText: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                controller: widget.usernameController,
                isPassword: false,
                hintText: 'Username',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                controller: widget.passwordController,
                isPassword: !widget._passwordVisible,
                hintText: 'Password',
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  alignment: Alignment.bottomLeft,
                  icon: widget._passwordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      widget._passwordVisible = !widget._passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                controller: widget.passwordConfirmController,
                isPassword: !widget._passwordVisible,
                hintText: 'Confirm Password',
                keyboardType: TextInputType.visiblePassword,
                suffixIcon: IconButton(
                  alignment: Alignment.bottomLeft,
                  icon: widget._passwordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      widget._passwordVisible = !widget._passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 48,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to UploadImageScreen and pass data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadImageScreen(
                          email: widget.emailController.text.trim(),
                          username: widget.usernameController.text.trim(),
                          password: widget.passwordController.text.trim(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
