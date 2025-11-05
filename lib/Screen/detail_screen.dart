// lib/detail_screen.dart

import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String payload; // payload를 생성자에서 받습니다.

  const DetailScreen({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 화면 (Detail)'),
        // 뒤로가기 버튼 자동 생성 (Navigator.pushNamed 사용 시)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('알림을 탭하여 이동했습니다.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text(
              '전달받은 Payload:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                payload, // 생성자에서 받은 payload를 표시
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
