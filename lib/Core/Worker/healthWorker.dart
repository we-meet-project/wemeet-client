import 'dart:math';

import 'package:health/health.dart';

import 'package:wemeet_client/Model/Sleep_report_model.dart';
import '../Worker/worker.dart';
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
  Future<SleepReport?> run(Map<String, dynamic>? inputData) async {
    try {
      //시간범위 설정(24시간)
      final startTime =
          (inputData?['startTime'] as DateTime?) ??
          DateTime.now().subtract(const Duration(days: 1));
      final endTime = (inputData?['endTime'] as DateTime?) ?? DateTime.now();

      // final now = inputData?['startTime'] as DateTime.now();
      // final yesterDay = now.subtract(const Duration(days: 1));

      bool hasPerm = await checkHealthPermission(_types);

      if (hasPerm) {
        //데이터 가져오기
        List<HealthDataPoint> data = await _healthService.getSleepData(
          startTime: startTime,
          endTime: endTime,
          type: _types,
        );

        //가져온 데이터 확인
        if (data.isEmpty) {
          print('API 호출 성공. 하지만 해당 기간에 수면 데이터가 없습니다.');
          return null;
        }

        Duration totalSleepDuration = Duration.zero;
        Duration deepSleepDuration = Duration.zero;
        Duration remSleepDuration = Duration.zero;
        Duration lightSleepDuration = Duration.zero;
        DateTime? sessionStartTime; // 실제 수면 시작 시간

        for (var point in data) {
          //가장 이른 시작 시간을 수면 세션의 시작 시간으로 간주
          if (sessionStartTime == null ||
              point.dateFrom.isBefore(sessionStartTime)) {
            sessionStartTime = point.dateFrom;
          }

          final duration = point.dateTo.difference(point.dateFrom);

          switch (point.type) {
            case HealthDataType.SLEEP_DEEP:
              deepSleepDuration += duration;
              break;
            case HealthDataType.SLEEP_REM:
              remSleepDuration += duration;
              break;
            case HealthDataType.SLEEP_LIGHT:
              lightSleepDuration += duration;
              break;
            // SLEEP_ASLEEP, SLEEP_AWAKE는 총 수면 시간 계산 시
            // (Deep + REM + Light)의 합계를 사용할 것이므로 여기서는 집계하지 않음.
            case HealthDataType.SLEEP_ASLEEP:
            case HealthDataType.SLEEP_AWAKE:
            default:
              break;
          }
        }

        //총 수면 시간 (깊은 잠 + 얕은 잠 + REM)
        totalSleepDuration =
            deepSleepDuration + remSleepDuration + lightSleepDuration;

        if (totalSleepDuration == Duration.zero) {
          print('수면 데이터는 있으나, 유의미한 수면 단계(Deep, REM, Light) 데이터가 없습니다.');
          return null;
        }

        // 2. 백분율 계산 (총 수면 시간 대비)
        final totalMinutes = totalSleepDuration.inMinutes;
        final int deepPercent =
            ((deepSleepDuration.inMinutes / totalMinutes) * 100).round();
        final int remPercent =
            ((remSleepDuration.inMinutes / totalMinutes) * 100).round();

        // 3. 수면 점수 계산 (임시)
        double finalSleepScore = _calculateSleepScore(
          totalSleepDuration,
          deepPercent,
          remPercent,
        );

        final report = SleepReport(
          date: sessionStartTime ?? startTime,
          sleepScore: finalSleepScore,
          duration: totalSleepDuration,
          deepSleepPercent: deepPercent,
          remSleepPercent: remPercent,
        );

        return report;
      } else {
        throw HealthPermissionExpection();
      }
    } catch (e) {
      return null;
    }
  }

  //임시
  double _calculateSleepScore(
    Duration totalDuration,
    int deepPercent,
    int remPercent,
  ) {
    // 1. 총 수면 시간 (40점 만점)
    double durationScore = 0;
    final totalHours = totalDuration.inMinutes / 60.0;

    // 7~9시간을 만점으로 설정
    if (totalHours >= 7 && totalHours <= 9) {
      durationScore = 40;
    } else if (totalHours > 6 && totalHours < 7) {
      durationScore = 30; // 6-7시간
    } else if (totalHours > 9 && totalHours < 10) {
      durationScore = 30; // 9-10시간
    } else {
      durationScore = 15; // 그 외
    }

    // 2. 깊은 수면 비율 (30점 만점) - (일반적 권장 13-23%)
    double deepScore = 0;
    if (deepPercent >= 13 && deepPercent <= 23) {
      deepScore = 30;
    } else {
      // 권장 범위에서 멀어질수록 감점 (최대 15점 차감)
      double diff = (deepPercent < 13)
          ? (13 - deepPercent).toDouble()
          : (deepPercent - 23).toDouble();
      deepScore = max(15, 30 - diff * 1.5); // 최소 15점
    }

    // 3. REM 수면 비율 (30점 만점) - (일반적 권장 20-25%)
    double remScore = 0;
    if (remPercent >= 20 && remPercent <= 25) {
      remScore = 30;
    } else {
      // 권장 범위에서 멀어질수록 감점 (최대 15점 차감)
      double diff = (remPercent < 20)
          ? (20 - remPercent).toDouble()
          : (remPercent - 25).toDouble();
      remScore = max(15, 30 - diff * 1.5); // 최소 15점
    }

    // 최종 점수는 0점에서 100점 사이로 제한
    return (durationScore + deepScore + remScore).clamp(0.0, 100.0);
  }
}

Future<IWorker> createHealthWorker(DependencyFactory factory) async {
  final types = [HealthDataService];

  final container = factory.createContainer(types);

  return HealthWorker(container: container);
}
