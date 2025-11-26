import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wemeet_client/Core/Core/workerRegister.dart';
import 'package:wemeet_client/Core/Manager/workermanager.dart';
import 'package:wemeet_client/Core/di/dependency_factory.dart';
// (WorkerManager, DependencyFactory 등 import)

class PermissionViewModel with ChangeNotifier {
  late final WorkerManager _workerManager;

  // 권한 상태
  bool _isNotificationGranted = false;
  bool _isSleepGranted = false;
  bool _isActivityGranted = false;

  bool get isNotificationGranted => _isNotificationGranted;
  bool get isSleepGranted => _isSleepGranted;
  bool get isActivityGranted => _isActivityGranted;
  bool get isAllGranted =>
      _isNotificationGranted && _isActivityGranted && _isSleepGranted;

  PermissionViewModel() {
    final factory = DependencyFactory();
    _workerManager = WorkerManager(factory: factory);
  }

  // 1. 초기 상태 확인
  Future<void> checkPermissions() async {
    try {
      print("ViewModel: 권한 상태 확인 중...");
      final result = await _workerManager.executeTask(WorkerName.permission, {
        'action': 'check',
        'targets': ['notification', 'sleep', 'activity'],
      });

      if (result is Map) {
        _isNotificationGranted = result['notification'] ?? false;

        // Worker에서 헬스 권한을 'sleep' 키로 보내는지 'health' 키로 보내는지 확인 필요
        // 여기서는 안전하게 둘 다 체크
        _isSleepGranted = (result['health'] ?? result['sleep']) ?? false;

        _isActivityGranted = result['activity'] ?? false;
        notifyListeners();
        print(
          "ViewModel: 상태 업데이트 완료 (알림: $_isNotificationGranted, 수면: $_isSleepGranted)",
        );
      }
    } catch (e) {
      print("ViewModel Check Error: $e");
    }
  }

  // 2. 권한 요청 (Return: PermissionStatus)
  Future<PermissionStatus> requestPermission(
    String targetKey,
    String category,
  ) async {
    print("ViewModel: $targetKey ($category) 권한 요청 시작");

    try {
      // Worker 실행 -> int 반환
      final dynamic result = await _workerManager.executeTask(
        WorkerName.permission,
        {'action': 'request', 'category': category, 'target': targetKey},
      );

      print("ViewModel: Worker 반환값 = $result (Type: ${result.runtimeType})");

      // int가 아니거나 null이면 에러 처리
      if (result is! int) {
        print("ViewModel Error: Worker가 int를 반환하지 않았습니다.");
        return PermissionStatus.denied;
      }

      // int -> PermissionStatus 변환
      final status = PermissionStatus.values[result];
      print("ViewModel: 변환된 상태 = $status");

      // 허용(Granted)된 경우 UI 업데이트
      if (status.isGranted) {
        if (targetKey == 'notification') _isNotificationGranted = true;
        if (targetKey == 'sleep') _isSleepGranted = true;
        if (targetKey == 'activity') _isActivityGranted = true;
        notifyListeners();
      } else if (status.isPermanentlyDenied) {
        print("ViewModel: 영구 거절됨");
      }

      return status;
    } catch (e) {
      print("ViewModel Request Error: $e");
      return PermissionStatus.denied;
    }
  }

  // 3. 설정창 이동
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
