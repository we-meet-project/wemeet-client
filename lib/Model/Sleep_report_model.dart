import 'package:isar/isar.dart';

part 'Sleep_report_model.g.dart';

@collection
class SleepReport {
  Id id = Isar.autoIncrement;
  @Index()
  final DateTime date;

  @Index()
  bool isSent;

  final double sleepScore;
  final int durationInMinutes; //총 수면시간
  final int deepSleepMinutes; //깊은잠 시간
  final int remSleepMinutes; // 렘수면 시간
  final int lightSleepMinutes; //가변운잠 시간
  final int awakeSleepMinutes; //일어난 시간

  int? moodIndex;
  int? sleepRating;
  String? comment;

  @Ignore()
  Duration get duration => Duration(minutes: durationInMinutes);

  String get formattedTotal => formattedDuration(durationInMinutes);
  String get formattedDeepSleep => formattedDuration(deepSleepMinutes);
  String get formattedRemSleep => formattedDuration(remSleepMinutes);
  String get formattedLightSleep => formattedDuration(lightSleepMinutes);
  String get formattedAwakeSleep => formattedDuration(awakeSleepMinutes);

  double get percentDeep => percent(deepSleepMinutes);
  double get percentRem => percent(remSleepMinutes);
  double get percentLight => percent(lightSleepMinutes);
  double get percentAwake => percent(awakeSleepMinutes);

  String formattedDuration(int minutes) {
    final duration = Duration(minutes: minutes);
    return "${duration.inHours}시간 ${duration.inMinutes % 60}분";
  }

  double percent(int minute) {
    return ((Duration(minutes: minute).inMinutes / duration.inMinutes) * 100);
  }

  SleepReport({
    required this.date,
    required this.sleepScore,
    required this.durationInMinutes,
    required this.deepSleepMinutes,
    required this.remSleepMinutes,
    required this.lightSleepMinutes,
    required this.awakeSleepMinutes,
    this.isSent = false,

    this.moodIndex,
    this.sleepRating,
    this.comment,
  });
}
