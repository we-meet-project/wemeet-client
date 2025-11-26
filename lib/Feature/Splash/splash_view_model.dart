import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wemeet_client/Core/Service/Permission_service.dart';
import 'package:wemeet_client/Core/Service/localprofile_service.dart';
import 'package:wemeet_client/Core/enums.dart';
// (Service들 import)

class SplashViewModel with ChangeNotifier {
  // 싱글톤 서비스들 (DI로 주입받아도 됨)
  final _profileService = LocalprofileService.inst;
  final _permService = PermissionService.inst;
  final _healthService = HealthPermissionService.inst;

  Future<String> checkAppStatus() async {
    // 1. 약간의 딜레이 (로고를 잠깐 보여주기 위함, 선택사항)
    await Future.delayed(const Duration(milliseconds: 1500));

    // 2. 로그인 확인
    final bool isLoggedIn = _profileService.getUserId() != null;
    if (!isLoggedIn) {
      return '/login';
    }

    // 3. 권한 확인 (로그인 된 경우에만)
    final PermissionStatus isNotiGranted = await _permService
        .checkCurrentStatus(permissions);
    final bool isHealthGranted = await _healthService.checkHealthPermission(
      types,
    );
    print("Permission : $isNotiGranted");
    print("Health : $isHealthGranted");
    if (isNotiGranted == PermissionStatus.granted && isHealthGranted) {
      return '/home';
    } else {
      return '/permission';
    }
  }
}
