//woker 작업 의존성 class

import'./module/container.dart';

abstract class BackgroundWorker{
  Future<bool> run(Map<String, dynamic>? inputData);
}

//백그라운드 작업 이름 상수 class
class TaskName{
  static const testTask = "abracadabra";
}

typedef WorkerFactory = Future<BackgroundWorker> Function(Container container);
