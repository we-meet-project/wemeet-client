import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Feature/ReportScreen/report_view_model.dart';
// (ReportViewModel import)

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 배경색
    const backgroundColor = Color(0xFF1A1A2E);
    const cardColor = Color(0xFF24243E);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("수면 상세 리포트"),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Consumer<ReportViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 1. 날짜 헤더
                Text(
                  vm.formattedDate,
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                ),
                const SizedBox(height: 30),

                // 2. 점수 원형 차트 (커스텀 페인터 대신 간단히 Container 사용 예시)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: vm.scoreColor.withOpacity(0.2),
                      width: 20,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${vm.score}",
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: vm.scoreColor,
                          ),
                        ),
                        const Text(
                          "점",
                          style: TextStyle(color: Colors.white54, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 3. 상태 메시지
                Text(
                  vm.scoreMessage,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),

                // 4. 상세 데이터 그리드 (총 수면, 깊은 잠, REM 등)
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildDetailCard(
                      "총 수면 시간",
                      vm.sleepDuration,
                      Icons.access_time,
                      cardColor,
                    ),
                    _buildDetailCard(
                      "깊은 수면",
                      "${vm.report.deepSleepPercent}%",
                      Icons.bedtime,
                      cardColor,
                    ),
                    _buildDetailCard(
                      "REM 수면",
                      "${vm.report.remSleepPercent}%",
                      Icons.psychology,
                      cardColor,
                    ),
                    // Light 수면 등 추가 가능
                    // _buildDetailCard("얕은 수면", "${100 - deep - rem}%", Icons.light_mode, cardColor),
                  ],
                ),

                const SizedBox(height: 40),

                // 5. 조언 카드
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb,
                        color: Colors.amber,
                        size: 30,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "규칙적인 수면 습관이 수면 점수를 높이는 가장 좋은 방법입니다.",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white54, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white38),
          ),
        ],
      ),
    );
  }
}
