 import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:week2/auth/login.dart';
import 'package:week2/auth/signup.dart';
import 'package:week2/categories/add.dart';
import 'package:week2/homepage.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50] ,
          titleTextStyle: const TextStyle(
            color: Colors.orange,
            fontSize: 17,
            fontWeight: FontWeight.bold,),
          iconTheme: const IconThemeData(
            color: Colors.orange,
        )
        )
      ),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ? const HomePage() : const Login(),
      routes: {
        "Signup" : (context) => const Signup(),
        "Login" : (context) => const Login(),
        "Homepage" : (context) => const HomePage(),
        "AddCategory" : (context) => const AddCategory(),
      },
    );
  }
}