import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signOutEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Sending POST request to backend for email/password logout
      final response = await http.post(
        Uri.parse('http://192.168.159.216:5000/api/auth/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Handle successful logout
        print('Logout successful: ${response.body}');

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout successful!'),
            backgroundColor: Colors.green, // You can change this to any color
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating, // Make the SnackBar float
            margin: EdgeInsets.all(16),
          ),
        );

        // Navigate to the login page
        Navigator.pushReplacementNamed(context, '/login_page');
      } else {
        // Handle error response
        print('Logout failed');

        // Show error SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed. Please check your internet connection'),
            backgroundColor: Colors.red, // You can change this to any color
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating, // Make the SnackBar float
            margin: EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');

      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red, // You can change this to any color
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating, // Make the SnackBar float
          margin: EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    _currentUser = _googleSignIn.currentUser;
    setState(() {});
  }

  // Method to handle sharing the app
  void _shareApp() {
    final String message = 'Check out this amazing app for tracking expenses and savings! Download it now and manage your finances better.';

    // Share the message using share_plus
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      body: Column(
        children: [
          if (_currentUser != null)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_currentUser!.photoUrl ?? ''),
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Text(
                    _currentUser!.displayName ?? 'User',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue),
            title: Text('Logout'),
            onTap: _signOutEmail,
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text('Settings'),
            onTap: () {
              // Navigate to settings page
            },
          ),
          ListTile(
            leading: Icon(Icons.backup, color: Colors.blue),
            title: Text('Backup and Restore'),
            onTap: () {
              // Navigate to backup and restore page
            },
          ),
          ListTile(
            leading: Icon(Icons.rate_review, color: Colors.blue),
            title: Text('Rate the App'),
            onTap: () {
              // Add your rating logic here (e.g., open app store review page)
            },
          ),
          ListTile(
            leading: Icon(Icons.share, color: Colors.blue),
            title: Text('Refer to a Friend'),
            onTap: _shareApp,
          ),
        ],
      ),
    );
  }
}
