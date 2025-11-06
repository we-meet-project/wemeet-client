import 'package:flutter/widgets.dart';
import 'package:wemeet_client/Core/Core/workerRegister.dart';
import 'package:wemeet_client/Core/Manager/workermanager.dart';
import 'package:wemeet_client/Core/di/dependency_factory.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class MainViewModel extends ChangeNotifier {
  final WorkerManager _manager;

  MainViewModel({required DependencyFactory factory})
    : _manager = WorkerManager(factory: factory);

  // --- State ---
  final List<SleepReport> _reports = [];
  List<SleepReport> get reports => _reports;

  // --- Logic ---
  /// report생성
  Future<void> createReport(
    DateTime startTime,
    DateTime endTime,
    Map<String, dynamic> sleepData,
  ) async {
    final Map<String, dynamic> inputData = {
      'startTime': startTime,
      'endTime': endTime,
    };
    try {
      SleepReport report = await _manager.executeTask(
        WorkerName.sleepReport,
        inputData,
      );

      notifyListeners();
    } catch (e) {
      print('Error creating report: $e');
    }
  }
}
