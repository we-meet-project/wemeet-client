import 'package:flutter/material.dart';
import 'package:wemeet_client/Core/Service/repository_service.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class SurveyViewModel with ChangeNotifier {
  final SleepReport report;
  final RepositoryService _repository = RepositoryService.inst;

  int? selectedEmojiIndex;

  // 별점 (0~5, 초기값 0)
  int starRating = 0;

  // 코멘트 (초기값 빈 문자열)
  String comment = '';

  SurveyViewModel(this.report) {
    if (report.moodIndex != null)
      selectedEmojiIndex = report.moodIndex!;
    else
      selectedEmojiIndex = 1; // 저장된 게 없으면 기본값 (예: 보통)

    if (report.sleepRating != null) starRating = report.sleepRating!;

    if (report.comment != null) comment = report.comment!;
  }

  // 3. Actions (UI에서 호출하는 함수들)

  /// 이모지 선택 처리
  void selectEmoji(int index) {
    if (selectedEmojiIndex != index) {
      selectedEmojiIndex = index;
      notifyListeners(); // UI 업데이트 요청
    }
  }

  /// 별점 설정 처리
  void setStarRating(int rating) {
    if (starRating != rating) {
      starRating = rating;
      notifyListeners(); // UI 업데이트 요청
    }
  }

  /// 코멘트 입력 처리
  void setComment(String value) {
    comment = value;
  }

  /// 설문 제출 처리 (기록 완료 버튼)
  Future<void> submitSurvey() async {
    // 유효성 검사 (예: 기분이나 별점을 선택하지 않았을 경우)
    if (selectedEmojiIndex == null) {
      print('경고: 기분을 선택해주세요.');
      return;
    }

    report.moodIndex = selectedEmojiIndex;
    report.sleepRating = starRating;
    report.comment = comment;

    await _repository.saveData(report);
  }
}
