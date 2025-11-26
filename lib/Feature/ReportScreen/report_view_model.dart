import 'package:flutter/material.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';
// (SleepReport 모델 import)

class ReportViewModel with ChangeNotifier {
  final SleepReport report;

  ReportViewModel(this.report);

  // [UI용 Getter]
  // 뷰가 데이터를 편하게 쓸 수 있도록 미리 가공해 줍니다.

  String get formattedDate =>
      "${report.date.year}년 ${report.date.month}월 ${report.date.day}일";

  String get sleepDuration =>
      "${report.durationInMinutes ~/ 60}시간 ${report.durationInMinutes % 60}분";

  int get score => report.sleepScore.round();

  // 점수에 따른 상태 메시지
  String get scoreMessage {
    if (score >= 85) return "최고의 수면이에요! 🌟";
    if (score >= 70) return "좋은 수면이었어요 🌙";
    if (score >= 50) return "조금 피곤할 수 있어요 ☁️";
    return "충분한 휴식이 필요해요 💤";
  }

  Color get scoreColor {
    if (score >= 85) return Colors.greenAccent;
    if (score >= 70) return Colors.blueAccent;
    if (score >= 50) return Colors.amberAccent;
    return Colors.redAccent;
  }
}
