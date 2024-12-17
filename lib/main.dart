import 'package:calibratecpa/firebase_options.dart';
import 'package:calibratecpa/home.dart';
import 'package:calibratecpa/var.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localpkg/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebase = true;
    print("flutterfire: firebase initialized");
  } catch (e) {
    firebase = false;
    print("flutterfire: firebase error: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calibrate CPA',
      theme: brandTheme(
        darkMode: false,
        seedColor: Color(0xFF1157BA),
        customFont: GoogleFonts.montserratTextTheme(),
      ),
      darkTheme: brandTheme(
        darkMode: true,
        seedColor: Color(0xFF1157BA),
        customFont: GoogleFonts.montserratTextTheme(),
        useDarkBackground: true,
      ),
      home: Home(),
    );
  }
}
