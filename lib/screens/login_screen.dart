import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // 인증 서비스 임포트

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _signIn() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
      // AuthWrapper가 화면을 자동으로 전환
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                icon: const Icon(Icons.login), // 간단한 아이콘 예시
                label: const Text('Google로 로그인'),
                onPressed: _signIn,
              ),
      ),
    );
  }
}
