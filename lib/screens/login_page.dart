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
            backgroundColor: Colors.green, // You can change this to any color
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating, // Make the SnackBar float
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
            backgroundColor: Colors.red, // You can change this to any color
            duration: Duration(seconds: 2),
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
      ),
      resizeToAvoidBottomInset: true, // Allows content to resize when keyboard opens
      body: SingleChildScrollView( // Makes the UI scrollable when keyboard is open
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6, // Set width to 70% of screen width
                  height: MediaQuery.of(context).size.height * 0.4, // Set height to 40% of screen height
                  child: Image.asset(
                    'assets/images/login.png', // Ensure this path is correct
                    fit: BoxFit.contain, // Adjust image to fit within the SizedBox
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _signInWithEmail,
                    child: Text('Login with Email'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('Register Now'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signInWithGoogle,
                child: Text('Login with Google'),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  child: Text('Skip Now', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
