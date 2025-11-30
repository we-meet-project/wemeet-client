import 'package:wemeet_client/Core/Core/workerRegister.dart';
import 'package:workmanager/workmanager.dart';

class Taskscheduler {
  static Duration _calculateInitialDelay(int housrs) {
    final now = DateTime.now();
    var next8AM = DateTime(now.year, now.month, now.day, housrs, 0, 0);
    if (now.isAfter(next8AM)) {
      next8AM = next8AM.add(const Duration(days: 1));
    }
    return next8AM.difference(now);
  }

  static Future<void> scheduleAllTask() async {
    //수면 보고서
    await Workmanager().registerPeriodicTask(
      "dailySleepReportTask",
      WorkerName.sleepReport,
      frequency: const Duration(days: 1),
      initialDelay: _calculateInitialDelay(8),
      inputData: {'isPeriodic': true}, // 주기 작업 플래그
    );

    //서버 전송
    // await Workmanager().registerPeriodicTask(
    //   "serverSendTask",
    //   "sendReportsToServer",
    //   frequency: const Duration(hours: 4),
    //   constraints: Constraints(networkType: NetworkType.unmetered),
    // );
  }
}
