import 'package:flutter/material.dart'; //flutter 패키지

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Workmanager 초기화

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
