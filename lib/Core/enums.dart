import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

enum AuthStatus {
  loggedIn, // 로그인 성공
  loggedOut, // 로그아웃
  notAllowed, // 허용 목록에 없음
  error, // 기타 실패
}

class PermissionCategory {
  static const String health = 'health';
  static const String standard = 'standard';
}

class PermissionAction {
  static const String check = 'check';
  static const String request = 'request';
}

class PermissionTarget {
  static const String notification = 'notification';
  static const String sleep = 'sleep';
}

//가져올 데이터 타입
final types = [
  HealthDataType.SLEEP_ASLEEP, // 수면 중
  HealthDataType.SLEEP_AWAKE, // 수면 중 깸
  HealthDataType.SLEEP_DEEP, // 깊은 수면
  HealthDataType.SLEEP_LIGHT, // 얕은 수면
  HealthDataType.SLEEP_REM, // REM 수면
];

//필요한 권한 전체
final permissions = [Permission.notification, Permission.activityRecognition];
