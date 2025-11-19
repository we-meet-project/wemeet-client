import 'package:firebase_database/firebase_database.dart';

import 'package:wemeet_client/Model/Sleep_report_model.dart';

class DataBaseService {
  DataBaseService._() {
    print("Firestore_Service initialize");
  }
  static final inst = DataBaseService._();

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<String?> getGroupIdFromAllowList(String emailKey) async {
    final snapshot = await _database.ref('allowEmails').child(emailKey).get();

    if (snapshot.exists) {
      return snapshot.value as String?;
    }
    return null;
  }

  Future<void> saveUserProfile(
    String userId,
    String email,
    String groupId,
  ) async {
    await _database.ref('users').child(userId).child('profile').set({
      'email': email,
      'groupId': groupId,
    });
  }

  //DB에 SleepScore전송
  Future<void> sendSleepScoreToGroup({
    required List<SleepReport> reports,
    required String userId,
    required String groupId,
  }) async {
    if (reports.isEmpty) return;

    final Map<String, dynamic> updates = {};

    for (final report in reports) {
      // 경로: /groups/[그룹ID]/sleepScores/[고유키]
      final String uniqueKey = '${userId}_${report.id.toString()}';
      final String path = '/groups/$groupId/sleepScores/$uniqueKey';

      // 전송할 데이터
      final Map<String, dynamic> dataToSend = {
        'userId': userId, // 웹에서 사용자 식별용
        ...report.toJson(),
      };

      updates[path] = dataToSend;
    }

    await _database.ref().update(updates);
  }
}
