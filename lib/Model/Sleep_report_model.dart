import 'package:isar/isar.dart';

part 'Sleep_report_model.g.dart';
@collection
class SleepReport {
  Id id = Isar.autoIncrement;
  @Index()
  final DateTime date;

  final double sleepScore;

  final int durationInMinutes;
  
  final int deepSleepPercent;
  final int remSleepPercent;

  @Ignore()
  Duration get duration => Duration(minutes: durationInMinutes);

  SleepReport({
    required this.date,
    required this.sleepScore,
    required this.durationInMinutes,
    required this.deepSleepPercent,
    required this.remSleepPercent,
  });
}
