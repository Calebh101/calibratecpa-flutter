import 'package:calibratecpa/signin.dart';
import 'package:flutter/material.dart';

bool signingIn = false;

void signIn(BuildContext context, bool exitable) async {
  if (signingIn != true) {
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
  }
}