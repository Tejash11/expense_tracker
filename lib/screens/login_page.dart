import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Sending POST request to backend for email/password login
      final response = await http.post(
        Uri.parse('http://192.168.159.216:5000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Handle successful login
        print('Login successful: ${response.body}');

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
            // You can change this to any color
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            // Make the SnackBar float
            margin: EdgeInsets.all(16),
          ),
        );
        // Navigate to your main screen or dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        // Handle error response
        print('Login failed');

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
      // Handle errors
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

  final String googleLoginUrl = 'http://localhost:5000/api/auth/google';

  Future<void> _signInWithGoogle() async {
    try {
      // final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // if (googleUser == null) return; // User canceled the login
      //
      // final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // final idToken = googleAuth.idToken;
      //
      // if (idToken != null) {
      //   // Sending POST request to backend for google login
      //   final response = await http.post(
      //     Uri.parse('/api/auth/google'),
      //     headers: {'Content-Type': 'application/json'},
      //     body: jsonEncode({'idToken': idToken}),
      //   );

      // final response = await http.post(Uri.parse(googleLoginUrl));
      //   if (response.statusCode == 200) {
      //     // Handle successful login
      //     print('Login successful');
      //     Navigator.pushReplacementNamed(context, '/dashboard');
      //   } else {
      //     // Handle error response
      //     print('Login failed');
      //   }

      if (await canLaunch(googleLoginUrl)) {
        await launch(googleLoginUrl);
      } else {
        throw 'Could not launch $googleLoginUrl';
      }
      Future.delayed(Duration(seconds: 5), () {
        // Navigate to the dashboard after Google login success
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return; // User canceled the login
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     UserCredential userCredential = await _auth.signInWithCredential(credential);
  //     Navigator.pushReplacementNamed(context, '/dashboard');
  //   } catch (e) {
  //     // Handle errors (e.g., show an alert)
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: Text('Skip Now',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          SizedBox(width: 16),
          // Add spacing between the Skip button and the end of the AppBar
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Image.asset(
                  'assets/images/login.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithEmail,
              child: Text('Login with Email'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'OR',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Card(
                elevation: 3,
                child: InkWell(
                  onTap: _signInWithGoogle,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google_logo.png',
                          // Path to Google logo image
                          height: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Google',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New User?',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    'Register now',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
