import 'package:firebase_auth/firebase_auth.dart';
import 'package:wemeet_client/Core/Service/localprofile_service.dart';
import 'package:wemeet_client/Core/Service/repository_service.dart';
import 'package:wemeet_client/Core/Service/database_service.dart';
import 'package:wemeet_client/Core/Worker/worker.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';
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
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      final String? groupId = await _profileService.getUserGroup();

      if (userId == null || groupId == null) {
        print('ServerSendWorker: 로그인 정보/그룹 ID가 없어 스킵 (재시도 필요)');
        return false;
      }

      final List<SleepReport> reports = await _repositoryService
          .getUnsentReports();
      if (reports.isEmpty) return true;

      await _syncService.sendSleepScoreToGroup(
        reports: reports,
        userId: userId,
        groupId: groupId,
      );

      await _repositoryService.markReportAsSent(reports);

      return true;
    } catch (e) {
      return false;
    }
  }
}
