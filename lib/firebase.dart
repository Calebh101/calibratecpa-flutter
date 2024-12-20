import 'dart:math';

import 'package:calibratecpa/var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';

Future<Map<String, dynamic>> getFirebaseData(BuildContext context) async {
  print("fetching firebase data...");
  try {
    if (firebase) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final String uid = user.uid;
        final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data == null) {
            print("firebase data error: user data is null");
            return {"error": "nulldata"};
          } else {
            print("firebase data success: $data");
            if (data.containsKey("data")) {
              print("firebase data success: verified status data");
              return data;
            } else {
              print("firebase data error: user has no status data");
              return {"error": "nostatusdata"};
            }
          }
        } else {
          print('firebase data error: no user data available');
          return {"error": "nouserdata"};
        }
      } else {
        print("firebase data error: no user available");
        return {"error": "nouser"};
      }
    } else {
      print("firebase data error: firebase not initialized");
      return {"error": "nofirebase"};
    }
  } catch (e) {
    print("firebase data error: $e");
    return {"error": "e"};
  }
}

Future<Map> loadData(BuildContext context) async {
  Map? dataS = await getFirebaseData(context);
  return dataS.containsKey("error") ? (dataS) : dataS;
}

Map<String, dynamic> getSampleData() {
  print("fetching sample data...");
  final random = Random();
  int status = random.nextInt(5);
  return {
    "data": [
      {
        "type": 1,
        "name": "Testing...",
        "status": status,
        "steps": [
          {
            "name": "Idle",
            "color": Colors.grey,
            "show": false,
          },
          {
            "name": "Awaiting Submission",
            "color": Colors.orange,
            "show": true,
          },
          {
            "name": "Processing",
            "color": Colors.yellow,
            "show": true,
          },
          {
            "name": "Almost Done",
            "color": Colors.lightGreen,
            "show": true,
          },
          {
            "name": "Complete",
            "color": Colors.green,
            "show": true,
          },
          {
            "name": "Cancelled",
            "overwriteColor": Colors.red,
            "show": false,
          }
        ],
        "documents": {
          "nodone": [
            {"name": "Not done document :( v2", "desc": "Sadly not done :("},
            {
              "name": "NDD 2 v2",
            },
          ],
          "process": [],
          "done": [],
        },
      },
      {
        "type": 2,
        "name": "Testing... 2",
        "status": status + 1,
        "steps": [
          {
            "name": "Idle 2",
            "color": Colors.grey,
            "show": false,
          },
          {
            "name": "Awaiting Submission 2",
            "color": Colors.orange,
            "show": true,
          },
          {
            "name": "Processing 2",
            "color": Colors.yellow,
            "show": true,
          },
          {
            "name": "Almost Done 2",
            "color": Colors.lightGreen,
            "show": true,
          },
          {
            "name": "Complete 2",
            "color": Colors.green,
            "show": true,
          },
          {
            "name": "Cancelled 2",
            "overwriteColor": Colors.red,
            "show": false,
          }
        ],
        "documents": {
          "nodone": [
            {"name": "Not done document :( v3", "desc": "Sadly not done :("},
            {
              "name": "NDD 2 v3",
            },
          ],
          "process": [],
          "done": [],
        },
      },
    ],
  };
}


Future<bool> signInS(BuildContext context, String email, String password) async {
  print("signing in");
  showSnackBar(context, "Loading...");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print('signed in as: ${userCredential.user?.email}');
    showSnackBar(context, "Successfully signed in as $email!");
    return true;
  } on FirebaseAuthException catch (e) {
    print('error signing in: ${e.message}');
    showSnackBar(context, "Unable to sign in. Is your username and password correct?");
    return false;
  }
}