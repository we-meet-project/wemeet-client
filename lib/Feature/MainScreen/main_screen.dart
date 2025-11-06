import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wemeet_client/ViewModel/sleep_view_model.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModel의 'reports' 리스트를 구독
    final reports = context.watch<SleepViewModel>().reports;
    final DateFormat formatter = DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR');

    return Scaffold(
      appBar: AppBar(
        title: Text('수면 기록', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12.0),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: _getScoreColor(report.sleepScore),
                child: Text(
                  report.sleepScore.toInt().toString(),
                  style: TextStyle(
                    color: _getScoreColor(report.sleepScore),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              title: Text(
                formatter.format(report.date),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                '수면 시간: ${report.duration.inHours}시간 ${report.duration.inMinutes % 60}분',
                style: TextStyle(color: Colors.grey[400]),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, '/report');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/report');
        },
        icon: Icon(Icons.bedtime_outlined),
        label: Text('수면 측정 (시뮬레이션)'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// 수면 점수에 따라 색상 반환
  Color _getScoreColor(double score) {
    if (score > 85) return Colors.greenAccent;
    if (score > 70) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
