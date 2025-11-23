import 'package:workmanager/workmanager.dart';

import '../Worker/worker.dart';
import '../Core/workerRegister.dart';
import '../di/dependency_factory.dart';
import '../Service/notification_service.dart';

//작업을 실행하는 worker을 관리하는 매니저
class WorkerManager {
  final DependencyFactory _factory;

  WorkerManager({required DependencyFactory factory}) : _factory = factory;

  Future<dynamic> executeTask(
    String workerName,
    Map<String, dynamic>? inputData,
  ) async {
    Worker? workerFactory = WorkerRegistrar.factories[workerName];

    if (workerFactory == null) {
      ("'$workerName'에 대해 등록된 팩토리가 없음.");
      return false;
    }

    try {
      IWorker worker = await workerFactory(_factory);

      // 3. Worker를 실행.
      final dynamic result = await worker.run(inputData);
      return result;
    } catch (e) {
      print("'$workerName': $e");
      return false;
    }
  }
}
