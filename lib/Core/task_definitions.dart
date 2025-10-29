import 'package:wemeet_client/di/dependency_factory.dart';

import 'background_Worker_interface.dart';

//백그라운드 작업 이름 상수 class
class TaskName {
  static const testTask = "Test";
}

typedef WorkerFactory =
    Future<BackgroundWorker> Function(DependencyFactory factory);
