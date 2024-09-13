import 'package:flutter/material.dart';

class Onboarding1 extends StatelessWidget {
  const Onboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Image at the top
          Spacer(flex: 1,),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6, // Set width to 70% of screen width
              height: MediaQuery.of(context).size.height * 0.4, // Set height to 40% of screen height
              child: Image.asset(
                'assets/images/onboarding1.png', // Ensure this path is correct
                fit: BoxFit.contain, // Adjust image to fit within the SizedBox
              ),
            ),
          ),
          SizedBox(height: 20), // Space between the image and text

          // Text below the image
          Text(
            'Welcome to AIxpense!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // Space between text and description

          // Description text
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Text(
              'With AIxpense, you can easily and quickly track all your expenses. '
                  'Enjoy full control over your finances.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          Spacer(flex: 2,),

          // Button at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0), // Padding on sides
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                Navigator.pushReplacementNamed(context, '/onboarding2');
              },
              child: Text('Get Started'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                foregroundColor: Colors.white,
                elevation: 5,
              ),
            ),
          ),

          Spacer(flex: 1,),
        ],
      ),
    );
  }
}
