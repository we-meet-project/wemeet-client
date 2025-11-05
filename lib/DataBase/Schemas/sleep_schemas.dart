import 'package:isar/isar.dart';

part 'sleep_schemas.g.dart'; // 'flutter pub run build_runner build' 실행 필요

// ----- 1. 수면 단계를 위한 Enum -----
@enumerated
enum SleepStage { AWAKE, LIGHT, DEEP, REM, UNKNOWN }

// ----- 2. 개별 수면 단계 (자식 객체) -----
@embedded
class SleepSegment {
  @Enumerated(EnumType.name)
  SleepStage? stage;

  DateTime? startTime;
  DateTime? endTime;
  int? durationInMinutes;

  // Isar를 위한 기본 생성자
  SleepSegment({
    this.stage,
    this.startTime,
    this.endTime,
    this.durationInMinutes,
  });
}

// ----- 3. 하룻밤의 수면 세션 (부모 객체) -----
@collection
class SleepSessionData {
  Id id = Isar.autoIncrement;

  /// 쿼리를 위한 정규화된 날짜 (예: 11월 5일 00:00:00)
  /// 11월 4일 밤 11시에 자도, 이 날짜는 '11월 4일'이 되어야 함.
  @Index(type: IndexType.value)
  DateTime? sessionDate;

  // 실제 수면 시작 및 종료 시간
  DateTime? sessionStartTime;
  DateTime? sessionEndTime;

  int? totalDurationInMinutes;
  String? sourceName; // "Apple Health", "Samsung Health" 등

  /// 'SleepSegment' 리스트를 내장
  List<SleepSegment>? segments;

  // Isar를 위한 기본 생성자
  SleepSessionData({
    this.sessionDate,
    this.sessionStartTime,
    this.sessionEndTime,
    this.totalDurationInMinutes,
    this.sourceName,
    this.segments,
  });

  // --- 리포트용 편의 Getters ---
  // Isar는 이 필드를 저장하지 않음 (@ignore)

  @ignore
  int get deepSleepMinutes => _calculateTotalMinutes(SleepStage.DEEP);

  @ignore
  int get remSleepMinutes => _calculateTotalMinutes(SleepStage.REM);

  @ignore
  int get lightSleepMinutes => _calculateTotalMinutes(SleepStage.LIGHT);

  @ignore
  int get awakeMinutes => _calculateTotalMinutes(SleepStage.AWAKE);

  @ignore
  int _calculateTotalMinutes(SleepStage stage) {
    if (segments == null) return 0;
    return segments!
        .where((s) => s.stage == stage && s.durationInMinutes != null)
        .fold(0, (prev, s) => prev + s.durationInMinutes!);
  }
}
