//google health connect에서 수면데이터 얻어오는 service
import 'package:goodsleeper/Model/Sleep_report_model.dart';
import 'package:health/health.dart';

class HealthDataService {
  HealthDataService._() {
    print("Health_Service initialize");
  }
  static final inst = HealthDataService._();

  final Health _health = Health();

  //google health connect에게서 rawData(원시 데이터만 받아서 전달)
  Future<List<HealthDataPoint>> getSleepData({
    required DateTime startTime,
    required DateTime endTime,
    required List<HealthDataType> type,
  }) async {
    List<HealthDataPoint> sleepData = [];

    try {
      //google Health Connect로부터 Data가져오기
      sleepData = await _health.getHealthDataFromTypes(
        types: type,
        startTime: startTime,
        endTime: endTime,
      );

      //중복 데이터 제거
      sleepData = _health.removeDuplicates(sleepData);
      //데이터 정렬
      sleepData.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
    } catch (e) {
      print("수면데이터 불러오기 실패 : $e");
    }
    return sleepData;
  }

  Future<bool> writeSleepDataToHealthConnect(SleepReport report) async {
    final endDate = DateTime(
      report.date.year,
      report.date.month,
      report.date.day + 1,
      8,
    ); // 다음 날 오전 8시 종료 가정
    final startDate = endDate.subtract(
      Duration(minutes: report.durationInMinutes),
    );

    // 2. 수면 단계별 데이터 작성
    // Health Connect는 각 수면 단계를 별도의 데이터 포인트로 저장합니다.
    List<Map<HealthDataType, int>> stages = [
      {HealthDataType.SLEEP_DEEP: report.deepSleepMinutes},
      {HealthDataType.SLEEP_REM: report.remSleepMinutes},
      {HealthDataType.SLEEP_LIGHT: report.lightSleepMinutes},
      {HealthDataType.SLEEP_AWAKE: report.awakeSleepMinutes},
    ];

    int currentOffsetMinutes = 0;
    bool allStagesWritten = true;

    for (var stage in stages) {
      final dataType = stage.keys.first;
      final duration = stage.values.first;

      if (duration > 0) {
        final stageStart = startDate.add(
          Duration(minutes: currentOffsetMinutes),
        );
        final stageEnd = stageStart.add(Duration(minutes: duration));

        bool stageWritten = await _health.writeHealthData(
          value: 0,
          type: dataType,
          startTime: stageStart,
          endTime: stageEnd,
        );

        if (!stageWritten) {
          allStagesWritten = false;
          print("Health Connect: 수면 단계 ($dataType) 작성 실패.");
          // 모든 단계를 시도하기 위해 루프를 깨지 않고 계속 진행
        }

        currentOffsetMinutes += duration;
      }
    }

    if (allStagesWritten) {
      print(
        "✅ Health Connect에 수면 데이터 (총 ${report.durationInMinutes}분) 작성 완료: ${startDate.toIso8601String()}",
      );
    }

    return allStagesWritten;
  }

  Future<bool> deleteSleepDataFromHealthConnect(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final typesToDelete = [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_REM,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_AWAKE,
    ];

    bool allSucceeded = true;

    try {
      for (final type in typesToDelete) {
        // Health 패키지의 delete 메서드는 HealthDataType을 하나만 받습니다.
        bool success = await _health.delete(
          type: type, // 단일 타입 전달
          startTime: startDate,
          endTime: endDate,
        );

        if (!success) {
          allSucceeded = false;
          print("❌ Health Connect: 수면 관련 데이터 삭제 실패: $type");
        } else {
          print("✅ Health Connect: 수면 관련 데이터 삭제 성공: $type");
        }
      }

      if (allSucceeded) {
        print(
          "✅ Health Connect: 모든 수면 관련 데이터 삭제 성공. (기간: ${startDate.toIso8601String()} ~ ${endDate.toIso8601String()})",
        );
      } else {
        print(
          "⚠️ Health Connect: 일부 수면 관련 데이터 삭제 실패. (기간: ${startDate.toIso8601String()} ~ ${endDate.toIso8601String()})",
        );
      }
      return allSucceeded;
    } catch (e) {
      print("Health Connect 데이터 삭제 오류: $e");
      return false;
    }
  }
}
