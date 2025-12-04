import 'dart:convert';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:goodsleeper/Core/Service/Permission_service.dart';
import 'package:goodsleeper/Core/Worker/worker.dart';
import 'package:goodsleeper/Core/di/container.dart';
import 'package:goodsleeper/Core/di/dependency_factory.dart';
import 'package:goodsleeper/Core/enums.dart';

class Permissionworker implements IWorker {
  final HealthPermissionService _healthPermissionService;

  Permissionworker({required Container container})
    : _healthPermissionService = container.get<HealthPermissionService>();

  static final Map<String, List<HealthDataType>> _healthMapping = {
    PermissionTarget.sleep: [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_REM,
    ],
  };

  static final Map<String, Permission> _permMapping = {
    PermissionTarget.notification: Permission.notification,
  };

  @override
  Future run(Map<String, dynamic>? inputData) async {
    final String action =
        inputData?['action'] ?? PermissionAction.check; // 'check' or 'request'
    final String category =
        inputData?['category'] ??
        PermissionCategory.standard; // 'standard' or 'health'

    String? json = inputData?['target'];
    if (json == null) return false;
    List<dynamic> rawData = jsonDecode(json);
    List<String> target = rawData.cast<String>();

    if (category == PermissionCategory.health) {
      return await _handleHealthPermission(action, target);
    } else {
      return await _handleStandardPermission(action, target);
    }
  }

  Future<Map<String, PermissionStatus>> _handleHealthPermission(
    String action,
    List<String> targets,
  ) async {
    final entry = targets.map((target) async {
      final List<HealthDataType>? perm = _healthMapping[target];

      if (perm == null) {
        print("정의되지 않은 Permission Target: $target");
        return MapEntry(target, PermissionStatus.denied);
      }

      PermissionStatus status;
      if (action == PermissionAction.check) {
        status = await _healthPermissionService.checkHealthPermission(perm)
            ? PermissionStatus.granted
            : PermissionStatus.denied;
      } else {
        status = await _healthPermissionService.requestHealthPermission(perm)
            ? PermissionStatus.granted
            : PermissionStatus.denied;
      }

      return MapEntry(target, status);
    });

    final entries = await Future.wait(entry);
    return Map.fromEntries(entries);
  }

  Future<Map<String, PermissionStatus>> _handleStandardPermission(
    String action,
    List<String> targets,
  ) async {
    final entry = targets.map((target) async {
      final Permission? perm = _permMapping[target];

      if (perm == null) {
        print("정의되지 않은 Permission Target: $target");
        return MapEntry(target, PermissionStatus.denied);
      }

      PermissionStatus status;
      if (action == PermissionAction.check) {
        status = await perm.status;
      } else {
        status = await perm.request();
      }

      return MapEntry(target, status);
    });

    final entries = await Future.wait(entry);
    return Map.fromEntries(entries);
  }
}

Future<IWorker> createPermissionWorker(DependencyFactory factory) async {
  final types = [HealthPermissionService];

  final container = factory.createContainer(types);
  return Permissionworker(container: container);
}
