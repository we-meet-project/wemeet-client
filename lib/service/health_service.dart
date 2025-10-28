import 'package:health/health.dart';

class HealthService {
  // HealthFactory를 사용하여 Health Connect 우선 사용
  final HealthFactory _health =
      HealthFactory(useHealthConnectIfAvailable: true);

  // 요청할 데이터 타입 정의 (수면 관련)
  static const _types = [
    HealthDataType.SLEEP_SESSION, // 총 수면 시간
    HealthDataType.SLEEP_STAGE, // 렘수면, 깊은 수면 등 단계
  ];

  // 권한 요청
  Future<bool> requestPermissions({bool background = false}) async {
    // 읽기(READ) 권한만 요청
    final permissions = _types.map((e) => HealthDataAccess.READ).toList();

    return await _health.requestAuthorization(
      _types,
      permissions: permissions,
      // 백그라운드 작업 중에는 팝업을 띄우지 않도록 설정
      rationale: background ? null : '수면 데이터 수집을 위해 권한이 필요합니다.',
    );
  }

  // 수면 데이터 조회
  Future<List<HealthDataPoint>> fetchSleepData(
      DateTime startTime, DateTime endTime) async {
    try {
      List<HealthDataPoint> sleepData =
          await _health.getHealthDataFromTypes(startTime, endTime, _types);

      // 중복 데이터 제거
      final uniqueData = <String, HealthDataPoint>{};
      for (var dp in sleepData) {
        // 고유 ID (플랫폼 + UUID)를 키로 사용
        final key = '${dp.sourceId}_${dp.uuid}';
        if (dp.uuid != null && !uniqueData.containsKey(key)) {
          uniqueData[key] = dp;
        }
      }
      return uniqueData.values.toList();
    } catch (e) {
      // print('Health 데이터 조회 오류: $e');
      rethrow;
    }
  }
}
