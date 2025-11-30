import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Feature/Splash/splash_view_model.dart';
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.nights_stay_rounded,
                size: 80,
                color: Colors.deepPurpleAccent,
              ),
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
