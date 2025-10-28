import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';

// 서비스 클래스들을 임포트
import '../services/health_service.dart';
import '../services/firestore_service.dart';

// Workmanager는 이 함수를 별도의 Isolate에서 실행합니다.
// 반드시 최상위 함수(top-level) 또는 static 함수여야 합니다.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 백그라운드에서도 Firebase와 Health를 초기화해야 합니다.
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // 서비스 인스턴스 생성
    final healthService = HealthService();
    final firestoreService = FirestoreService();
    final auth = FirebaseAuth.instance;

    // 현재 로그인된 사용자가 없으면 작업 종료
    final user = auth.currentUser;
    if (user == null) {
      return Future.value(false); // 작업 실패 (재시도 안 함)
    }

    try {
      // 1. 건강 데이터 권한 확인
      bool granted = await healthService.requestPermissions(background: true);
      if (!granted) {
        return Future.value(false); // 권한 없으면 실패
      }

      // 2. 지난 4시간 동안의 수면 데이터 조회
      DateTime now = DateTime.now();
      DateTime startTime = now.subtract(const Duration(hours: 4));
      List<HealthDataPoint> sleepData =
          await healthService.fetchSleepData(startTime, now);

      if (sleepData.isEmpty) {
        return Future.value(true); // 새 데이터 없음. 작업 성공
      }

      // 3. Firestore에 데이터 업로드
      await firestoreService.uploadSleepData(sleepData, user.uid);

      return Future.value(true); // 작업 성공
    } catch (e) {
      // print('백그라운드 작업 오류: $e'); // 디버깅용
      return Future.value(false); // 오류 발생 시 재시도
    }
  });
}
