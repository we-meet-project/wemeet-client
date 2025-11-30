import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Feature/MainScreen/main_view_model.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';
// (MainViewModel import)

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 데이터 로딩
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1A1A2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Sleep Dashboard"),
        actions: [
          // [추가] 서버 동기화 버튼 (구름 아이콘)
          IconButton(
            icon: const Icon(Icons.cloud_upload, color: Colors.blueAccent),
            tooltip: "서버로 전송 (동기화)",
            onPressed: () {
              // 스낵바를 띄워서 진행 상황 알림
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("서버로 데이터를 전송합니다...")),
              );
              context.read<MainViewModel>().syncToServer();
            },
          ),
          // (기존) 테스트 데이터 생성
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.yellowAccent),
            onPressed: () => context.read<MainViewModel>().createDummyData(),
          ),
          // (기존) 데이터 삭제
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onPressed: () => context.read<MainViewModel>().clearData(),
          ),
          // (기존) 로그아웃
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<MainViewModel>().logout(context),
          ),
        ],
      ),
      body: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.reports.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: viewModel.generateReportManually, // 당겨서 새로고침(수동 생성)
            child: CustomScrollView(
              slivers: [
                // 1. 상단 여백
                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // 2. 오늘의 리포트 카드 (가장 최신)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildLatestReportCard(viewModel.latestReport),
                  ),
                ),

                // 3. 히스토리 헤더
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 30, 24, 10),
                    child: Text(
                      "Recent History",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 4. 리포트 리스트
                if (viewModel.reports.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          "저장된 수면 데이터가 없습니다.",
                          style: TextStyle(color: Colors.white38),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final report = viewModel.reports[index];
                      return _buildHistoryItem(context, report);
                    }, childCount: viewModel.reports.length),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),

      // 수동 생성 플로팅 버튼
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<MainViewModel>().generateReportManually();
        },
        backgroundColor: Colors.deepPurpleAccent,
        icon: const Icon(Icons.analytics_outlined),
        label: const Text("분석하기"),
      ),
    );
  }

  // --- 위젯: 최신 리포트 메인 카드 ---
  Widget _buildLatestReportCard(SleepReport? report) {
    if (report == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFF24243E),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            "오늘의 리포트가 없습니다.",
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    // 점수에 따른 색상
    Color scoreColor = report.sleepScore >= 80
        ? Colors.greenAccent
        : report.sleepScore >= 60
        ? Colors.amberAccent
        : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E1A47), Color(0xFF24243E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('M월 d일 (E)', 'ko_KR').format(report.date),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${report.sleepScore.round()}점",
                  style: TextStyle(
                    color: scoreColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 메인 통계 (Duration, Deep, REM)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                "총 수면",
                _formatDuration(report.durationInMinutes),
                Icons.access_time,
              ),
              _buildStatItem(
                "깊은 잠",
                "${report.deepSleepMinutes}%",
                Icons.nights_stay,
              ),
              _buildStatItem(
                "REM",
                "${report.remSleepMinutes}%",
                Icons.psychology,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, SleepReport report) {
    Color scoreColor;
    if (report.sleepScore >= 80) {
      scoreColor = const Color(0xFF69F0AE); // 부드러운 민트/초록 (GreenAccent 계열)
    } else if (report.sleepScore >= 50) {
      scoreColor = const Color(0xFFFFAB40); // 부드러운 오렌지 (OrangeAccent 계열)
    } else {
      scoreColor = const Color(0xFFFF5252); // 부드러운 레드 (RedAccent 계열)
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          // 상세 화면으로 이동 (라우트 정의 필요)
          Navigator.pushNamed(context, '/report', arguments: report);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF24243E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // 정보
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy년 M월 d일').format(report.date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "수면 시간: ${_formatDuration(report.durationInMinutes)}",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // 점수
              // Container(
              //   width: 45, // 원의 크기
              //   height: 45,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     // 점수에 따라 배경색 변경 로직
              //     color: report.sleepScore >= 80
              //         ? Colors.greenAccent[700] // 80점 이상: 초록
              //         : report.sleepScore >= 50
              //         ? Colors
              //               .orangeAccent // 50점 이상: 주황
              //         : Colors.redAccent, // 그 외: 빨강
              //   ),
              //   child: Center(
              //     child: Text(
              //       "${report.sleepScore.round()}",
              //       style: const TextStyle(
              //         color: Colors.white, // 배경이 유색이므로 글자는 흰색
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     // 1. 뒤에 깔리는 옅은 배경 링
              //     SizedBox(
              //       width: 50,
              //       height: 50,
              //       child: CircularProgressIndicator(
              //         value: 1.0, // 전체 원
              //         strokeWidth: 5,
              //         valueColor: AlwaysStoppedAnimation<Color>(
              //           Colors.grey.withOpacity(0.2), // 흐릿한 회색
              //         ),
              //       ),
              //     ),
              //     // 2. 점수만큼 차오르는 전경 링
              //     SizedBox(
              //       width: 50,
              //       height: 50,
              //       child: CircularProgressIndicator(
              //         value: report.sleepScore / 100, // 0.0 ~ 1.0 사이 값
              //         strokeWidth: 5,
              //         strokeCap: StrokeCap.round, // 끝부분 둥글게 처리 (고급짐 UP)
              //         valueColor: AlwaysStoppedAnimation<Color>(
              //           // 점수에 따른 색상 로직
              //           report.sleepScore >= 80
              //               ? Colors.greenAccent
              //               : report.sleepScore >= 50
              //               ? Colors.orangeAccent
              //               : Colors.redAccent,
              //         ),
              //       ),
              //     ),
              //     // 3. 중앙 점수 텍스트
              //     Text(
              //       "${report.sleepScore.round()}",
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ],
              // ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  // 배경: 해당 색상을 아주 옅게(15%) 깔아줍니다.
                  color: scoreColor.withValues(alpha: .15),
                  shape: BoxShape.circle,
                  // 테두리: 살짝 더 진하게 주어 경계를 깔끔하게 만듭니다. (선택사항)
                  border: Border.all(
                    color: scoreColor.withValues(alpha: .3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    "${report.sleepScore.round()}",
                    style: TextStyle(
                      color: scoreColor, // 글자는 선명한 색상 그대로 사용
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // 그림자 제거: 깔끔함을 위해 그림자는 뺍니다.
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    return "${h}시간 ${m}분";
  }
}
