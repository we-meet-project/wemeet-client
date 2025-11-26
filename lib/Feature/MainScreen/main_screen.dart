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
                  color: scoreColor.withOpacity(0.2),
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
                "${report.deepSleepPercent}%",
                Icons.nights_stay,
              ),
              _buildStatItem(
                "REM",
                "${report.remSleepPercent}%",
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
              // 날짜 원형 아이콘
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    DateFormat('d').format(report.date),
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
              Text(
                "${report.sleepScore.round()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
