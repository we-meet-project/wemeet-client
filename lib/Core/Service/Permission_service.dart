import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthPermissionService {
  HealthPermissionService._() {
    print("HealthPermission_Service initialize");
  }
  static final inst = HealthPermissionService._();

  final Health _health = Health();

  //Google 엑세스 요청 메서드(포그라운드 전용)
  Future<bool> requestHealthPermission(List<HealthDataType> type) async {
    try {
      return await _health.requestAuthorization(type);
    } catch (e) {
      print("Health Request Error: $e");
      return false;
    }
  }

  //권한확인
  Future<bool> checkHealthPermission(List<HealthDataType> type) async {
    try {
      bool? hasPermission = await _health.hasPermissions(type);
      return hasPermission ?? false;
    } catch (e) {
      print("Health Check Error: $e");
      return false;
    }
  }
}

class PermissionService {
  PermissionService._() {
    print("Permission_Service initialize");
  }

  static final inst = PermissionService._();

  //모든 권한의 '현재' 상태를 확인하는 메서드
  Future<PermissionStatus> checkCurrentStatus(
    List<Permission> permissions,
  ) async {
    bool allGranted = true;

    for (var permission in permissions) {
      final status = await permission.status; // 'request'가 아닌 'status' 확인

      if (status.isPermanentlyDenied) {
        //단 하나라도 영구 거부되면, 전체 기능을 막아야 함
        return PermissionStatus.permanentlyDenied;
      }

      if (status.isRestricted) {
        //영구 거부와 유사하게, 제한된 경우도 즉시 반환
        return PermissionStatus.restricted;
      }

      if (!status.isGranted) {
        // 아직 허용되지 않은 권한이 하나라도 있음
        allGranted = false;
      }
    }

    if (allGranted) {
      // 모든 권한이 이미 허용된 상태
      return PermissionStatus.granted;
    }

    // 일부 권한이 'denied' 상태이므로, 요청이 필요함
    return PermissionStatus.denied; // (임시로 'denied'를 '요청 필요' 상태로 사용)
  }

  Future<PermissionStatus> requestPermission(
    List<Permission>? permissions,
  ) async {
    //권한이 필요없는 경우
    if (permissions == null || permissions.isEmpty) {
      return PermissionStatus.granted;
    }

    // //권한 요청전 권한 상태 확인
    // final currentStatus = await checkCurrentStatus(permissions);

    // if (currentStatus == PermissionRequestStatus.granted ||
    //     currentStatus == PermissionRequestStatus.permanentlyDenied ||
    //     currentStatus == PermissionRequestStatus.restricted) {
    //   // 이미 허용되었거나, 영구 거부/제한 상태면
    //   // 추가 요청 없이 즉시 상태 반환
    //   return currentStatus;
    // }

    //권한 순차적으로 요청
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    //결과 집게
    bool allGranted = true;
    bool restricted = false;

    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }

      if (status.isRestricted) {
        restricted = true;
      }
    });

    //우선순위에 따라 결과 반환
    if (restricted) {
      return PermissionStatus.restricted;
    }
    if (allGranted) {
      return PermissionStatus.granted;
    }

    // allGranted가 false이고, permanent/restricted가 아니면
    // 단순 'denied' (일시적 거부)임.
    return PermissionStatus.denied;
  }
}
