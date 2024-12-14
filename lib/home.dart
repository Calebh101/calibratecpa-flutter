import 'package:calibratecpa/firebase.dart';
import 'package:calibratecpa/sample.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = getSampleData();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData({String defaultDataSource = "sample"}) async {
    final prefs = await SharedPreferences.getInstance();
    final dataSource = prefs.containsKey("dataSource")
        ? prefs.get("dataSource").toString()
        : defaultDataSource;
    final port = prefs.get("dataSourcePort");
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

    data = dataS;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Calibrate Dashboard"),
        centerTitle: true,
      ),
      body: Placeholder(),
    );
  }
}
