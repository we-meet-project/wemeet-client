//woker 작업 의존성 class
abstract class BackgroundWorker {
  Future<bool> run(Map<String, dynamic>? inputData);
}
