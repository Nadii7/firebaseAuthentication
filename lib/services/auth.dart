import 'package:api_test/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = new GoogleSignIn();
  final facebooklogin = FacebookLogin();
  // create user obj based on firebaseuser
  Users _userFromFirebase(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<Users> get user {
    return _auth
        .authStateChanges()
        //.map((User user) => _userFromFirebase(user));
        .map(_userFromFirebase);
  }

  // SignIn with Google
  Future signinWithGoogle() async {
    GoogleSignInAccount _googleSignInAccount = await _googleAuth.signIn();
    GoogleSignInAuthentication _googleSignInAuthentication =
        await _googleSignInAccount.authentication;
    AuthCredential _authCredential = GoogleAuthProvider.credential(
        idToken: _googleSignInAuthentication.idToken,
        accessToken: _googleSignInAuthentication.accessToken);
    try {
      UserCredential result = await _auth.signInWithCredential(_authCredential);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // SignIn with Facebook
  Future signinWithFacebook() async {
    final res = await facebooklogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (res.status) {
      case FacebookLoginStatus.Success:
        // Send access token to server for validation and auth
        final FacebookAccessToken accessToken = res.accessToken;
        try {
          UserCredential result = await _auth.signInWithCredential(
              FacebookAuthProvider.credential(accessToken.toString()));
          User user = result.user;
          return user;
        } catch (e) {
          print(e.toString());
          return null;
        }
        break;
      case FacebookLoginStatus.Cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.Error:
        // Log in failed
        print('Error while log in: ${res.error}');
        break;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebase(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // SignIn Anonymous
  Future signinAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      // await facebooklogin.logOut();
      // await _googleAuth.signOut();
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
