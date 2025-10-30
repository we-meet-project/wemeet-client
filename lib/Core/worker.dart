//woker 작업 의존성 class
abstract class IWorker {
  Future<bool> run(Map<String, dynamic>? inputData);
}
