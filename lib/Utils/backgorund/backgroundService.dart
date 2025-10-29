import 'package:workmanager/workmanager.dart';

import 'package:wemeet_client/Workers/task_definitions.dart';

//백그라운드 작업 등록하는 진입점
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
        final backgroundservice = Backgroundservice();

        return await backgroundservice.executeTask(taskName, inputData);
  });
}


//백그라운드 작업 호출 하는 Runner
class Backgroundservice {
  
  Future<bool> executeTask(String taskNamem, Map<String, dynamic>? inputData) async{
      
      //백그라운드 작업 호출 분기
      switch(taskNamem){
        //테스트용
        case TaskName.testTask:
          return true;

        //등록 안된 작업
        default:
          return Future.value(false);
      }
  }

}