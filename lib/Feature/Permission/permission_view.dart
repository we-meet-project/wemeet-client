import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Feature/Permission/permission_view_model.dart';
import 'package:wemeet_client/Core/enums.dart';
// (PermissionViewModel import)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 필요한 다른 import 들 (PermissionStatus, PermissionTarget 등)

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen>
    with WidgetsBindingObserver {
  // 권한 타겟 정의 (상수로 관리하거나 별도 파일에 있는 값을 사용하세요)
  static const String targetNotification = PermissionTarget.notification;
  static const String targetSleep = PermissionTarget.sleep;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 화면 진입 시 전체 권한 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAllPermissions();
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
      _checkAllPermissions();
    }
  }

  // 모든 필수 권한 상태 확인
  void _checkAllPermissions() {
    final viewModel = context.read<PermissionViewModel>();

    // 알림 & 활동 (Standard 카테고리 가정)
    viewModel.checkPermission(
      category: PermissionCategory.standard,
      targets: [targetNotification],
    );

    // 건강 (Health 카테고리 가정)
    viewModel.checkPermission(category: 'health', targets: [targetSleep]);
  }

  Future<void> _handlePermissionTap(
    String target,
    String category,
    String name,
  ) async {
    print("View: $name 카드 클릭됨");
    final viewModel = context.read<PermissionViewModel>();

    // 1. 요청 (ViewModel이 상태를 업데이트할 때까지 대기)
    // 리팩토링된 VM은 void를 반환하므로 await만 수행
    await viewModel.requestPermission(category: category, targets: [target]);

    if (!mounted) return;

    // 2. 결과 처리 (업데이트된 ViewModel의 Map에서 상태 조회)
    final PermissionStatus status =
        viewModel.permissionStatuses[target] ?? PermissionStatus.denied;

    if (status.isPermanentlyDenied) {
      print("View: 영구 거절 감지 -> 설정 다이얼로그 표시");
      _showSettingsDialog(name);
    } else if (status.isDenied) {
      print("View: 단순 거절됨");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$name 권한을 허용해주세요."),
          duration: const Duration(seconds: 1),
        ),
      );
    } else if (status.isGranted) {
      print("View: $name 권한 허용됨!");
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

  // Map에서 상태를 안전하게 가져오는 헬퍼 함수
  bool _isGranted(PermissionViewModel vm, String target) {
    return vm.permissionStatuses[target]?.isGranted ?? false;
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
                          // Map에서 상태 조회
                          isGranted: _isGranted(viewModel, targetNotification),
                          onTap: () => _handlePermissionTap(
                            targetNotification,
                            PermissionCategory.standard,
                            '알림',
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
                          isGranted: _isGranted(viewModel, targetSleep),
                          onTap: () => _handlePermissionTap(
                            targetSleep,
                            'health',
                            '건강 정보',
                          ),
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
                  // ViewModel의 getter 사용
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

  // 카드 위젯 (변경 없음)
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
