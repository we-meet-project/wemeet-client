import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wemeet_client/Core/Core/taskScheduler.dart';
import 'package:wemeet_client/Feature/Login/Login_screen.dart';
import 'package:wemeet_client/Feature/Login/Login_viewModel.dart';
import 'package:wemeet_client/Feature/MainScreen/main_screen.dart';
import 'package:wemeet_client/Feature/MainScreen/main_view_model.dart';
import 'package:workmanager/workmanager.dart';
import 'package:wemeet_client/firebase_options.dart';

import 'package:wemeet_client/Core/Manager/workermanager.dart';
import 'package:wemeet_client/Core/di/dependency_factory.dart';
import 'package:wemeet_client/Core/Service/repository_service.dart';
import 'package:wemeet_client/Core/Service/notification_service.dart';
import 'package:wemeet_client/Core/Service/localprofile_service.dart';


@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((workerName, inputData) async {
    try {
      //백드라운드 환경 초기화
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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

  //서비스 객체 초기화
  await RepositoryService.inst.init();
  await LocalprofileService.inst.init();

  //알람클릭 핸들러
  void onNotificationTap(NotificationResponse response){
    print("test alarm");
  }

  await NotificationService.inst.initMainIsolate(onNotificationTap);

  //workManager 객체 초기화
  await Workmanager().initialize(callbackDispatcher);

  Taskscheduler.scheduleAllTask();

  final isLoggedIn = LocalprofileService.inst.getUserId() != null;

  final dependencyFactory = DependencyFactory();
  
  runApp(MyApp(
    factory : dependencyFactory,
    initialRoute: isLoggedIn ? '/home' : '/login',
  ));
}



class MyApp extends StatelessWidget {

  final DependencyFactory factory;
  final String initialRoute;

  const MyApp({
    super.key,
    required this.factory,
    required this. initialRoute
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //WorkerManager
        Provider<WorkerManager>(
          create: (_) => WorkerManager(factory: factory),
          ),
      ],

      child: MaterialApp(
        title: '수면 리포트 프로토타입',
        theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Color(0xFF1A1A2E), // 짙은 남색 배경
        cardColor: Color(0xFF16213E), // 카드 배경
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A1A2E),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
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
        '/login' : (context) => ChangeNotifierProvider(
          create: (context) => LoginViewmodel(workermanager: context.read<WorkerManager>(),),
          child: const LoginScreen(),
        ),
        '/home': (context) => ChangeNotifierProvider(
            create: (context) => MainViewModel(),
            child: MainScreen(),
          ),
      },
      
      
      )
    );
  }
}
