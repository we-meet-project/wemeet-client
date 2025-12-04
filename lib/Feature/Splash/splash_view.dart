import 'package:flutter/material.dart';
import 'package:goodsleeper/Core/Service/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:goodsleeper/Feature/Splash/splash_view_model.dart';
// (SplashViewModel import)

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 그려진 후 검사 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndNavigate();
    });
  }

  Future<void> _checkAndNavigate() async {
    final notificationService = NotificationService.inst;
    final details = await notificationService.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      final payload = details.notificationResponse?.payload;
      if (payload != null) {
        debugPrint("SplashScreen: 알림으로 앱 시작. 페이로드: $payload");
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, payload);
        return; // 알림 처리 후 즉시 함수 종료
      }
    }

    final viewModel = context.read<SplashViewModel>();

    // 다음 경로 받아오기
    await viewModel.checkAppStatus();

    if (!mounted) return;

    switch (viewModel.status) {
      case SplashStatus.goHome:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case SplashStatus.goLogin:
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case SplashStatus.goPermission:
        Navigator.pushReplacementNamed(
          context,
          '/permission',
          arguments: viewModel.deniedPermissions,
        );
        break;
      case SplashStatus.error:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('초기화 중 오류가 발생했습니다.')));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 다크 테마 배경
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고 (아이콘)
            Image.asset(
              'assets/images/logo.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            // 앱 이름
            const Text(
              "Good Sleeper",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            // 로딩 인디케이터
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
