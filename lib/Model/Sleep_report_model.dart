import 'package:uuid/uuid.dart';

/// 수면 리포트 데이터를 담을 클래스 (Model)
class SleepReport {
  final String id;
  final DateTime date;
  final double sleepScore; // 0-100점
  final Duration duration; // 총 수면 시간
  final int deepSleepPercent; // 깊은 잠 비율
  final int remSleepPercent; // REM 수면 비율

  SleepReport({
    required this.id,
    required this.date,
    required this.sleepScore,
    required this.duration,
    required this.deepSleepPercent,
    required this.remSleepPercent,
  });
}
