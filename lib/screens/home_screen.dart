import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workmanager/workmanager.dart';
import 'package:health/health.dart';

import 'package:wemeet_client/service/auth_service.dart';
import 'package:wemeet_client/service/health_service.dart';
import 'package:wemeet_client/service/firestore_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final HealthService _healthService = HealthService();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isSyncing = false;
  String _statusMessage = '버튼을 눌러 권한을 요청하세요.';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('데이터 수집기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              // AuthWrapper가 화면을 자동으로 전환
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '환영합니다, ${user?.displayName ?? '사용자'}님!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                '(${user?.email})',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _requestPermissions,
                child: const Text('1. Health Connect 권한 요청'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _registerBackgroundTask,
                child: const Text('2. 백그라운드 수집 시작'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _isSyncing ? null : _manualSync,
                child: _isSyncing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('수동으로 지금 동기화'),
              ),
              const SizedBox(height: 30),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMsg(String message) {
    if (!mounted) return;
    setState(() => _statusMessage = message);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _requestPermissions() async {
    bool granted = await _healthService.requestPermissions();
    _showMsg(granted ? '권한이 승인되었습니다.' : '권한이 거부되었습니다.');
  }

  void _registerBackgroundTask() {
    // 4시간마다 주기적으로 실행
    Workmanager().registerPeriodicTask(
      "sleepDataFetchTask", // 고유 ID
      "fetchSleepData",
      frequency: const Duration(hours: 4), // 안드로이드 최소 간격은 15분
      constraints: Constraints(
        networkType: NetworkType.connected, // 네트워크 연결 시
      ),
    );
    _showMsg('백그라운드 작업이 등록되었습니다. 4시간마다 실행됩니다.');
  }

  void _manualSync() async {
    setState(() {
      _isSyncing = true;
      _statusMessage = '동기화 중...';
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMsg('로그인이 필요합니다.');
        return;
      }

      // 1. 권한 확인
      bool granted = await _healthService.requestPermissions();
      if (!granted) {
        _showMsg('데이터 동기화를 위해 권한 승인이 필요합니다.');
        return;
      }

      // 2. 어제부터 지금까지 데이터 가져오기 (24시간)
      DateTime now = DateTime.now();
      DateTime startTime = now.subtract(const Duration(days: 1));
      List<HealthDataPoint> data =
          await _healthService.fetchSleepData(startTime, now);

      if (data.isEmpty) {
        _showMsg('새로운 수면 데이터가 없습니다.');
        return;
      }

      // 3. Firestore에 업로드
      await _firestoreService.uploadSleepData(data, user.uid);
      _showMsg('${data.length}개의 수면 데이터를 성공적으로 업로드했습니다.');
    } catch (e) {
      _showMsg('동기화 오류: $e');
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }
}
