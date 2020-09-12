import 'package:api_test/Screens/Home/home_screen.dart';
import 'package:api_test/models/users.dart';
import 'package:flutter/material.dart';
import 'package:api_test/Screens/Welcome/components/body.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);
    
    // return either the Home or Authenticate widget
    if (user == null){
      return Scaffold(
      body: Body(),
    );
    } else {
      return HomeScreen();
    }
  }
}
