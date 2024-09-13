import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_expense_tracker/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Print name, email, and password to logcat for debugging
    print('Name: $name');
    print('Email: $email');
    print('Password: $password');

    try {
      final response = await http.post(
        Uri.parse('http://192.168.159.216:5000/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        print('Registration successful: ${response.body}');
        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registered successfully!'),
            backgroundColor: Colors.green,
            // You can change this to any color
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            // Make the SnackBar float
            margin: EdgeInsets.all(16),
          ),
        );
        // Registration successful, navigate to login page
        Navigator.pop(context);
      } else {
        print('Registration failed: ${response.body}');
        // Show error SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
            // You can change this to any color
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            // Make the SnackBar float
            margin: EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
          // You can change this to any color
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          // Make the SnackBar float
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      resizeToAvoidBottomInset: true,
      // This prevents the RenderFlex issue when the keyboard is open
      body: SingleChildScrollView(
        // Wraps the content to allow scrolling
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.6, // Set width to 60% of screen width
                  height: MediaQuery.of(context).size.height *
                      0.4, // Set height to 40% of screen height
                  child: Image.asset(
                    'assets/images/login.png', // Ensure this path is correct
                    fit: BoxFit
                        .contain, // Adjust image to fit within the SizedBox
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  foregroundColor: Colors.white,
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
