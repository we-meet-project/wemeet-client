import 'package:wemeet_client/Worker/worker.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

class NotificationWorker implements IWorker{
  
  // final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  
  // Future<void> showTestNotification() async {
  // // Android 알림 상세 설정
  // const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //   'test_channel_id', // 채널 ID
  //   '테스트 알림',       // 채널 이름
  //   channelDescription: '알림 기능 테스트를 위한 채널입니다.',
  //   importance: Importance.max,
  //   priority: Priority.high,
  // );
  // }

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async{
    return true;

  }
}

Future<IWorker> createWorker(DependencyFactory factory) async {
  return NotificationWorker();
}