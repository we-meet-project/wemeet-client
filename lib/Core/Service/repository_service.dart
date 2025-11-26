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
      inspector: true, // 개발 중에 DB 확인용 (배포 시 false 권장)
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

  // [최적화] 리포트 전송 완료 처리 (Batch update)
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

  // [추가됨] 모든 데이터 조회 (MainViewModel용)
  Future<List<SleepReport>> getAllData() async {
    // 날짜 내림차순(최신순)으로 가져오기
    return await _isar.sleepReports.where().sortByDateDesc().findAll();
  }

  Future<void> seedTestData() async {
    final random = Random();
    final List<SleepReport> dummies = [];
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      // 1. 날짜: 오늘로부터 i일 전
      final date = now.subtract(Duration(days: i));

      // 2. 수면 시간: 4시간(240분) ~ 10시간(600분) 사이 랜덤
      final durationMinutes = 240 + random.nextInt(360);

      // 3. 수면 단계 비율 (대충 합쳐서 100% 근처가 되게 랜덤 생성)
      final deep = 10 + random.nextInt(15); // 10~25%
      final rem = 15 + random.nextInt(15); // 15~30%
      // (나머지는 Light로 치지만 모델에는 필드가 없으니 생략하거나 계산)

      // 4. 수면 점수: 50 ~ 100점 사이
      final score = 50.0 + random.nextInt(50);

      final report = SleepReport(
        date: date,
        sleepScore: score,
        durationInMinutes: durationMinutes.toInt(),
        deepSleepPercent: deep.toInt(),
        remSleepPercent: rem.toInt(),
        isSent: false, // 전송 테스트도 해야 하니 false로
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
