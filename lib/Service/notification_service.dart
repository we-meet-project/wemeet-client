import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._() {
    print("Notification_Service initialize");
  }

  static final inst = NotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  InitializationSettings _settingInit() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    return initializationSettings;
  }

  Future<void> initMainIsolate(
    void Function(NotificationResponse) onNotificationTap,
  ) async {
    await _flutterLocalNotificationsPlugin.initialize(
      _settingInit(),
      onDidReceiveNotificationResponse: onNotificationTap,
    );
  }

  Future<void> initBackgroundIsolate() async {
    WidgetsFlutterBinding.ensureInitialized();

    await _flutterLocalNotificationsPlugin.initialize(_settingInit());
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    print("notification Service : $payload");
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'high_importance_channel', // 채널 ID
          'High Importance Notifications', // 채널 이름
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
