import 'package:flutter/material.dart'; //flutter 패키지

//백그라운드 작업
import 'package:workmanager/workmanager.dart'; //백그라운드 작업 패키지
import 'package:wemeet_client/Manager/backgroundTask_Manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Workmanager 초기화
  Workmanager().initialize(callbackDispatcher);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: const Align(alignment: Alignment.center),
      ),
    );
  }
}
