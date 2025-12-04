import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:goodsleeper/Core/Core/taskScheduler.dart';
import 'package:goodsleeper/Feature/Login/Login_screen.dart';
import 'package:goodsleeper/Feature/Login/Login_viewModel.dart';
import 'package:goodsleeper/Feature/MainScreen/main_screen.dart';
import 'package:goodsleeper/Feature/MainScreen/main_view_model.dart';
import 'package:goodsleeper/Feature/Permission/permission_view.dart';
import 'package:goodsleeper/Feature/Permission/permission_view_model.dart';
import 'package:goodsleeper/Feature/ReportScreen/SleepDetailScreen.dart';
import 'package:goodsleeper/Feature/ReportScreen/report_view_model.dart';
import 'package:goodsleeper/Feature/Splash/splash_view.dart';
import 'package:goodsleeper/Feature/Splash/splash_view_model.dart';
import 'package:goodsleeper/Feature/Survey/survey_view_model.dart';
import 'package:goodsleeper/Model/Sleep_report_model.dart';
import 'package:workmanager/workmanager.dart';
import 'package:goodsleeper/firebase_options.dart';

import 'package:goodsleeper/Core/Manager/workermanager.dart';
import 'package:goodsleeper/Core/di/dependency_factory.dart';
import 'package:goodsleeper/Core/Service/repository_service.dart';
import 'package:goodsleeper/Core/Service/notification_service.dart';
import 'package:goodsleeper/Core/Service/localprofile_service.dart';

// 전역 네비게이터 키 생성
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((workerName, inputData) async {
    try {
      print('--- WorkManager Started at ${DateTime.now()} for $workerName ---');
      //백드라운드 환경 초기화
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await RepositoryService.inst.init(); // Isar DB
      await NotificationService.inst.initBackgroundIsolate(); // 알림
      await LocalprofileService.inst.init(); // SharedPreferences

      //백그라운드 Isolate 전용 WorkerManager 생성
      final factory = DependencyFactory();
      final taskManager = WorkerManager(factory: factory);

      //Worker 호출
      return await taskManager.executeTask(workerName, inputData);
    } catch (e) {
      return false;
    }
  });
}

void main() async {
  // Flutter 바인딩 및 intl 초기화
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('ko_KR', null);
  await RepositoryService.inst.init();
  await LocalprofileService.inst.init();

  void handleNotificationTap(NotificationResponse response) {
    final String? payload = response.payload;
    if (payload != null && navigatorKey.currentState != null) {
      print("알림 클릭 감지, payload: $payload. 화면 이동을 시도합니다.");

      navigatorKey.currentState!.pushNamed(payload);
    }
  }

  await NotificationService.inst.initMainIsolate(handleNotificationTap);

  // WorkManager 초기화
  await Workmanager().initialize(callbackDispatcher);
  await Taskscheduler.scheduleAllTask();

  final dependencyFactory = DependencyFactory();

  runApp(MyApp(factory: dependencyFactory, initialRoute: '/'));
}

class MyApp extends StatelessWidget {
  final DependencyFactory factory;
  final String initialRoute;

  const MyApp({super.key, required this.factory, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //WorkerManager
        Provider<WorkerManager>(create: (_) => WorkerManager(factory: factory)),
      ],

      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.deepPurpleAccent,
          scaffoldBackgroundColor: Color(0xFF1A1A2E), // 짙은 남색 배경
          cardColor: Color(0xFF16213E), // 카드 배경
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A2E),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.dark().copyWith(
            primary: Colors.deepPurpleAccent,
            secondary: Colors.tealAccent,
          ),
        ),
        debugShowCheckedModeBanner: false,

        // 경로 설정
        initialRoute: initialRoute,

        routes: {
          '/': (context) => ChangeNotifierProvider(
            create: (_) =>
                SplashViewModel(workManager: context.read<WorkerManager>()),
            child: const SplashScreen(),
          ),
          '/login': (context) => ChangeNotifierProvider(
            create: (context) =>
                LoginViewmodel(workermanager: context.read<WorkerManager>()),
            child: const LoginScreen(),
          ),
          '/home': (context) => ChangeNotifierProvider(
            create: (context) =>
                MainViewModel(workmanager: context.read<WorkerManager>()),
            child: const MainScreen(),
          ),
          '/permission': (context) => ChangeNotifierProvider(
            create: (_) => PermissionViewModel(
              workerManager: context.read<WorkerManager>(),
            ),
            child: const PermissionScreen(),
          ),
        },
        onGenerateRoute: (settings) {
          final uri = Uri.tryParse(settings.name ?? '');

          if (uri?.path == '/report') {
            final reportIdString = uri?.queryParameters['reportId'];
            final int? reportId = int.tryParse(reportIdString ?? '');

            if (reportId != null) {
              print('Routing via Notification Payload. Report ID: $reportId');

              return MaterialPageRoute(
                builder: (context) => ReportLoadingWrapper(reportId: reportId),
              );
            } else if (settings.arguments is SleepReport) {
              // 1. arguments에서 report 객체 꺼내기
              final report = settings.arguments as SleepReport;
              return MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (_) => ReportViewModel(report),
                    ),
                    ChangeNotifierProvider(
                      create: (_) => SurveyViewModel(report),
                    ),
                  ],
                  child: const SleepDetailScreen(),
                ),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}

class ReportLoadingWrapper extends StatelessWidget {
  final int reportId;

  const ReportLoadingWrapper({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SleepReport?>(
      future: RepositoryService.inst.getSleepReportById(reportId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 데이터 로딩 중
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final report = snapshot.data;
        if (snapshot.hasError || report == null) {
          // 에러 발생 또는 리포트 없음
          print("요청한 수면 리포트를 찾을 수 없습니다.");
          return const MainScreen();
        }

        // 로드 성공, 실제 상세 화면으로 이동 (MultiProvider 설정 포함)
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ReportViewModel(report)),
            ChangeNotifierProvider(create: (_) => SurveyViewModel(report)),
          ],
          child: const SleepDetailScreen(),
        );
      },
    );
  }
}
