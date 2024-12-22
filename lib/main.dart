import 'package:calibratecpa/firebase_options.dart';
import 'package:calibratecpa/home.dart';
import 'package:calibratecpa/var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
    print("firebase initialization success");
  } catch (e) {
    firebase = false;
    print("firebase initialization error: $e");
  }

  if (emulatorEnabled && firebase && kDebugMode) {
    try {
      String address = emulatorAddress;
      FirebaseFirestore.instance.useFirestoreEmulator(address, 8080);
      await FirebaseAuth.instance.useAuthEmulator(address, 9099);
      print("firebase emulator setup success: $address");
    } catch (e) {
      print("firebase emulator setup error: $e");
    }
  } else {
    print("firebase emulator setup skipped: $emulatorEnabled,$firebase,$kDebugMode");
  }

  if (firebase) {
    FirebaseFirestore.instance.settings = Settings(
      sslEnabled: false,
      persistenceEnabled: false,
    );

    await FirebaseFirestore.instance.collection('test').add({'name': 'Emulator Test'});
    print('firebase firestore host: ${FirebaseFirestore.instance.settings.host}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calibrate CPA',
      theme: brandTheme(
        darkMode: false,
        seedColor: themeColor,
        customFont: GoogleFonts.montserratTextTheme(),
      ),
      darkTheme: brandTheme(
        darkMode: true,
        seedColor: themeColor,
        customFont: GoogleFonts.montserratTextTheme(),
        useDarkBackground: true,
      ),
      home: Home(),
    );
  }
}
