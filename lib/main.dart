import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

//import 'ViewModel/home_view_model.dart';
import 'ViewModel/sleep_view_model.dart';
import 'Feature/MainScreen/main_screen.dart';
import 'Feature/ReportScreen/report_screen.dart';
import 'Feature/Survey/survey_screen.dart';

void main() async {
  // Flutter 바인딩 및 intl 초기화
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);

  runApp(
    ChangeNotifierProvider(
      create: (context) => SleepViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 수면 앱에 어울리는 어두운 테마 적용
    return MaterialApp(
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

      // 앱의 메인 화면과 라우트(경로) 설정
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/report': (context) => ReportScreen(),
        '/survey': (context) => SurveyScreen(),
      },
    );
  }
}
