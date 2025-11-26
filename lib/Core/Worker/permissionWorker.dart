import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wemeet_client/Core/Service/Permission_service.dart';
import 'package:wemeet_client/Core/Worker/worker.dart';
import 'package:wemeet_client/Core/di/container.dart';
import 'package:wemeet_client/Core/di/dependency_factory.dart';

class Permissionworker implements IWorker {
  final HealthPermissionService _healthPermissionService;
  final PermissionService _permissionService;

  Permissionworker({required Container container})
    : _healthPermissionService = container.get<HealthPermissionService>(),
      _permissionService = container.get<PermissionService>();

  static final Map<String, List<HealthDataType>> _healthMapping = {
    'sleep': [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_REM,
    ],
  };

  static final Map<String, List<Permission>> _permMapping = {
    'notification': [Permission.notification],
    'activity': [Permission.activityRecognition],
  };

  @override
  Future run(Map<String, dynamic>? inputData) async {
    final String action =
        inputData?['action'] ?? 'check'; // 'check' or 'request'
    final String category =
        inputData?['category'] ?? 'standard'; // 'standard' or 'health'

    final String? target = inputData?['target'];

    if (target == null) return PermissionStatus.denied.index;

    if (category == 'health') {
      // 매핑된 리스트 가져오기
      final List<HealthDataType>? targets = _healthMapping[target];
      if (targets == null) {
        print("정의되지 않은 Health Target: $target");
        return PermissionStatus.denied.index;
      }
      bool isGranted;
      if (action == 'check') {
        isGranted = await _healthPermissionService.checkHealthPermission(
          targets,
        );
      } else {
        isGranted = await _healthPermissionService.requestHealthPermission(
          targets,
        );
      }
      return isGranted
          ? PermissionStatus.granted.index
          : PermissionStatus.denied.index;
    } else {
      final List<Permission>? targets = _permMapping[target];
      if (targets == null) {
        print("정의되지 않은 Permission Target: $target");
        return PermissionStatus.denied.index;
      }
      PermissionStatus status;
      if (action == 'check') {
        status = await _permissionService.checkCurrentStatus(targets);
      } else {
        status = await _permissionService.requestPermission(targets);
      }

      return status.index;
    }
  }
}

Future<IWorker> createPermissionWorker(DependencyFactory factory) async {
  final types = [HealthPermissionService, PermissionService];

  final container = factory.createContainer(types);
  return Permissionworker(container: container);
}
