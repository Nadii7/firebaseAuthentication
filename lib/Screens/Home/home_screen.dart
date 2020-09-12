import 'package:api_test/Screens/Home/components/body.dart';
import 'package:api_test/Screens/Welcome/welcome_screen.dart';
import 'package:api_test/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomeScreen();
                      },
                    ),
                  );
              },
              child: Text("Sign out"))
        ],
      ),
      body: Body(),
    );
  }
}
