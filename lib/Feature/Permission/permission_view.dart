import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Feature/Permission/permission_view_model.dart';
// (PermissionViewModel import)

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 화면 진입 시 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PermissionViewModel>().checkPermissions();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 설정 갔다 오면 새로고침
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("View: 앱 복귀 감지 -> 권한 재확인");
      context.read<PermissionViewModel>().checkPermissions();
    }
  }

  // [핵심] 권한 요청 핸들러
  Future<void> _handlePermissionTap(
    String target,
    String category,
    String name,
  ) async {
    print("View: $name 카드 클릭됨");
    final viewModel = context.read<PermissionViewModel>();

    // 1. 요청 및 결과 대기
    final PermissionStatus status = await viewModel.requestPermission(
      target,
      category,
    );

    if (!mounted) return;

    // 2. 결과 처리
    if (status.isPermanentlyDenied) {
      print("View: 영구 거절 감지 -> 설정 다이얼로그 표시");
      _showSettingsDialog(name);
    } else if (status.isDenied) {
      print("View: 단순 거절됨 (시스템 팝업 닫힘)");
      // 필요한 경우 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$name 권한을 허용해주세요."),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (status.isGranted) {
      print("View: 권한 허용됨!");
    }
  }

  void _showSettingsDialog(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF24243E),
        title: const Text("권한 필요", style: TextStyle(color: Colors.white)),
        content: Text(
          "'$name' 권한이 거부되어 있습니다.\n설정에서 권한을 직접 허용해주세요.",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("취소", style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<PermissionViewModel>().openSettings();
            },
            child: const Text(
              "설정으로 이동",
              style: TextStyle(color: Colors.deepPurpleAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _onContinue() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1A1A2E);
    const cardColor = Color(0xFF24243E);
    const primaryColor = Colors.deepPurpleAccent;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "권한 허용",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "원활한 서비스 이용을 위해 권한이 필요합니다.",
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // 권한 리스트
              Expanded(
                child: Consumer<PermissionViewModel>(
                  builder: (context, viewModel, child) {
                    return ListView(
                      children: [
                        // 알림 권한
                        _buildPermissionCard(
                          title: "알림 (필수)",
                          description: "리포트 알림 수신",
                          icon: Icons.notifications,
                          isGranted: viewModel.isNotificationGranted,
                          onTap: () => _handlePermissionTap(
                            'notification',
                            'standard',
                            '알림',
                          ),
                          cardColor: cardColor,
                          primaryColor: primaryColor,
                        ),
                        const SizedBox(height: 16),
                        _buildPermissionCard(
                          title: "신체 활동 (필수)",
                          description: "수면 데이터 분석",
                          icon: Icons.directions_walk,
                          isGranted: viewModel.isActivityGranted,
                          onTap: () => _handlePermissionTap(
                            'activity',
                            'standard',
                            '신체 활동',
                          ),
                          cardColor: cardColor,
                          primaryColor: primaryColor,
                        ),
                        const SizedBox(height: 16),
                        // 헬스 권한
                        _buildPermissionCard(
                          title: "건강 정보 (필수)",
                          description: "수면 데이터 분석",
                          icon: Icons.health_and_safety,
                          isGranted: viewModel.isSleepGranted,
                          onTap: () =>
                              _handlePermissionTap('sleep', 'health', '건강 정보'),
                          cardColor: cardColor,
                          primaryColor: primaryColor,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // 시작하기 버튼
              Consumer<PermissionViewModel>(
                builder: (context, viewModel, child) {
                  final isReady = viewModel.isAllGranted;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isReady ? _onContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        disabledBackgroundColor: cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        isReady ? "시작하기" : "권한을 허용해주세요",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isReady ? Colors.white : Colors.white38,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 카드 위젯
  Widget _buildPermissionCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isGranted,
    required VoidCallback onTap,
    required Color cardColor,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isGranted
              ? Border.all(color: Colors.greenAccent, width: 1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isGranted ? Colors.greenAccent : primaryColor,
              size: 30,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              isGranted ? Icons.check_circle : Icons.circle_outlined,
              color: isGranted ? Colors.greenAccent : Colors.white24,
            ),
          ],
        ),
      ),
    );
  }
}
