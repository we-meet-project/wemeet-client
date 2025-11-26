import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class DataBaseService {
  DataBaseService._() {
    print("Firestore_Service initialize");
  }
  static final inst = DataBaseService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getGroupIdFromAllowList(String emailKey) async {
    try {
      final docSnapshot = await _firestore
          .collection('allowEmails')
          .doc(emailKey)
          .get();

      if (docSnapshot.exists) {
        print("companyId 조회");
        final data = docSnapshot.data();
        return data?['companyId'] as String?;
      }

      return null;
    } catch (e) {
      print("Firestore Error: $e");
      return null;
    }
  }

  Future<void> saveUserProfile(String userId, String groupId) async {
    await _firestore.collection('allowEmails').doc(userId).set({
      'userId': userId,
      'groupId': groupId,
    }, SetOptions(merge: true));
  }

  //DB에 SleepScore전송
  Future<void> sendSleepScoresToGroup({
    required List<SleepReport> reports,
    required String userId,
    required String groupId,
  }) async {
    if (reports.isEmpty) return;

    // 1. Firestore 일괄 처리(Batch) 생성
    final WriteBatch batch = _firestore.batch();

    for (final report in reports) {
      // 2. 고유 키 생성 (UserID + ReportID)
      final String uniqueKey = '${userId}_${report.id}';

      // 3. 저장 경로 참조 (Reference) 생성
      // 구조: 컬렉션(groups) -> 문서(groupId) -> 서브컬렉션(sleepScores) -> 문서(uniqueKey)
      final DocumentReference docRef = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('sleepScores')
          .doc(uniqueKey);

      // 4. 전송할 데이터 매핑 (DTO)
      final Map<String, dynamic> dataToSend = {
        //'userId': userId,
        'date': report.date, // Firestore Timestamp로 자동 변환됨
        'sleepScore': report.sleepScore,
        'durationInMinutes': report.durationInMinutes,
        'deepSleepPercent': report.deepSleepPercent,
        'remSleepPercent': report.remSleepPercent,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // 5. Batch에 '저장(Set)' 작업 추가
      batch.set(docRef, dataToSend, SetOptions(merge: true));
    }

    // 6. 일괄 전송 실행 (Atomic Operation)
    await batch.commit();
  }
}
