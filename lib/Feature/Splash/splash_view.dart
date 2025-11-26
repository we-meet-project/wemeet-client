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
    final String nextRoute = await viewModel.checkAppStatus();

    if (!mounted) return;

    // 화면 이동 (뒤로가기 불가능하게 교체)
    Navigator.pushReplacementNamed(context, nextRoute);
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
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.1),
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
              "Sleep Report",
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
