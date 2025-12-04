import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:goodsleeper/Core/Core/workerRegister.dart';
import 'package:goodsleeper/Core/Manager/workermanager.dart';
import 'package:goodsleeper/Core/enums.dart';

enum SplashStatus {
  loading, // 로딩 중 (초기 상태)
  goLogin, // 로그인 안 됨 -> 로그인 화면으로 이동
  goPermission, // 로그인 됨 & 권한 부족 -> 권한 요청 화면으로 이동
  goHome, // 로그인 됨 & 권한 충족 -> 메인 홈으로 이동
  error, // 에러 발생
}

class SplashViewModel with ChangeNotifier {
  final WorkerManager _workerManager;
  SplashViewModel({required WorkerManager workManager})
    : _workerManager = workManager;

  SplashStatus _status = SplashStatus.loading;
  SplashStatus get status => _status;

  Map<String, PermissionStatus> _deniedPermissions = {};
  Map<String, PermissionStatus> get deniedPermissions => _deniedPermissions;

  Future<void> _checkPermission() async {
    final requiredStandard = [PermissionTarget.notification];
    final requiredHealth = [PermissionTarget.sleep];

    final results = await Future.wait([
      _workerManager.executeTask(WorkerName.permission, {
        'action': PermissionAction.check,
        'category': PermissionCategory.standard,
        'target': jsonEncode(requiredStandard),
      }),
      _workerManager.executeTask(WorkerName.permission, {
        'action': PermissionAction.check,
        'category': PermissionCategory.health,
        'target': jsonEncode(requiredHealth),
      }),
    ]);

    final combinedResult = {
      ...(results[0] as Map<String, PermissionStatus>),
      ...(results[1] as Map<String, PermissionStatus>),
    };

    // 3. 거부된 권한 필터링 (기존과 동일)
    final deniedList = combinedResult.entries
        .where((entry) => !entry.value.isGranted)
        .toList();

    if (deniedList.isEmpty) {
      _status = SplashStatus.goHome;
    } else {
      _deniedPermissions = Map.fromEntries(deniedList);
      _status = SplashStatus.goPermission;
    }

    notifyListeners();
  }

  Future<void> checkAppStatus() async {
    _status = SplashStatus.loading;
    notifyListeners();

    final authStatus = await _workerManager.executeTask(
      WorkerName.authentication,
      {'action': 'check'},
    );

    if (authStatus != AuthStatus.loggedIn) {
      _status = SplashStatus.goLogin;
      notifyListeners();
      return;
    }

    await _checkPermission();
  }
}
