import 'package:wemeet_client/Core/worker.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

import '../Task/health_task.dart';

/// TaskName(String)과 WorkerFactory(Function)를 맵핑하는 정적 클래스
class TaskRegistrar {
  static final Map<String, Worker> factories = {
    TaskName.HealthTask : createWorker,
    // (새 작업이 추가되면 여기에 한 줄 추가)
  };
}

//백그라운드 작업 이름 상수 class
class TaskName {
  static const HealthTask = "HealthTask";
}

//Worker 생성 팩토리 함수 type
typedef Worker = Future<IWorker> Function(DependencyFactory factory);

