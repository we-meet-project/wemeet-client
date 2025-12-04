import 'package:goodsleeper/Core/Service/localprofile_service.dart';
import 'package:goodsleeper/Core/Service/repository_service.dart';
import 'package:goodsleeper/Core/Service/database_service.dart';
import 'package:goodsleeper/Core/Worker/worker.dart';
import 'package:goodsleeper/Core/di/dependency_factory.dart';
import 'package:goodsleeper/Model/Sleep_report_model.dart';
import '../di/container.dart';

class Syncworker implements IWorker {
  final DataBaseService _syncService;
  final RepositoryService _repositoryService;
  final LocalprofileService _profileService;

  Syncworker({required Container container})
    : _syncService = container.get<DataBaseService>(),
      _repositoryService = container.get<RepositoryService>(),
      _profileService = container.get<LocalprofileService>();

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async {
    try {
      // 1. 사용자 정보 확인
      final String? userId = _profileService.getUserId();
      final String? companyId = _profileService.getUserCompany();
      final String? groupId = _profileService.getUserGroup();

      if (userId == null || groupId == null || companyId == null) {
        return true; // 재시도 방지를 위해 true 리턴 (로그인해야 가능하므로)
      }

      // 2. 전송할 데이터 확인
      final List<SleepReport> unsentReports = await _repositoryService
          .getUnsentReports();

      if (unsentReports.isEmpty) {
        return true;
      }

      // 3. 전송 시도
      print("cloud_upload 전송 시작...");
      await _syncService.sendSleepScoresToGroup(
        reports: unsentReports,
        userId: userId,
        companyId: companyId,
        groupId: groupId,
      );

      // 4. 로컬 DB 업데이트
      await _repositoryService.markReportAsSent(unsentReports);

      return true;
    } catch (e) {
      print('ServerSend: $e');
      return false;
    }
  }
}

Future<IWorker> createSyncWorker(DependencyFactory factory) async {
  final types = [DataBaseService, RepositoryService, LocalprofileService];

  final container = factory.createContainer(types);

  return Syncworker(container: container);
}
