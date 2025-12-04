import 'package:flutter_test/flutter_test.dart';
import 'package:goodsleeper/Core/Service/database_service.dart';
import 'package:goodsleeper/Core/Service/localprofile_service.dart';
import 'package:goodsleeper/Core/Service/repository_service.dart';
import 'package:goodsleeper/Core/Worker/syncWorker.dart';
import 'package:goodsleeper/Core/di/container.dart';
import 'package:goodsleeper/Model/Sleep_report_model.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Container 클래스 import 필요

// [중요] 이 어노테이션을 달면 build_runner가 가짜 클래스(Mock...)를 자동으로 만들어줍니다.
@GenerateMocks([
  DataBaseService,
  RepositoryService,
  LocalprofileService,
  Container,
])
import 'syncWorker_test.mocks.dart'; // 이 파일은 나중에 자동으로 생깁니다 (아직 없어도 당황 X)

void main() {
  late Syncworker worker;
  late MockDataBaseService mockSyncService;
  late MockRepositoryService mockRepoService;
  late MockLocalprofileService mockProfileService;
  late MockContainer mockContainer;

  // setUp: 각 테스트(test 함수)가 실행되기 전에 매번 실행되는 초기화 코드
  setUp(() {
    // 1. 가짜 객체(Mock)들 생성
    mockSyncService = MockDataBaseService();
    mockRepoService = MockRepositoryService();
    mockProfileService = MockLocalprofileService();
    mockContainer = MockContainer();

    // 2. 가짜 Container가 요청받을 때 가짜 서비스들을 뱉어내도록 설정 (Stubbing)
    when(mockContainer.get<DataBaseService>()).thenReturn(mockSyncService);
    when(mockContainer.get<RepositoryService>()).thenReturn(mockRepoService);
    when(
      mockContainer.get<LocalprofileService>(),
    ).thenReturn(mockProfileService);

    // 3. 테스트할 진짜 객체(Worker) 생성 (가짜 Container 주입)
    worker = Syncworker(container: mockContainer);
  });

  group('Syncworker 테스트', () {
    // 시나리오 1: 사용자 정보가 없으면 로직을 중단하고 true를 리턴해야 함
    test('사용자 정보(ID, Group, Company) 중 하나라도 없으면 true 반환', () async {
      // Given: 사용자 ID가 null인 상황 연출
      when(mockProfileService.getUserId()).thenReturn(null);
      when(mockProfileService.getUserCompany()).thenReturn('Comp1');
      when(mockProfileService.getUserGroup()).thenReturn('Group1');

      // When: 실행
      final result = await worker.run(null);

      // Then: true 반환 확인 & 리포트 조회 로직까지는 안 갔는지 확인
      expect(result, true);
      verifyNever(mockRepoService.getUnsentReports()); // 이 함수는 호출되면 안 됨
    });

    // 시나리오 2: 보낼 데이터가 없으면 true 리턴
    test('전송할 리포트가 없으면(Empty List) 전송 없이 true 반환', () async {
      // Given: 사용자는 정상
      when(mockProfileService.getUserId()).thenReturn('User1');
      when(mockProfileService.getUserCompany()).thenReturn('Comp1');
      when(mockProfileService.getUserGroup()).thenReturn('Group1');

      // Given: 안 보낸 리포트가 없음 (빈 리스트)
      when(mockRepoService.getUnsentReports()).thenAnswer((_) async => []);

      // When
      final result = await worker.run(null);

      // Then
      expect(result, true);
      verifyNever(
        mockSyncService.sendSleepScoresToGroup(
          reports: anyNamed('reports'),
          userId: anyNamed('userId'),
          companyId: anyNamed('companyId'),
          groupId: anyNamed('groupId'),
        ),
      ); // 전송 함수 호출되면 안 됨
    });

    // 시나리오 3: (가장 중요) 정상 처리 로직 (Happy Path)
    test('데이터가 있고 사용자도 정상이면 -> 전송하고 -> 마킹하고 -> true 반환', () async {
      // Given: 모든 조건 정상
      when(mockProfileService.getUserId()).thenReturn('User1');
      when(mockProfileService.getUserCompany()).thenReturn('Comp1');
      when(mockProfileService.getUserGroup()).thenReturn('Group1');

      // 더미 데이터 준비 (SleepReport 타입에 맞게 수정 필요)
      final dummyReports = [createDummyReport(), createDummyReport()];
      when(
        mockRepoService.getUnsentReports(),
      ).thenAnswer((_) async => dummyReports);

      // 전송 성공한다고 가정 (Future<void>)
      when(
        mockSyncService.sendSleepScoresToGroup(
          reports: dummyReports,
          userId: 'User1',
          companyId: 'Comp1',
          groupId: 'Group1',
        ),
      ).thenAnswer((_) async => {});

      // 마킹 성공한다고 가정
      when(
        mockRepoService.markReportAsSent(dummyReports),
      ).thenAnswer((_) async => {});

      // When
      final result = await worker.run(null);

      // Then
      expect(result, true);

      // 실제로 전송 함수가 호출되었는지 검증
      verify(
        mockSyncService.sendSleepScoresToGroup(
          reports: dummyReports,
          userId: 'User1',
          companyId: 'Comp1',
          groupId: 'Group1',
        ),
      ).called(1); // 1번 호출됨

      // 실제로 마킹 함수가 호출되었는지 검증
      verify(mockRepoService.markReportAsSent(dummyReports)).called(1);
    });

    // 시나리오 4: 전송 중 에러 발생 시 false 반환
    test('전송 중 에러(Exception)가 발생하면 false 반환', () async {
      // Given: 사용자 정상
      when(mockProfileService.getUserId()).thenReturn('User1');
      when(mockProfileService.getUserCompany()).thenReturn('Comp1');
      when(mockProfileService.getUserGroup()).thenReturn('Group1');

      // Given: 데이터 있음
      final dummyReports = [createDummyReport()];
      when(
        mockRepoService.getUnsentReports(),
      ).thenAnswer((_) async => dummyReports);

      // Given: 전송하려고 할 때 에러 빵! 터뜨림
      when(
        mockSyncService.sendSleepScoresToGroup(
          reports: anyNamed('reports'),
          userId: anyNamed('userId'),
          companyId: anyNamed('companyId'),
          groupId: anyNamed('groupId'),
        ),
      ).thenThrow(Exception('네트워크 오류'));

      // When
      final result = await worker.run(null);

      // Then
      expect(result, false); // false여야 함

      // 마킹은 호출되면 안 됨 (전송 실패했으니까)
      verifyNever(mockRepoService.markReportAsSent(any));
    });
  });
}

