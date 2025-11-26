import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Core/enums.dart';
import 'package:wemeet_client/Feature/Login/Login_viewModel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handLogin(BuildContext context) async {
    final viewModel = Provider.of<LoginViewmodel>(context, listen: false);

    final status = await viewModel.login();

    if (!context.mounted) return;

    switch (status) {
      case AuthStatus.loggedIn:
        // 성공 -> 홈으로 이동
        Navigator.pushReplacementNamed(context, '/permission');
        break;
      case AuthStatus.notAllowed:
        // 실패 -> 다이얼로그
        _showErrorDialog(context, "관리자에 의해 승인된 계정만 사용할 수 있습니다.");
        break;
      case AuthStatus.error:
        // 실패 -> 스낵바
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("로그인에 실패했습니다.")));
        break;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("로그인 실패"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // 배경색
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
            children: [
              const Spacer(flex: 3),

              // 작은 로고
              const Icon(
                Icons.bedtime,
                color: Colors.deepPurpleAccent,
                size: 40,
              ),
              const SizedBox(height: 20),

              // 큰 타이틀
              const Text(
                "Welcome\nBack.",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300, // 얇은 폰트
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "사내 수면 건강 리포트 솔루션에\n오신 것을 환영합니다.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.6),
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 4),

              // 로그인 버튼
              Consumer<LoginViewmodel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      // 테두리 버튼 스타일
                      onPressed: () => _handLogin(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 구글 'G' 로고 이미지가 있다면 여기에 Image.asset(...)
                          Icon(Icons.g_mobiledata, size: 30),
                          SizedBox(width: 8),
                          Text("Google Workspace 계정으로 로그인"),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
