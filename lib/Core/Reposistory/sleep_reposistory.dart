// import 'package:health/health.dart'; // health 패키지

// class SleepRepository {
//   final HealthService _healthService;
//   final HealthWorker _healthWorker;
//   final SleepLocalDatasource _localDatasource;

//   SleepRepository({
//     required HealthService healthService,
//     required HealthWorker healthWorker,
//     required SleepLocalDatasource localDatasource,
//   }) : _healthService = healthService,
//        _healthWorker = healthWorker,
//        _localDatasource = localDatasource;

//   /// ViewModel이 호출할 메인 메서드.
//   /// [date]날짜의 수면 리포트를 가져옵니다.
//   Future<SleepSessionData?> getSleepReport(DateTime date) async {
//     final normalizedDate = DateTime(date.year, date.month, date.day);

//     // 1. Isar 로컬 캐시에서 먼저 찾아봅니다.
//     SleepSessionData? localData = await _localDatasource.getSleepSession(
//       normalizedDate,
//     );

//     if (localData != null) {
//       print("[SleepRepo] ${date.toIso8601String()} - 로컬 DB에서 데이터 반환");
//       return localData;
//     }

//     // 2. 캐시에 없으면, Health 앱과 동기화합니다.
//     print("[SleepRepo] ${date.toIso8601String()} - DB에 없음, Health 앱과 동기화 시도");
//     await syncSleepData(date);

//     // 3. 동기화 후 다시 DB에서 데이터를 조회합니다.
//     return await _localDatasource.getSleepSession(normalizedDate);
//   }

//   /// Health 앱의 데이터를 Isar DB와 동기화합니다.
//   Future<void> syncSleepData(DateTime date) async {
//     try {
//       // '어젯밤'을 포함하기 위해 범위를 넓게 잡습니다.
//       // (예: 11월 5일 데이터를 요청하면, 11월 4일 12:00 ~ 11월 5일 23:59)
//       final dayBefore = date.subtract(const Duration(days: 1));
//       final requestStartTime = DateTime(
//         dayBefore.year,
//         dayBefore.month,
//         dayBefore.day,
//         12,
//         0,
//       ); // 어제 정오
//       final requestEndTime = DateTime(
//         date.year,
//         date.month,
//         date.day,
//         23,
//         59,
//       ); // 오늘 밤 자정 직전

//       // 1. HealthService에서 원시 데이터 가져오기
//       List<HealthDataPoint> rawData = await _healthService.getSleepData(
//         requestStartTime,
//         requestEndTime,
//       );

//       if (rawData.isEmpty) {
//         print("[SleepRepo] Health 앱에 데이터가 없습니다.");
//         return;
//       }

//       // 2. HealthWorker가 원시 데이터를 Isar 스키마로 가공
//       // (Worker는 여러 세션이 있어도 처리할 수 있어야 함)
//       List<SleepSessionData> processedSessions = _healthWorker.processSleepData(
//         rawData,
//       );

//       if (processedSessions.isEmpty) {
//         print("[SleepRepo] 데이터를 처리했으나 유효한 세션이 없습니다.");
//         return;
//       }

//       // 3. LocalDatasource를 통해 Isar에 저장
//       await _localDatasource.saveSleepSessions(processedSessions);
//       print("[SleepRepo] ${processedSessions.length}개의 세션을 Isar에 저장했습니다.");
//     } catch (e) {
//       print("[SleepRepo] 수면 데이터 동기화 실패: $e");
//       // 필요시 에러 처리
//     }
//   }

//   // TODO: 과거 모든 데이터를 동기화하는 로직
//   Future<void> syncAllHistoricalData() async {
//     // 예: 마지막 DB 데이터 날짜부터 오늘까지
//     final latestSession = await _localDatasource.getLatestSession();
//     DateTime startDate =
//         latestSession?.sessionDate ??
//         DateTime.now().subtract(const Duration(days: 30)); // 예: 30일 전
//     DateTime endDate = DateTime.now();

//     // ... syncSleepData와 유사한 로직 수행 ...
//   }
// }
