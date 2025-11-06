// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:wemeet_client/DataBase/sleep_schemas.dart';

// class IsarService {
//   static late final Isar isar;

//   /// 앱 시작 시 main.dart에서 호출해야 합니다.
//   static Future<void> init() async {
//     final dir = await getApplicationDocumentsDirectory();

//     // 이전에 인스턴스가 열려 있었다면 isar.instanceName이 동일한지 확인
//     if (Isar.instanceNames.isEmpty) {
//       isar = await Isar.open(
//         [SleepSessionDataSchema], // 2번 파일의 스키마
//         directory: dir.path,
//         name: 'sleepDataInstance',
//       );
//     }
//     // 이미 열려있는 경우 해당 인스턴스 사용
//     else {
//       isar = Isar.getInstance('sleepDataInstance')!;
//     }
//   }

//   /// Isar 인스턴스를 쉽게 가져오기 위한 getter
//   static Isar get instance => isar;
// }
