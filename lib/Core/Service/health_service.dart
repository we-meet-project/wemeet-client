//google health connect에서 수면데이터 얻어오는 service
import 'package:health/health.dart';

//Google 엑세스 요청 메서드
Future<bool> requestHealthPermission(List<HealthDataType> type) async {
  final Health health = Health();
  return await health.requestAuthorization(type);
}

Future<bool> checkHealthPermission(List<HealthDataType> type) async {
  final Health health = Health();

  bool? hasPermission = await health.hasPermissions(type);

  return hasPermission ?? false;
}

//권한 실패 예외 클래스
class HealthPermissionExpection implements Exception {}

class HealthDataService {
  HealthDataService._() {
    print("Health_Service initialize");
  }
  static final inst = HealthDataService._();

  final Health _health = Health();

  //google health connect에게서 rawData(원시 데이터만 받아서 전달)
  Future<List<HealthDataPoint>> getSleepData({
    required DateTime startTime,
    required DateTime endTime,
    required List<HealthDataType> type,
  }) async {
    List<HealthDataPoint> sleepData = [];

    try {
      //google Health Connect로부터 Data가져오기
      sleepData = await _health.getHealthDataFromTypes(
        types: type,
        startTime: startTime,
        endTime: endTime,
      );

      //중복 데이터 제거
      sleepData = _health.removeDuplicates(sleepData);
      //데이터 정렬
      sleepData.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));
    } catch (e) {
      print("수면데이터 불러오기 실패 : $e");
    }
    return sleepData;
  }
}
