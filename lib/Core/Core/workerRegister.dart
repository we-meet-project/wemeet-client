import 'package:wemeet_client/Core/Worker/authWorker.dart';
import 'package:wemeet_client/Core/Worker/permissionWorker.dart';
import 'package:wemeet_client/Core/Worker/syncWorker.dart';

import '../di/dependency_factory.dart';
import '../Worker/worker.dart';
import '../Worker/reportWorker.dart';
import '../Worker/notificationWorker.dart';

/// WorkerName(String)과 WorkerFactory(Function)를 맵핑하는 정적 클래스
class WorkerRegistrar {
  static final Map<String, Worker> factories = {
    WorkerName.sleepReport: createReporthWorker,
    WorkerName.notification: createNotificationWorker,
    WorkerName.authentication: createAuthWorker,
    WorkerName.permission: createPermissionWorker,
    WorkerName.sync: createSyncWorker,
  };
}

//Worker이름 상수 class
class WorkerName {
  static const sleepReport = "SleepReport";
  static const notification = "Notification";
  static const authentication = "Authentication";
  static const permission = 'Permission';
  static const sync = 'Sync';
}

//Worker 생성 팩토리 함수 type
typedef Worker = Future<IWorker> Function(DependencyFactory factory);
