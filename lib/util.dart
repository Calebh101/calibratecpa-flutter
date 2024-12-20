import 'package:calibratecpa/signin.dart';
import 'package:calibratecpa/var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> signIn(BuildContext context, bool exitable) async {
  if (signingIn != true) {
    print("signin loading");
    signingIn = true;
    if (exitable) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignIn(exitable: exitable)),
      );
    } else {
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn(exitable: exitable)),
      );
    }
    signingIn = false;
    print("signin success"); // just the navigation part
  } else {
    print("signin error: user already signing in");
  }
}

Future<void> logout() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('logout success');
  } catch (e) {
    print('logout error: $e');
  }
}