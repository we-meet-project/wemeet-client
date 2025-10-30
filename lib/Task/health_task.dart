import 'package:health/health.dart';
import 'package:wemeet_client/Core/worker.dart';

import '../Service/health_service.dart';
import '../di/dependency_factory.dart';
import '../di/container.dart';

class Health_task implements IWorker {
  final SleepData_Service _healthService;

  Health_task({required Container container})
      : _healthService = container.get<SleepData_Service>();

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async {
    try{
      final startTime = DateTime.now();
      final endTime = startTime.subtract(const Duration(days: 1));

      List<HealthDataPoint> rawData = await _healthService.getSleepData(startTime : startTime, endTime: endTime);
      return true;
    }
    catch(e){
      return false;
    }

  }
}

Future<IWorker> createWorker(DependencyFactory factory) async {
  final types = [SleepData_Service];

  final container = factory.createContainer(types);

  return Health_task(container: container);
}