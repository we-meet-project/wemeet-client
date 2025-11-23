import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class DataBaseService {
  DataBaseService._() {
    print("Firestore_Service initialize");
  }
  static final inst = DataBaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getGroupIdFromAllowList(String emailKey) async {
    try{
        final docSnapshot = await _firestore.collection('allowEmails') .doc(emailKey).get();

        if(docSnapshot.exists)
        {
          print("companyId 조회");
          final data = docSnapshot.data();
          return data?['companyId'] as String?;
        } 

        return null;
    }
    catch(e){
      print("Firestore Error: $e");
      return null;
    }
  }

  Future<void> saveUserProfile(
    String userId,
    String groupId,
  ) async {
    await _firestore.collection('allowEmails').doc(userId).set({
      'userId': userId,
      'groupId': groupId,
    },
    SetOptions(merge: true),);
  }

  //DB에 SleepScore전송
  // Future<void> sendSleepScoreToGroup({
  //   required List<SleepReport> reports,
  //   required String userId,
  //   required String groupId,
  // }) async {
  //   if (reports.isEmpty) return;

  //   final Map<String, dynamic> updates = {};

  //   for (final report in reports) {
  //     // 경로: /groups/[그룹ID]/sleepScores/[고유키]
  //     final String uniqueKey = '${userId}_${report.id.toString()}';
  //     final String path = '/groups/$groupId/sleepScores/$uniqueKey';

  //     // 전송할 데이터
  //     final Map<String, dynamic> dataToSend = {
  //       'userId': userId, // 웹에서 사용자 식별용
  //       ...report.toJson(),
  //     };

  //     updates[path] = dataToSend;
  //   }

  //   await _database.ref().update(updates);
  // }
}
