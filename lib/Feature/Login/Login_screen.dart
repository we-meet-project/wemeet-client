import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Core/enums.dart';
import 'package:wemeet_client/Feature/Login/Login_viewModel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreen> {
  // 아이디/비밀번호 컨트롤러 제거됨 (구글 로그인 전용)

  // 로그인 버튼 클릭 시 로직
  void _handleGoogleLogin(
    BuildContext context,
    LoginViewmodel viewModel,
  ) async {
    // 1. ViewModel 로그인 함수 호출
    final status = await viewModel.login();

    // 2. 결과 처리 (BuildContext가 유효한지 확인)
    if (!context.mounted) return;

    if (status == AuthStatus.loggedIn) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('구글 로그인 성공! 메인 화면으로 이동합니다.')),
      // );
      Navigator.pushReplacementNamed(context, '/');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인 실패. 다시 시도해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewmodel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 로고 영역
                      const Center(
                        child: Icon(
                          Icons.bedtime,
                          color: Colors.deepPurpleAccent,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 큰 타이틀
                      const Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300, // 얇은 폰트
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "사내 수면 건강 리포트 솔루션에\n오신 것을 환영합니다.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),

                      // 탭 영역 (로그인 유형 선택 - 개인/기업)
                      // 구글 계정으로 로그인하더라도 회원 유형 선택이 필요할 수 있으므로 유지
                      Text(
                        "로그인 유형을 선택해주세요",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      _buildLoginTypeTabs(viewModel),

                      const SizedBox(height: 48),

                      // 구글 로그인 버튼
                      ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () => _handleGoogleLogin(context, viewModel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // 구글 브랜드 컬러(흰색 배경)
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                            ), // 테두리
                          ),
                          elevation: 1,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // 구글 로고 아이콘 (MOCK - 실제 에셋 사용 권장)
                            const Icon(
                              Icons.g_mobiledata,
                              size: 32,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Google 계정으로 로그인',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 로딩 오버레이
              if (viewModel.isLoading)
                Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // 상단 탭 위젯
  Widget _buildLoginTypeTabs(LoginViewmodel viewModel) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
              title: "개인 회원",
              isSelected: viewModel.selectedTabIndex == 0,
              onTap: () => viewModel.changeLoginType(0),
            ),
          ),
          Expanded(
            child: _buildTabItem(
              title: "기업 회원",
              isSelected: viewModel.selectedTabIndex == 1,
              onTap: () => viewModel.changeLoginType(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ]
              : null,
          border: isSelected ? Border.all(color: Colors.grey.shade200) : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black87 : Colors.grey[500],
          ),
        ),
      ),
    );
  }
}
