import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/Feature/ReportScreen/report_view_model.dart';

import '../MainScreen/sleep_view_model.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModel의 'currentReport'를 구독(watch)합니다.
    final report = context.watch<ReportViewModel>().report;

    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 수면 리포트'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('M월 d일 (E)', 'ko_KR').format(report.date),
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),
            SizedBox(height: 8),
            Text(
              '훌륭한 수면이었어요! 💤', // Mock 피드백
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 32),

            Center(
              child: Column(
                children: [
                  Text(
                    '수면 점수',
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  Text(
                    report.sleepScore.toInt().toString(),
                    style: TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDataInfo(
                  '총 수면',
                  '${report.duration.inHours}h ${report.duration.inMinutes % 60}m',
                ),
                _buildDataInfo('깊은 잠', '${report.deepSleepPercent}%'),
                _buildDataInfo('REM 수면', '${report.remSleepPercent}%'),
              ],
            ),
            SizedBox(height: 40),

            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFF16213E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '[ 수면 단계 그래프 영역 ]',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ),
            ),
            SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/survey');
                },
                child: Text(
                  '기상 컨디션 기록하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 세부 데이터 표시용 헬퍼 위젯
  Widget _buildDataInfo(String title, String value) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 16, color: Colors.grey[400])),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
