import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wemeet_client/Core/Core/workerRegister.dart';
import 'package:wemeet_client/Core/Manager/workermanager.dart';
import 'package:wemeet_client/Core/enums.dart';

class PermissionViewModel with ChangeNotifier {
  final WorkerManager _workerManager;

  PermissionViewModel({required WorkerManager workerManager})
    : _workerManager = workerManager;

  Map<String, PermissionStatus> _permissionStatuses = {};
  Map<String, PermissionStatus> get permissionStatuses => _permissionStatuses;

  bool get isAllGranted {
    if (_permissionStatuses.isEmpty) return false;
    return _permissionStatuses.values.every((status) => status.isGranted);
  }

  //권한 확인
  Future<void> checkPermission({
    required String category,
    required List<String> targets,
  }) async {
    await _callWorker(
      action: PermissionAction.check,
      category: category,
      targets: targets,
    );
  }

  //권한 요청
  Future<void> requestPermission({
    required String category,
    required List<String> targets,
  }) async {
    await _callWorker(
      action: PermissionAction.request,
      category: category,
      targets: targets,
    );
  }

  Future<void> _callWorker({
    required String action,
    required String category,
    required List<String> targets,
  }) async {
    try {
      final String jsonTarget = jsonEncode(targets);

      final result = await _workerManager.executeTask(WorkerName.permission, {
        'action': action,
        'category': category,
        'target': jsonTarget,
      });

      if (result is Map<String, PermissionStatus>) {
        _permissionStatuses.addAll(result);

        notifyListeners();
      }
    } catch (e) {
      print('PermissionViewModel : $e');
    }
  }

  // 3. 설정창 이동
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
