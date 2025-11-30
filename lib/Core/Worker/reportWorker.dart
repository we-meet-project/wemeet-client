import 'dart:math';

import 'package:health/health.dart';
import 'package:wemeet_client/Core/Service/Permission_service.dart';
import 'package:wemeet_client/Core/Service/notification_service.dart';
import 'package:wemeet_client/Core/Service/repository_service.dart';
import 'package:wemeet_client/Core/enums.dart';

import 'package:wemeet_client/Model/Sleep_report_model.dart';
import '../Worker/worker.dart';
import '../Service/health_service.dart';
import '../di/dependency_factory.dart';
import '../di/container.dart';

class ReportWorker implements IWorker {
  final HealthDataService _healthService;
  final RepositoryService _repositoryService;
  final NotificationService _notificationService;
  final HealthPermissionService _healthPermissionService;

  ReportWorker({required Container container})
    : _healthService = container.get<HealthDataService>(),
      _repositoryService = container.get<RepositoryService>(),
      _notificationService = container.get<NotificationService>(),
      _healthPermissionService = container.get<HealthPermissionService>();

  //Googel Health Connect를 통해 데이터 가져오기
  Future<SleepReport?> createReport(
    DateTime startTime,
    DateTime endTime,
  ) async {
    //데이터 가져오기
    List<HealthDataPoint> rawData = await _healthService.getSleepData(
      startTime: startTime,
      endTime: endTime,
      type: types,
    );

    //가져온 데이터 확인
    if (rawData.isEmpty) {
      print('API 호출 성공. 하지만 해당 기간에 수면 데이터가 없습니다.');
      return null;
    }

    List<HealthDataPoint> data = _findMainSleepSession(rawData);

    if (data.isEmpty) return null;

    Duration totalSleepDuration = Duration.zero;
    Duration deepSleepDuration = Duration.zero;
    Duration remSleepDuration = Duration.zero;
    Duration lightSleepDuration = Duration.zero;
    Duration awakeSleepDuration = Duration.zero;

    DateTime sessionStartTime = data.first.dateFrom;

    for (var point in rawData) {
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
        case HealthDataType.SLEEP_AWAKE:
          awakeSleepDuration += duration;
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

    // 3. 수면 점수 계산 (임시)
    double finalSleepScore = _calculateSleepScore(
      totalSleepDuration,
      ((deepSleepDuration.inMinutes / totalMinutes) * 100).round(),
      ((remSleepDuration.inMinutes / totalMinutes) * 100).round(),
    );

    final report = SleepReport(
      date: sessionStartTime,
      sleepScore: finalSleepScore,
      durationInMinutes: totalSleepDuration.inMinutes,
      deepSleepMinutes: deepSleepDuration.inMinutes,
      remSleepMinutes: remSleepDuration.inMinutes,
      lightSleepMinutes: lightSleepDuration.inMinutes,
      awakeSleepMinutes: awakeSleepDuration.inMinutes,
    );

    return report;
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

  List<HealthDataPoint> _findMainSleepSession(List<HealthDataPoint> data) {
    if (data.isEmpty) return [];

    //시간순 정렬
    data.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    List<List<HealthDataPoint>> sessions = [];
    List<HealthDataPoint> currentSession = [];

    //세션 그룹화
    //수면데이터 사이의 간격 2시간 미만이면 하나의 수면으로 취급
    const int gapThresholdHours = 2;

    for (var point in data) {
      if (currentSession.isEmpty) {
        currentSession.add(point);
        continue;
      }

      final lastPoint = currentSession.last;

      //현재 포인트 시작시간 - 이전 포인트 종료시간
      final gap = point.dateFrom.difference(lastPoint.dateTo).inHours;

      //같은 수면
      if (gap < gapThresholdHours) {
        currentSession.add(point);
      } else {
        sessions.add(List.from(currentSession));
        currentSession = [point];
      }
    }
    if (currentSession.isNotEmpty) sessions.add(currentSession);

    //가장 긴 수면시간을 가진 세션 찾기
    List<HealthDataPoint> longestSession = [];
    Duration maxDuration = Duration.zero;

    for (var session in sessions) {
      Duration sessionDuration = session.fold(
        Duration.zero,
        (prev, element) => prev + element.dateTo.difference(element.dateFrom),
      );

      if (sessionDuration > maxDuration) {
        maxDuration = sessionDuration;
        longestSession = session;
      }
    }
    return longestSession;
  }

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async {
    final bool isPeriodic = inputData?['isPeriodic'] as bool? ?? false;

    final DateTime targetDate; // report기준일
    final DateTime startTime; // 데이터 조회 시작
    final DateTime endTime; // 데이터 조회 끝

    if (isPeriodic) {
      print("백드라운드 작업시작 제발 이거 떳으면 좋겠다!!!!!!!!!!!!!");
      final now = DateTime.now(); // 8:00 AM
      final yesterday = now.subtract(const Duration(days: 1));

      targetDate = DateTime(yesterday.year, yesterday.month, yesterday.day);

      startTime = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        12,
        0,
        0,
      );
      endTime = DateTime(now.year, now.month, now.day, 11, 59, 59);
    } else {
      startTime =
          (inputData?['startTime'] as DateTime?) ??
          DateTime.now().subtract(const Duration(days: 1));
      endTime = (inputData?['endTime'] as DateTime?) ?? DateTime.now();

      targetDate = DateTime(startTime.year, startTime.month, startTime.day);
    }

    try {
      final hasPerm = await _healthPermissionService.checkHealthPermission(
        types,
      );
      if (!hasPerm) {
        return false;
      }

      //DB 중복확인
      if (await _repositoryService.getReportForDate(targetDate) != null)
        return true;

      SleepReport? report = await createReport(startTime, endTime);

      //데이터 없거나, 권한 이슈 처리
      if (report == null) {
        print('HealthWorker: 생성할 리포트가 없습니다 (데이터 없음 등).');
        return true;
      }

      //로컬 DB에 저장
      await _repositoryService.saveData(report);

      //백그라운드 호출일경우 알람 전송
      if (isPeriodic) {
        await _notificationService.showNotification(
          id: report.date.hashCode,
          title: '수면 리포트가 도착했어요! 😴',
          body: '어젯밤 수면 리포트를 탭해서 확인하세요!',
          payload: report.id.toString(),
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<IWorker> createReporthWorker(DependencyFactory factory) async {
  final types = [
    HealthDataService,
    RepositoryService,
    NotificationService,
    HealthPermissionService,
  ];

  final container = factory.createContainer(types);

  return ReportWorker(container: container);
}
