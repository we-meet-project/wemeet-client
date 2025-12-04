import 'package:flutter_test/flutter_test.dart';
import 'package:goodsleeper/Core/Service/notification_service.dart';
import 'package:goodsleeper/Core/Worker/notificationWorker.dart';
import 'package:goodsleeper/Core/di/container.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Mock 파일 생성을 위한 어노테이션
@GenerateMocks([NotificationService, Container])
import 'NotificationWorker_test.mocks.dart';

void main() {
  late NotificationWorker worker;
  late MockNotificationService mockNotificationService;
  late MockContainer mockContainer;

  setUp(() {
    // 1. 가짜 객체 생성
    mockNotificationService = MockNotificationService();
    mockContainer = MockContainer();

    // 2. Container가 가짜 서비스를 뱉도록 설정 (Stubbing)
    when(
      mockContainer.get<NotificationService>(),
    ).thenReturn(mockNotificationService);

    // 3. Worker 생성
    worker = NotificationWorker(container: mockContainer);
  });

  group('NotificationWorker 테스트', () {
    // Test 1: ID가 없는 실패 케이스
    test('inputData가 null이거나 id가 0이면 false를 반환해야 한다', () async {
      // Case A: 아예 null 입력
      bool resultNull = await worker.run(null);
      expect(resultNull, false);

      // Case B: id가 0인 경우
      bool resultZero = await worker.run({'id': 0, 'title': '테스트'});
      expect(resultZero, false);

      // 검증: 서비스 함수가 한 번이라도 호출되면 안 됨!
      verifyNever(
        mockNotificationService.showNotification(
          id: anyNamed('id'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          payload: anyNamed('payload'),
        ),
      );
    });

    // Test 2: 정상 작동 (Happy Path)
    test('필수 값이 정상적으로 들어오면 알림을 띄우고 true를 반환해야 한다', () async {
      // Given
      final input = {
        'id': 123,
        'title': '운동 알림',
        'body': '운동할 시간입니다.',
        'payload': '/workout',
      };

      // showNotification은 Future<void>이므로 완료되었다고 가정
      when(
        mockNotificationService.showNotification(
          id: 123,
          title: '운동 알림',
          body: '운동할 시간입니다.',
          payload: '/workout',
        ),
      ).thenAnswer((_) async => {});

      // When
      final result = await worker.run(input);

      // Then
      expect(result, true);

      // 실제로 서비스가 정확한 인자로 호출되었는지 검증
      verify(
        mockNotificationService.showNotification(
          id: 123,
          title: '운동 알림',
          body: '운동할 시간입니다.',
          payload: '/workout',
        ),
      ).called(1);
    });

    // Test 3: 기본값(Default Value) 처리 확인
    test('title, body 등이 없으면 기본값으로 알림을 전송해야 한다', () async {
      // Given: id만 넣고 나머지는 생략
      final input = {'id': 999};

      when(
        mockNotificationService.showNotification(
          id: 999,
          title: anyNamed('title'),
          body: anyNamed('body'),
          payload: anyNamed('payload'),
        ),
      ).thenAnswer((_) async => {});

      // When
      final result = await worker.run(input);

      // Then
      expect(result, true);

      // 검증: 코드에 적힌 기본값('알림', '작업이 완료되었습니다.', '/')이 들어갔는지 확인
      verify(
        mockNotificationService.showNotification(
          id: 999,
          title: '알림', // 기본값 체크
          body: '작업이 완료되었습니다.', // 기본값 체크
          payload: '/', // 기본값 체크
        ),
      ).called(1);
    });

    // Test 4: 예외 처리 (Exception)
    test('알림 서비스 실행 중 에러가 발생하면 false를 반환해야 한다', () async {
      // Given
      final input = {'id': 123};

      // 서비스가 에러를 뱉도록 설정
      when(
        mockNotificationService.showNotification(
          id: anyNamed('id'),
          title: anyNamed('title'),
          body: anyNamed('body'),
          payload: anyNamed('payload'),
        ),
      ).thenThrow(Exception('알림 권한 없음'));

      // When
      final result = await worker.run(input);

      // Then
      expect(result, false); // try-catch에 걸려서 false가 나와야 함
    });
  });
}
