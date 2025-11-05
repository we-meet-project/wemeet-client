import 'package:health/health.dart';
import 'package:wemeet_client/Worker/worker.dart';

import '../Service/health_service.dart';
import '../di/dependency_factory.dart';
import '../di/container.dart';

class HealthWorker implements IWorker {
  final HealthDataService _healthService;

  HealthWorker({required Container container})
    : _healthService = container.get<HealthDataService>();

  //가져올 데이터 타입
  static final _types = [
    HealthDataType.SLEEP_ASLEEP, // 수면 중
    HealthDataType.SLEEP_AWAKE, // 수면 중 깸
    HealthDataType.SLEEP_DEEP, // 깊은 수면
    HealthDataType.SLEEP_LIGHT, // 얕은 수면
    HealthDataType.SLEEP_REM, // REM 수면
  ];

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async {
    try {
      //시간범위 설정(24시간)
      final now = DateTime.now();
      final yesterDay = now.subtract(const Duration(days: 1));

      bool hasPerm = await requestHealthPermission(_types);

      if (hasPerm) {
        //데이터 가져오기
        List<HealthDataPoint> data = await _healthService.getSleepData(
          startTime: yesterDay,
          endTime: now,
          type: _types,
        );

        if (data.isEmpty) {
          print('✅ API 호출 성공. 하지만 해당 기간에 수면 데이터가 없습니다.');
        } else {
          print('✅ API 호출 성공! 총 ${data.length}개의 수면 데이터를 가져왔습니다.');
          print('가져온 데이터 샘플: ${data.first.toString()}'); // 데이터 내용 확인
        }
        return true;
      } else {
        throw HealthPermissionExpection();
      }
    } catch (e) {
      return false;
    }
  }
}

Future<IWorker> createHealthWorker(DependencyFactory factory) async {
  final types = [HealthDataService];

  final container = factory.createContainer(types);

  return HealthWorker(container: container);
}
