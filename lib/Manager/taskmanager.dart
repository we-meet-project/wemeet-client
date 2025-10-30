import 'package:workmanager/workmanager.dart';

import '../Core/worker.dart';
import '../Core/task_definitions.dart';
import '../di/dependency_factory.dart';

//백그라운드 작업 등록하는 진입점
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      //백그라운드 Isolate 전용 DependencyFactory 생성
      final factory = DependencyFactory();

      //백그라운드 Isolate 전용 TaskManager 인스턴스 생성
      final taskManager = TaskManager(factory: factory);

      //통합된 실행 로직 호출
      return await taskManager.executeTask(taskName, inputData,);
    } catch (e) {
      return false;
    }
  });
}


class TaskManager {
  final DependencyFactory _factory;

  TaskManager({required DependencyFactory factory}) : _factory = factory;

  Future<bool> executeTask(String taskName, Map<String, dynamic>? inputData) async {
    Worker? workerFactory = TaskRegistrar.factories[taskName];

    if (workerFactory == null) {
      print("BACKGROUND: '$taskName'에 대해 등록된 팩토리가 없음.");
      return false;
    }

    try {
      IWorker worker = await workerFactory(_factory);

      // 3. Worker를 실행합니다.
      bool result = await worker.run(inputData);
      return result;
    } catch (e) {
      print("BACKGROUND : '$taskName': $e");
      return false;
    }
  }

}