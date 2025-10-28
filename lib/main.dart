import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wemeet_client/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase 초기화
  await Firebase.initializeApp();

  // Workmanager 초기화
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(),
          body: Align(
            alignment: Alignment.center,
            child: LoginScreen(),
          )),
    );
  }
}
