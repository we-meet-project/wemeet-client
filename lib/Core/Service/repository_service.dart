import 'dart:math';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class RepositoryService {
  RepositoryService._() {
    print("Repository_Service initialize");
  }

  static final inst = RepositoryService._();

  late final Isar _isar;

  Future<void> init() async {
    // [안전장치] 이미 Isar 인스턴스가 열려있다면 초기화 스킵
    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance()!;
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [SleepReportSchema],
      directory: dir.path,
      inspector: false, // 개발 중에 DB 확인용 (배포 시 false 권장)
    );
  }

  // 데이터 저장
  Future<void> saveData(SleepReport report) async {
    await _isar.writeTxn(() async {
      await _isar.sleepReports.put(report);
    });
  }

  // 날짜로 리포트 조회
  Future<SleepReport?> getReportForDate(DateTime targetDate) async {
    final startOfDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    // 다음 날 00:00:00 바로 직전까지
    final startOfNextDay = startOfDay.add(const Duration(days: 1));

    return await _isar.sleepReports
        .filter()
        .dateGreaterThan(startOfDay, include: true)
        .dateLessThan(startOfNextDay)
        .findFirst();
  }

  // 전송 안 된 리포트 조회
  Future<List<SleepReport>> getUnsentReports() async {
    return await _isar.sleepReports.filter().isSentEqualTo(false).findAll();
  }

  // 리포트 전송 완료 처리 (Batch update)
  Future<void> markReportAsSent(List<SleepReport> reports) async {
    if (reports.isEmpty) return;

    await _isar.writeTxn(() async {
      // 1. 객체들의 상태를 먼저 변경
      for (var report in reports) {
        report.isSent = true;
      }
      // 2. 한 번에 DB에 반영 (putAll 사용)
      await _isar.sleepReports.putAll(reports);
    });
  }

  // 모든 데이터 조회 (MainViewModel용)
  Future<List<SleepReport>> getAllData() async {
    // 날짜 내림차순(최신순)으로 가져오기
    return await _isar.sleepReports.where().sortByDateDesc().findAll();
  }

  Future<void> seedTestData() async {
    final random = Random();
    final List<SleepReport> dummies = [];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      // 1. 날짜: 오늘로부터 i일 전 (최신순 정렬을 원하면 0부터, 과거부터면 reversed)
      final date = now.subtract(Duration(days: i));

      // 2. 수면 점수: 50 ~ 100점 사이
      final double score = 50.0 + random.nextInt(51); // 50 ~ 100

      // 3. 전체 수면 시간: 4시간(240분) ~ 9시간(540분) 사이 랜덤
      final int totalMinutes = 240 + random.nextInt(301);

      // 4. 수면 단계별 시간 계산 (비율로 쪼개기)
      // - 깊은 잠: 전체의 15% ~ 25%
      // - REM 수면: 전체의 20% ~ 25%
      // - 깬 시간: 전체의 2% ~ 5%
      // - 얕은 잠: 나머지 전체

      final double deepRatio = 0.15 + (random.nextInt(11) / 100); // 0.15~0.25
      final double remRatio = 0.20 + (random.nextInt(6) / 100); // 0.20~0.25
      final double awakeRatio = 0.02 + (random.nextInt(4) / 100); // 0.02~0.05

      final int deepMinutes = (totalMinutes * deepRatio).toInt();
      final int remMinutes = (totalMinutes * remRatio).toInt();
      final int awakeMinutes = (totalMinutes * awakeRatio).toInt();

      // *중요* 얕은 잠은 나머지 시간으로 채워서 총합을 맞춤
      final int lightMinutes =
          totalMinutes - (deepMinutes + remMinutes + awakeMinutes);

      final report = SleepReport(
        date: date,
        sleepScore: score,
        durationInMinutes: totalMinutes,
        deepSleepMinutes: deepMinutes,
        remSleepMinutes: remMinutes,
        lightSleepMinutes: lightMinutes,
        awakeSleepMinutes: awakeMinutes,
        isSent: false, // 모델에 isSent 필드가 있다면 주석 해제
      );

      dummies.add(report);
    }

    // 5. 일괄 저장 (기존 데이터 날리고 저장할지, 추가할지는 선택)
    await _isar.writeTxn(() async {
      // await _isar.sleepReports.clear(); // (선택사항) 기존 데이터 삭제하고 싶으면 주석 해제
      await _isar.sleepReports.putAll(dummies);
    });

    print("✅ 테스트 데이터 7개 생성 완료!");
  }

  /// [테스트용] 데이터 전체 삭제 (초기화)
  Future<void> clearAllData() async {
    await _isar.writeTxn(() async {
      await _isar.sleepReports.clear();
    });
    print("🗑️ 모든 데이터 삭제 완료");
  }
}
