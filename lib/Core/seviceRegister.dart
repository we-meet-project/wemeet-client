import 'package:permission_handler/permission_handler.dart';
import 'package:wemeet_client/Core/workerRegister.dart';

enum PermissionRequestStatus {
  granted,            // 모든 권한이 완벽히 허용됨
  denied,             // 하나 이상의 권한이 (일시적으로) 거부됨
  permanentlyDenied,  // 하나 이상의 권한이 '영구적'으로 거부됨
  restricted,         // (iOS) 자녀보호 기능 등으로 제한됨
}

class WorkerPermissionRegister {
//worker에 필요한 권한 맵핑
  static final Map<String, List<Permission>> workerPermission = {
    WorkerName.sleepReport : [
      Permission.activityRecognition,
    ],
    WorkerName.notification : [
      Permission.notification
    ]

  };
}
