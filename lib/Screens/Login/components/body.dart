import 'package:api_test/Screens/Welcome/welcome_screen.dart';
import 'package:api_test/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:api_test/Screens/Login/components/background.dart';
import 'package:api_test/Screens/Signup/signup_screen.dart';
import 'package:api_test/components/already_have_an_account_acheck.dart';
import 'package:api_test/components/rounded_button.dart';
import 'package:api_test/components/rounded_input_field.dart';
import 'package:api_test/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final AuthService _auth = AuthService();

  String error = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() => email = value);
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() => password = value);
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                dynamic result =
                    await _auth.signInWithEmailAndPassword(email, password);
                if (result == null) {
                  setState(() {
                    error = 'Could not sign in with those credentials';
                  });
                } else {
                  loginCheck(context);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void loginCheck(BuildContext context) {
    return setState(() {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomeScreen();
                      },
                    ),
                  );
                });
  }
}
