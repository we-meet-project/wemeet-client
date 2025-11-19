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
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open([SleepReportSchema], directory: dir.path);
  }

  Future<void> saveData(SleepReport report) async {
    await _isar.writeTxn(() async {
      await _isar.sleepReports.put(report);
    });
  }

  Future<SleepReport?> getReportForDate(DateTime targetDate) async {
    final startOfDay = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final startOfNextDay = startOfDay.add(const Duration(days: 1));

    return await _isar.sleepReports
        .filter()
        .dateGreaterThan(startOfDay, include: true)
        .dateLessThan(startOfNextDay)
        .findFirst();
  }

  Future<List<SleepReport>> getUnsentReports() async {
    return await _isar.sleepReports.filter().isSentEqualTo(false).findAll();
  }

  Future<void> markReportAsSent(List<SleepReport> reports) async {
    await _isar.writeTxn(() async {
      for (final report in reports) {
        report.isSent = true;
        await _isar.sleepReports.put(report);
      }
    });
  }
}
