import 'package:wemeet_client/Worker/worker.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

import '../Worker/healthWorker.dart';

/// WorkerName(String)과 WorkerFactory(Function)를 맵핑하는 정적 클래스
class WorkerRegistrar {
  static final Map<String, Worker> factories = {
    WorkerName.sleepReport : createWorker,
  };
}

//Worker이름 상수 class
class WorkerName {
  static const sleepReport = "SleepReport";
  static const notification = "Notification";
}

//Worker 생성 팩토리 함수 type
typedef Worker = Future<IWorker> Function(DependencyFactory factory);

