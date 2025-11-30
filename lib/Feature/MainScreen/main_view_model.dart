import 'package:flutter/material.dart';
import 'package:wemeet_client/Core/Core/workerRegister.dart';
import 'package:wemeet_client/Core/Manager/workermanager.dart';
import 'package:wemeet_client/Core/Service/localprofile_service.dart';
import 'package:wemeet_client/Core/Service/repository_service.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class MainViewModel with ChangeNotifier {
  final RepositoryService _repository = RepositoryService.inst;
  late final WorkerManager _workerManager;

  // 상태 변수
  List<SleepReport> _reports = [];
  bool _isLoading = false;

  List<SleepReport> get reports => _reports;
  bool get isLoading => _isLoading;

  // 가장 최신 리포트 (오늘/어제)
  SleepReport? get latestReport => _reports.isNotEmpty ? _reports.first : null;

  MainViewModel({required WorkerManager workmanager})
    : _workerManager = workmanager;

  // 1. 데이터 로딩 (화면 진입 시)
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 날짜 내림차순 정렬 (최신순)
      final allData = await _repository.getAllData();
      allData.sort((a, b) => b.date.compareTo(a.date));

      _reports = allData;
    } catch (e) {
      print("MainViewModel Load Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. 수동 리포트 생성 (FAB 버튼 클릭 시)
  Future<void> generateReportManually() async {
    _isLoading = true;
    notifyListeners();

    try {
      // HealthWorker 수동 실행 (isPeriodic: false)
      // targetDate 등을 지정해서 보낼 수도 있지만, 기본 로직(어제~오늘)을 따름
      await _workerManager.executeTask("generateSleepReport", {
        'isPeriodic': false,
        // 'startTime': ... (필요 시 지정)
      });

      // 생성이 완료되면 DB 다시 읽기
      await loadData();
    } catch (e) {
      print("Manual Generation Error: $e");
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. 로그아웃
  Future<void> logout(BuildContext context) async {
    await LocalprofileService.inst.clearOnLogout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> createDummyData() async {
    _isLoading = true;
    notifyListeners();

    await _repository.seedTestData(); // 가짜 데이터 생성
    await loadData(); // UI 새로고침 (생성된 데이터 불러오기)
  }

  // [테스트용] 데이터 초기화
  Future<void> clearData() async {
    _isLoading = true;
    notifyListeners();

    await _repository.clearAllData();
    await loadData(); // 빈 화면으로 갱신
  }

  Future<void> syncToServer() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("MainViewModel: 서버 동기화 시작...");

      // WorkerRegistrar에 등록한 키값과 정확히 일치해야 합니다!
      // (예: "sendReportsToServer" 또는 "serverSendTask" 등 확인 필요)
      final result = await _workerManager.executeTask(
        WorkerName.sync, // <--- WorkerRegistrar에 등록된 키 확인!
        null, // inputData 필요 없음
      );

      if (result == true) {
        print("MainViewModel: 서버 동기화 성공!");
        // 동기화 후에는 isSentToServer 상태가 바뀌었을 테니 데이터를 다시 로드할 수도 있음
        await loadData();
      } else {
        print("MainViewModel: 서버 동기화 실패 (Worker 반환값 false)");
      }
    } catch (e) {
      print("MainViewModel Sync Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
