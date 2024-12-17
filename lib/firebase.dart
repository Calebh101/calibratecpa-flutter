import 'dart:math';

import 'package:calibratecpa/var.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map> getFirebaseData(String dataSource) async {
  print("fetching firebase data...");
  if (firebase) {
    // TODO
    return getSampleData();
  } else {
    print("firebase data error: firebase not initialized");
    return getSampleData();
  }
}

Future<Map> loadData({String defaultDataSource = "sample"}) async {
  final prefs = await SharedPreferences.getInstance();
  final dataSource = prefs.containsKey("dataSource")
      ? prefs.get("dataSource").toString()
      : defaultDataSource;
  final port =
      prefs.containsKey("dataSourcePort") ? prefs.get("dataSourcePort") : 8080;
  Map dataS = {};

  switch (dataSource) {
    case "firebase-online":
      dataS = await getFirebaseData("firebase placeholder");
    case "firebase-localhost":
      dataS = await getFirebaseData("localhost:$port");
    case "sample":
      dataS = getSampleData();
    default:
      dataS = getSampleData();
  }

  return dataS;
}

Map getSampleData() {
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
