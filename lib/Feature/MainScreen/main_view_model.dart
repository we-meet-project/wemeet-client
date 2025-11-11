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
  Future<void> loadReport() async {
    //나중에 로컬 저장소에서 데이터 가져오는 코드 적어야함
  }
}
