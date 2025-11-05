import 'package:isar/isar.dart';
import 'package:PROJECT_NAME/Database/isar_service.dart';
import 'package:PROJECT_NAME/Database/schemas/sleep_schemas.dart';

class SleepLocalDatasource {
  final Isar _isar;

  // DI를 통해 Isar 인스턴스를 받거나, IsarService에서 직접 가져옴
  SleepLocalDatasource({Isar? isar}) : _isar = isar ?? IsarService.instance;

  /// 특정 날짜 범위의 수면 세션 데이터를 가져옵니다.
  /// (날짜는 00:00:00으로 정규화되어야 함)
  Future<List<SleepSessionData>> getSleepSessions(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await _isar.sleepSessionDatas
        .where()
        .sessionDateBetween(startDate, endDate)
        .sortBySessionDateDesc()
        .findAll();
  }

  /// 단일 날짜의 수면 세션 데이터를 가져옵니다.
  Future<SleepSessionData?> getSleepSession(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return await _isar.sleepSessionDatas
        .where()
        .sessionDateEqualTo(normalizedDate)
        .findFirst();
  }

  /// 수면 세션 데이터를 저장하거나 갱신합니다.
  Future<void> saveSleepSessions(List<SleepSessionData> sessions) async {
    await _isar.writeTxn(() async {
      // putAll은 ID가 존재하면 갱신, 없으면 추가합니다.
      await _isar.sleepSessionDatas.putAll(sessions);
    });
  }

  /// 마지막으로 동기화된 세션을 찾습니다.
  Future<SleepSessionData?> getLatestSession() async {
    return await _isar.sleepSessionDatas
        .where()
        .sortBySessionDateDesc()
        .findFirst();
  }

  /// 모든 수면 데이터를 삭제합니다. (디버깅용)
  Future<void> clearAllSleepData() async {
    await _isar.writeTxn(() async {
      await _isar.sleepSessionDatas.clear();
    });
  }
}
