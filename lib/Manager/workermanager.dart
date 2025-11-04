import 'package:workmanager/workmanager.dart';

import '../Worker/worker.dart';
import '../Core/workerRegister.dart';
import '../di/dependency_factory.dart';

//백그라운드 작업 등록하는 진입점
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((workerName, inputData) async {
    try {
      //백그라운드 Isolate 전용 DependencyFactory 생성
      final factory = DependencyFactory();

      //백그라운드 Isolate 전용 TaskManager 인스턴스 생성
      final taskManager = WorkerManager(factory: factory);

      //통합된 실행 로직 호출
      return await taskManager.executeTask(workerName, inputData,);
    } catch (e) {
      return false;
    }
  });
}

//작업을 실행하는 worker을 관리하는 매니저
class WorkerManager {
  final DependencyFactory _factory;

  WorkerManager({required DependencyFactory factory}) : _factory = factory;

  Future<bool> executeTask(String workerName, Map<String, dynamic>? inputData) async {
    Worker? workerFactory = WorkerRegistrar.factories[workerName];

    if (workerFactory == null) {
      print("BACKGROUND: '$workerName'에 대해 등록된 팩토리가 없음.");
      return false;
    }

    try {
      IWorker worker = await workerFactory(_factory);

      // 3. Worker를 실행.
      bool result = await worker.run(inputData);
      return result;
    } catch (e) {
      print("BACKGROUND : '$workerName': $e");
      return false;
    }
  }
}