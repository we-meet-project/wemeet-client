import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health/health.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 수면 데이터 업로드
  Future<void> uploadSleepData(
      List<HealthDataPoint> data, String userId) async {
    if (data.isEmpty) return;

    final batch = _db.batch();
    // 사용자별 private 데이터로 저장
    final collection =
        _db.collection('users').doc(userId).collection('sleep_data');

    for (var dp in data) {
      // HealthDataPoint를 Map으로 변환
      final docData = {
        'value': (dp.value as num).toDouble(),
        'unit': dp.unitString,
        'type': dp.typeString,
        'dateFrom': dp.dateFrom.toIso8601String(),
        'dateTo': dp.dateTo.toIso8601String(),
        'sourceId': dp.sourceId,
        'sourceName': dp.sourceName,
        'platform': dp.platform.name,
        'uuid': dp.uuid,
        'uploadedAt': FieldValue.serverTimestamp(),
      };

      // UUID가 null이 아닌 경우에만 고유 ID로 사용
      if (dp.uuid != null) {
        // 문서 ID를 고유하게 지정하여 중복 방지
        final docId = dp.uuid!.replaceAll(RegExp(r'[^a-zA-Z0.9]'), '_');
        final docRef = collection.doc(docId);
        batch.set(docRef, docData, SetOptions(merge: true)); // 중복 시 덮어쓰기
      }
    }

    // 배치 작업 실행
    await batch.commit();
  }
}
