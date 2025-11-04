import 'package:wemeet_client/Worker/worker.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

class NotificationWorker implements IWorker{
  
  @override
  Future<bool> run(Map<String, dynamic>? inputData) async{
    return true;

  }
}

Future<IWorker> createWorker(DependencyFactory factory) async {
  return NotificationWorker();
}