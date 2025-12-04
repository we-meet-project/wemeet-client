import 'package:flutter/material.dart';
import 'package:goodsleeper/Model/Sleep_report_model.dart';
// (SleepReport 모델 import)

class ReportViewModel with ChangeNotifier {
  final SleepReport _report;

  ReportViewModel(this._report);

  String get formattedDate =>
      "${_report.date.year}년 ${_report.date.month}월 ${_report.date.day}일";

  SleepReport get report => _report;

  // 점수에 따른 상태 메시지
  String get scoreMessage {
    if (report.sleepScore >= 85) return "최고의 수면이에요! 🌟";
    if (report.sleepScore >= 70) return "좋은 수면이었어요 🌙";
    if (report.sleepScore >= 50) return "조금 피곤할 수 있어요 ☁️";
    return "충분한 휴식이 필요해요 💤";
  }

  Color get scoreColor {
    if (report.sleepScore >= 85) return Colors.greenAccent;
    if (report.sleepScore >= 70) return Colors.blueAccent;
    if (report.sleepScore >= 50) return Colors.amberAccent;
    return Colors.redAccent;
  }
}
