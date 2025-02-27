 import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:week2/auth/login.dart';
import 'package:week2/auth/signup.dart';
import 'package:week2/categories/add.dart';
import 'package:week2/filter.dart';
import 'package:week2/homepage.dart';
import 'package:week2/test.dart';

import 'firebase_options.dart';

 Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
   print("🔹 Background message received: ${message.notification?.title}");
 }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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

    setupFirebaseMessaging();

    super.initState();
  }

  void setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get FCM token
    String? myToken = await messaging.getToken();
    print("📲 FCM Token: $myToken");

    // 🔹 Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📢 Foreground Notification: ${message.notification?.title}");
      print("📜 Body: ${message.notification?.body}");
    });

    // 🔹 Handle background & terminated notifications (when tapped)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 Notification clicked! Message data: ${message.data}");
    });
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
      home:
      // (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ?
      // const HomePage() : const Login(),
      TestScreen(),
      routes: {
        "Signup" : (context) => const Signup(),
        "Login" : (context) => const Login(),
        "Homepage" : (context) => const HomePage(),
        "AddCategory" : (context) => const AddCategory(),
        "FilterFirestore" : (context) => const FilterFirestore(),
      },
    );
  }
}