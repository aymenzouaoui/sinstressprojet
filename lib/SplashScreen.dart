import 'package:client/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:client/MyHomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 253, 253),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logoa.png', // Replace with your logo asset path
              width: 400,
              height: 400,
            ),
            SizedBox(height: 20),
            Text(
              'SINISTRE AUTOMOBILE',
              style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 5, 17, 148),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SpinKitFadingCircle(
              color: Color.fromARGB(255, 28, 2, 94),
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
