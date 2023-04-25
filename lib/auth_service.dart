import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'login_page.dart';

class AuthNotifier extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool isLoading = false;

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }


  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    Provider.of<AuthNotifier>(context, listen: false).setLoggedIn(false);
  }

  Widget handleAuthState() {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setState(() {
        isLoading = false;
      });
      if (userCredential.user != null) {
        Provider.of<AuthNotifier>(context, listen: false).setLoggedIn(true);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Provider.of<AuthNotifier>(context, listen: false).setLoggedIn(true);
      }
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber,
      Function(PhoneAuthCredential) verificationCompleted,
      ) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('SMS code sent.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto-retrieval timeout.');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential?> signInWithCredential(AuthCredential credential, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        Provider.of<AuthNotifier>(context, listen: false).setLoggedIn(true);
      }
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void setState(VoidCallback fn) {}
}
