import 'package:goodsleeper/Core/Core/workerRegister.dart';
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
    // await Workmanager().registerPeriodicTask(
    //   "dailySleepReportTask",
    //   WorkerName.sleepReport,
    //   frequency: const Duration(days: 1),
    //   initialDelay: _calculateInitialDelay(8),
    //   inputData: {'isPeriodic': true}, // 주기 작업 플래그
    // );

    //테스트
    print('테스트 알람 예약');
    await Workmanager().registerPeriodicTask(
      "dailySleepReportTask",
      WorkerName.sleepReport,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(seconds: 30),
      inputData: {'isPeriodic': true}, // 주기 작업 플래그
      constraints: Constraints(
        networkType: NetworkType.notRequired, // 제약 조건 최소화
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
    print('테스트 알람 예약 완료');

    //서버 전송
    // await Workmanager().registerPeriodicTask(
    //   "serverSendTask",
    //   "sendReportsToServer",
    //   frequency: const Duration(hours: 4),
    //   constraints: Constraints(networkType: NetworkType.unmetered),
    // );
  }
}
