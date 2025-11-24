class PermissionViewModel {
  //권한 상태 관리
  bool _isHealthGranted = false;
  bool _isNotificationGranted = false;

  bool get isHealthGranted => _isHealthGranted;
  bool get isNotificationGranted => _isNotificationGranted;

  //필수권한 허용 확인
}