import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dating_app/firebase_options.dart';
import 'package:dating_app/screens/home_screen.dart';
import 'package:dating_app/screens/add_post_screen.dart';
import 'package:dating_app/screens/sign_in_screen.dart';
import 'package:dating_app/screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ANALF APP',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.pinkAccent),
          titleTextStyle: TextStyle(
            color: Colors.pinkAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent).copyWith(
          primary: Colors.pinkAccent,
          surface: Colors.pinkAccent[50],
        ),
        useMaterial3: true,
      ),
      // For testing purposes, pass a hardcoded userId to HomeScreen
      home: SignInScreen(),
    );
  }
}