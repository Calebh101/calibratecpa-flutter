import 'dart:math';

import 'package:calibratecpa/util.dart';
import 'package:calibratecpa/var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>?> getFirebaseData(BuildContext context, String dataSource) async {
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
          print('User Document Data: $data');
          return data;
        } else {
          print('firebase data error: no user data available');
        }
      } else {
        print("firebase data error: no user available");
        signIn(context, false);
      }
    } else {
      print("firebase data error: firebase not initialized");
    }
  } catch (e) {
    print("firebase data error: $e");
  }
  return null;
}

Future<Map> loadData(BuildContext context, {String defaultDataSource = "firebase-localhost"}) async {
  final prefs = await SharedPreferences.getInstance();
  final dataSource = prefs.containsKey("dataSource")
      ? prefs.get("dataSource").toString()
      : defaultDataSource;

  final localIP = "127.0.0.1";
  final ports = {
    "firestore": 8080,
  };

  Map? dataS = {};

  switch (dataSource) {
    case "firebase-online":
      dataS = await getFirebaseData(context, "firebase placeholder");
    case "firebase-localhost":
      dataS = await getFirebaseData(context, "localhost:${ports["firestore"]}");
    case "firebase-localhost-remote":
      dataS = await getFirebaseData(context, "$localIP:${ports["firestore"]}");
    case "sample":
      dataS = getSampleData();
    default:
      dataS = getSampleData();
  }

  return dataS ?? getSampleData();
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
