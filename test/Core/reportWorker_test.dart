import 'package:flutter_test/flutter_test.dart';
import 'package:goodsleeper/Core/Service/Permission_service.dart';
import 'package:goodsleeper/Core/Service/health_service.dart';
import 'package:goodsleeper/Core/Service/notification_service.dart';
import 'package:goodsleeper/Core/Service/repository_service.dart';
import 'package:goodsleeper/Core/Worker/reportWorker.dart';
import 'package:goodsleeper/Core/di/container.dart';
import 'package:goodsleeper/Model/Sleep_report_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:health/health.dart';

// Mocks 생성
@GenerateMocks([
  Container,
  HealthDataService,
  RepositoryService,
  NotificationService,
  HealthPermissionService,
])
import 'report_worker_test.mocks.dart';

void main() {
  late ReportWorker worker;
  late MockContainer mockContainer;
  late MockHealthDataService mockHealthService;
  late MockRepositoryService mockRepoService;
  late MockNotificationService mockNotiService;
  late MockHealthPermissionService mockPermService;

  setUp(() {
    mockContainer = MockContainer();
    mockHealthService = MockHealthDataService();
    mockRepoService = MockRepositoryService();
    mockNotiService = MockNotificationService();
    mockPermService = MockHealthPermissionService();

    // 의존성 주입 설정
    when(mockContainer.get<HealthDataService>()).thenReturn(mockHealthService);
    when(mockContainer.get<RepositoryService>()).thenReturn(mockRepoService);
    when(mockContainer.get<NotificationService>()).thenReturn(mockNotiService);
    when(
      mockContainer.get<HealthPermissionService>(),
    ).thenReturn(mockPermService);

    worker = ReportWorker(container: mockContainer);
  });

  // 테스트용 헬퍼 함수: HealthDataPoint 생성
  HealthDataPoint createPoint(HealthDataType type, DateTime from, int minutes) {
    return HealthDataPoint(
      uuid: 'test_uuid',
      value: NumericHealthValue(numericValue: minutes.toDouble()),
      type: type,
      unit: HealthDataUnit.MINUTE,
      dateFrom: from,
      dateTo: from.add(Duration(minutes: minutes)),
      sourcePlatform: HealthPlatformType.googleHealthConnect,
      sourceDeviceId: 'test_device',
      sourceId: 'test_source',
      sourceName: 'test_source_name',
    );
  }

  group('ReportWorker Tests', () {
    // 공통적으로 권한은 허용되어 있다고 가정
    setUp(() {
      when(
        mockPermService.checkHealthPermission(any),
      ).thenAnswer((_) async => true);
    });

    test('권한이 없으면 false를 반환하고 중단해야 한다', () async {
      // Given
      when(
        mockPermService.checkHealthPermission(any),
      ).thenAnswer((_) async => false);

      // When
      final result = await worker.run({'isPeriodic': true});

      // Then
      expect(result, false);
      verifyNever(mockRepoService.saveData(any));
    });

    test('이미 해당 날짜 리포트가 존재하면 true를 반환하고 중단해야 한다', () async {
      // Given
      // 이미 리포트가 있다고 가정 (객체 리턴)
      when(mockRepoService.getReportForDate(any)).thenAnswer(
        (_) async => SleepReport(
          date: DateTime.now(),
          sleepScore: 80,
          durationInMinutes: 480,
          deepSleepMinutes: 60,
          remSleepMinutes: 60,
          lightSleepMinutes: 60,
          awakeSleepMinutes: 0,
        ),
      );

      // When
      final result = await worker.run({'isPeriodic': true});

      // Then
      expect(result, true);
      // 저장 로직은 실행되지 않아야 함
      verifyNever(
        mockHealthService.getSleepData(
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
          type: anyNamed('type'),
        ),
      );
    });

    test('데이터가 없고 Periodic 작업이면 "동기화 필요" 알림을 보내야 한다', () async {
      // Given
      when(mockRepoService.getReportForDate(any)).thenAnswer((_) async => null);
      when(
        mockHealthService.getSleepData(
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
          type: anyNamed('type'),
        ),
      ).thenAnswer((_) async => []); // 빈 데이터

      // When
      final result = await worker.run({'isPeriodic': true});

      // Then
      expect(result, true);
      verify(
        mockNotiService.showNotification(
          id: anyNamed('id'),
          title: contains('동기화 필요'), // 제목 일부 매칭
          body: anyNamed('body'),
          payload: anyNamed('payload'),
        ),
      ).called(1);
      verifyNever(mockRepoService.saveData(any));
    });

    test('정상적인 수면 데이터가 있으면 리포트를 생성하고 저장 및 "완료" 알림을 보내야 한다', () async {
      // Given
      final now = DateTime.now();
      final startTime = now.subtract(Duration(hours: 8));

      // 8시간 수면 데이터 생성 (Deep 2h, Light 4h, REM 2h)
      final List<HealthDataPoint> mockData = [
        createPoint(HealthDataType.SLEEP_DEEP, startTime, 120),
        createPoint(
          HealthDataType.SLEEP_LIGHT,
          startTime.add(Duration(minutes: 120)),
          240,
        ),
        createPoint(
          HealthDataType.SLEEP_REM,
          startTime.add(Duration(minutes: 360)),
          120,
        ),
      ];

      when(mockRepoService.getReportForDate(any)).thenAnswer((_) async => null);
      when(
        mockHealthService.getSleepData(
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
          type: anyNamed('type'),
        ),
      ).thenAnswer((_) async => mockData);

      // 저장 성공 Mocking
      when(mockRepoService.saveData(any)).thenAnswer((_) async => {});

      // When
      final result = await worker.run({'isPeriodic': true});

      // Then
      expect(result, true);

      // 1. 저장이 호출되었는지 + 데이터 검증
      final captured = verify(mockRepoService.saveData(captureAny)).captured;
      final savedReport = captured.first as SleepReport;

      expect(savedReport.durationInMinutes, 480); // 8시간 = 480분
      expect(savedReport.deepSleepMinutes, 120);
      expect(savedReport.sleepScore, greaterThan(0)); // 점수가 계산되었는지

      // 2. 성공 알림이 호출되었는지
      verify(
        mockNotiService.showNotification(
          id: anyNamed('id'),
          title: contains('리포트가 도착'),
          body: anyNamed('body'),
          payload: anyNamed('payload'),
        ),
      ).called(1);
    });

    test('세션 분리 로직: 3시간 갭이 있으면 더 긴 세션 하나만 리포트로 만들어야 한다', () async {
      // Given
      final start1 = DateTime(2023, 1, 1, 22, 0); // 밤 10시

      // 세션 1: 1시간 낮잠 (Light 60m)
      final session1 = [createPoint(HealthDataType.SLEEP_LIGHT, start1, 60)];

      // 3시간 갭 (11:00 ~ 02:00) -> gapThresholdHours(2) 보다 큼

      final start2 = DateTime(2023, 1, 2, 2, 0); // 새벽 2시
      // 세션 2: 5시간 본수면 (Deep 60m + Light 240m)
      final session2 = [
        createPoint(HealthDataType.SLEEP_DEEP, start2, 60),
        createPoint(
          HealthDataType.SLEEP_LIGHT,
          start2.add(Duration(minutes: 60)),
          240,
        ),
      ];

      // 순서 섞어서 전달 (정렬 로직 테스트 겸)
      final allData = [...session2, ...session1];

      when(mockRepoService.getReportForDate(any)).thenAnswer((_) async => null);
      when(
        mockHealthService.getSleepData(
          startTime: anyNamed('startTime'),
          endTime: anyNamed('endTime'),
          type: anyNamed('type'),
        ),
      ).thenAnswer((_) async => allData);

      // When
      await worker.run({'isPeriodic': false}); // 알림 없이 실행

      // Then
      final captured = verify(mockRepoService.saveData(captureAny)).captured;
      final savedReport = captured.first as SleepReport;

      // 더 긴 세션인 session2 (300분)의 데이터만 저장되어야 함
      expect(savedReport.durationInMinutes, 300);
      expect(savedReport.deepSleepMinutes, 60);

      // session1의 데이터는 포함되면 안됨
      expect(savedReport.durationInMinutes, isNot(360));
    });
  });
}