SleepReport createDummyReport({
  // 인자들을 다 null로 받을 수 있게 합니다 (입력 안 하면 기본값 쓰겠다는 뜻)
  DateTime? date,
  double? sleepScore,
  int? durationInMinutes,
  int? deepSleepMinutes,
  int? remSleepMinutes,
  int? lightSleepMinutes,
  int? awakeSleepMinutes,
  bool isSent = false, // 기본값이 있는 필드는 그대로 유지
  int? moodIndex,
  int? sleepRating,
  String? comment,
}) {
  return SleepReport(
    // 입력된 값이 있으면(?? 왼쪽) 그거 쓰고, 없으면(null이면) 기본값(?? 오른쪽) 사용
    date: date ?? DateTime.now(), // 날짜 안 넣으면 오늘 날짜
    sleepScore: sleepScore ?? 80, // 점수 안 넣으면 80점
    durationInMinutes: durationInMinutes ?? 420, // 7시간
    deepSleepMinutes: deepSleepMinutes ?? 60,
    remSleepMinutes: remSleepMinutes ?? 90,
    lightSleepMinutes: lightSleepMinutes ?? 240,
    awakeSleepMinutes: awakeSleepMinutes ?? 30,
    isSent: isSent,
    moodIndex: moodIndex,
    sleepRating: sleepRating,
    comment: comment,
  );
}
