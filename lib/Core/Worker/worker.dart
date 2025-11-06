//woker 작업 의존성 class
abstract class IWorker {
  Future<dynamic> run(Map<String, dynamic>? inputData);
}
