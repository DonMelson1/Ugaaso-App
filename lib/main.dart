import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion/Home.dart';
import 'package:fashion/Inside.dart';
import 'package:fashion/LogIn.dart';
import 'package:fashion/SignUp.dart';
import 'package:fashion/Start_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase is already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCsYmGoidzboRhfbBEO4-UW55b12ZeF2Gw",
        appId: "1:829313253245:android:bc15a6c771e7753f9dd614",
        messagingSenderId: "829313253245",
        projectId: "fashion-e-commerce-22410",
        storageBucket: "fashion-e-commerce-22410.appspot.com",
      ),
    );
  }

  runApp(MyApp());
}

///hello guys

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyWidget());
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLogin = false;

  checkLogIn() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  void initState() {
    super.initState();
    checkLogIn();
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
    checkLogIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLogin ? Home() : Start_Page());
  }
}
