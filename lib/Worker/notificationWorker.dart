import 'package:wemeet_client/Service/notification_service.dart';
import 'package:wemeet_client/Worker/worker.dart';
import 'package:wemeet_client/di/container.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

class NotificationWorker implements IWorker {
  final NotificationService _notificationService;

  NotificationWorker({required Container container})
    : _notificationService = container.get<NotificationService>();

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async {
    try {
      final int id = inputData?['id'] as int ?? 0;
      final String title = inputData?['title'] as String ?? '알림';
      final String body = inputData?['body'] as String? ?? '작업이 완료되었습니다.';
      final String payload = inputData?['payload'] as String? ?? '/';

      print("notificationWorker : $payload");
      // 3-2. 필수 값이 없는 경우 실패 처리 (예: id가 유효하지 않은 경우)
      if (id == 0) {
        print("NotificationWorker: 유효한 알림 ID가 없습니다.");
        return false;
      }

      await _notificationService.showNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );

      print("NotificationWorker: 알림 전송 성공 (ID: $id)");
      return true; // 작업 성공
    } catch (e) {
      print("NotificationWorker: 알림 전송 실패 - $e");
      return false; // 작업 실패
    }
  }
}

Future<IWorker> createNotificationWorker(DependencyFactory factory) async {
  final types = [NotificationService];

  final container = factory.createContainer(types);
  return NotificationWorker(container: container);
}
