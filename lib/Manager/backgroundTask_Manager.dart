import 'package:wemeet_client/Core/background_Worker_interface.dart';
import 'package:wemeet_client/Task/task_register.dart';
import 'package:wemeet_client/di/dependency_factory.dart';
import 'package:workmanager/workmanager.dart';

import 'package:wemeet_client/Core/task_definitions.dart';

//백그라운드 작업 등록하는 진입점
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final backgroundservice = BackgroundRunner();

    return await backgroundservice.executeTask(taskName, inputData);
  });
}

//백그라운드 작업 호출 하는 Runner
class BackgroundRunner {
  final DependencyFactory _factory = DependencyFactory();

  Future<bool> executeTask(
    String taskName, // (변수명 오타 수정: taskNamem -> taskName)
    Map<String, dynamic>? inputData,
  ) async {
    // [조언 2: 'worker 호출 부분'을 switch 문에서 동적 팩토리로 교체]

    // 1. switch 문 대신 TaskRegistrar에서 팩토리를 찾습니다.
    WorkerFactory? workerFactory = TaskRegistrar().factories[taskName];

    if (workerFactory == null) {
      print("BACKGROUND: '$taskName'에 대해 등록된 팩토리가 없음.");
      // 등록 안된 작업 (기존 default와 동일)
      return false;
    }

    try {
      // 2. WorkerFactory(typedef)에 이 Isolate의 팩토리를 전달하여 Worker 생성
      BackgroundWorker worker = await workerFactory(_factory);

      // 3. Worker를 실행합니다.
      bool result = await worker.run(inputData);
      return result;
    } catch (e) {
      print("BACKGROUND : '$taskName': $e");
      return false;
    }
  }
}
