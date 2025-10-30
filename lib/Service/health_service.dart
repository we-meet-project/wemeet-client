//google health connect에서 수면데이터 얻어오는 service
import 'package:flutter/material.dart';
import 'package:health/health.dart';

class SleepData_Service {
  SleepData_Service._(){ 
    print("Health_Service initialize");
  }
  static final inst = SleepData_Service._();

  final Health _health = Health();

  //가져올 수면 데이터 타입
  static final types = [
    HealthDataType.SLEEP_ASLEEP,      // 수면 중
    HealthDataType.SLEEP_AWAKE,       // 수면 중 깸
    HealthDataType.SLEEP_DEEP,        // 깊은 수면
    HealthDataType.SLEEP_LIGHT,       // 얕은 수면
    HealthDataType.SLEEP_REM,         // REM 수면 
  ];

  //google health connect에게서 rawData(원시 데이터만 받아서 전달)
  Future<List<HealthDataPoint>> getSleepData({
    required DateTime startTime,
    required DateTime endTime,
  }) async{

    List<HealthDataPoint> healthData = [];

    try{
      //google Health Connect로부터 Data가져오기
      healthData = await _health.getHealthDataFromTypes(
        types: types, startTime: startTime, endTime: endTime,
        );
    }
    catch(e){
      print("수면데이터 불러오기 실패 : $e");
    }

    return healthData;
  }
}