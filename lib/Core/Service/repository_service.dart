import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class RepositoryService {
  
  RepositoryService._(){
    print("Repository_Service initialize");
  }

  static final inst = RepositoryService._();

  late final Isar _isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [SleepReportSchema], 
      directory: dir.path
      );
  }

  Future<void> saveData(SleepReport report) async {
    await _isar.writeTxn(() async {
      await _isar.sleepReports.put(report);
    });
  }

  Future<List<SleepReport>> getAllData() async {
    return await _isar.sleepReports.where().findAll();
  }
}