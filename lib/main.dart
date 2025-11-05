//외부 패키지
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wemeet_client/Screen/detail_screen.dart';
import 'package:wemeet_client/Screen/home_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:provider/provider.dart';

//service, Permission관리자
import 'package:wemeet_client/Manager/PermissionManager.dart';
import 'package:wemeet_client/Manager/workermanager.dart';
import 'package:wemeet_client/di/dependency_factory.dart';

//Permission, worker등록 register

//Service
import 'package:wemeet_client/Service/notification_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(callbackDispatcher);

  await NotificationService.inst.initMainIsolate(_onNotificationTap);

  runApp(
    MultiProvider(
      providers: [
        Provider<DependencyFactory>(create: (_) => DependencyFactory()),
        Provider<Permissionmanager>(create: (_) => Permissionmanager()),
      ],
      child: const MyApp(),
    ),
  );
}

void _onNotificationTap(NotificationResponse response) {
  final String? payload = response.payload;

  if (payload != null && payload.isNotEmpty) {
    // navigatorKey를 사용하여 화면 이동
    navigatorKey.currentState?.pushNamed(payload);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test",
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) {
          final String? payload =
              ModalRoute.of(context)?.settings.arguments as String?;
          return DetailScreen(payload: payload ?? '전달된 payload없음');
        },
      },
    );
  }
}
