import 'package:article/Screen/kategori.dart';
import 'package:article/Screen/profile.dart';
import 'package:article/Screen/signIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late final FirebaseApp app;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBzxs99O-I4l0dsomF7SD0Nq0xEFzXH7zg",
          appId: "1:171489056317:android:63954049c865177d033c54",
          messagingSenderId: "171489056317",
          projectId: "usernewscnn"));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignInScreen(),
      ),
    );
  }
}
