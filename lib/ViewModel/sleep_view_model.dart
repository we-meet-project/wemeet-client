import 'package:flutter/material.dart';
import '../Model/Sleep_report_model.dart';

/// (Flutter의 ChangeNotifier를 사용하여 UI에 변경 알림)
class SleepViewModel with ChangeNotifier {
  // --- 상태(State) ---

  // 1. MainScreen: 이전 수면 리포트 목록 (Mock Data)
  final List<SleepReport> _reports = [
    SleepReport(
      id: '1',
      date: DateTime.now().subtract(Duration(days: 1)),
      sleepScore: 85.0,
      duration: Duration(hours: 7, minutes: 30),
      deepSleepPercent: 20,
      remSleepPercent: 25,
    ),
    SleepReport(
      id: '2',
      date: DateTime.now().subtract(Duration(days: 2)),
      sleepScore: 72.0,
      duration: Duration(hours: 6, minutes: 15),
      deepSleepPercent: 15,
      remSleepPercent: 20,
    ),
    SleepReport(
      id: '3',
      date: DateTime.now().subtract(Duration(days: 3)),
      sleepScore: 91.0,
      duration: Duration(hours: 8, minutes: 10),
      deepSleepPercent: 25,
      remSleepPercent: 22,
    ),
  ];
  // 외부에서는 이 getter를 통해 데이터를 읽기만 가능
  List<SleepReport> get reports => _reports;

  // 2. ReportScreen: 현재(오늘) 수면 리포트 (Mock Data)
  final SleepReport _currentReport = SleepReport(
    id: 'current',
    date: DateTime.now(),
    sleepScore: 92.0,
    duration: Duration(hours: 8, minutes: 5),
    deepSleepPercent: 22,
    remSleepPercent: 28,
  );
  SleepReport get currentReport => _currentReport;

  // 3. SurveyScreen: 설문 상태
  int _selectedEmojiIndex = -1; // -1: 선택 없음, 0-3: 이모지 인덱스
  int _starRating = 0; // 0-5: 별점
  String _comment = ''; // 코멘트 입력

  int get selectedEmojiIndex => _selectedEmojiIndex;
  int get starRating => _starRating;
  String get comment => _comment;

  // --- 로직(Logic) / 행위(Action) ---

  /// report생성
  Future<void> createReport(
    DateTime startTime,
    DateTime endTime,
    Map<String, dynamic> sleepData,
  ) async {}

  /// 이모지 선택
  void selectEmoji(int index) {
    _selectedEmojiIndex = index;
    notifyListeners(); // UI에 변경 사항 알림
  }

  /// 별점 변경
  void setStarRating(int rating) {
    _starRating = rating;
    notifyListeners();
  }

  /// 코멘트 업데이트
  void setComment(String newComment) {
    _comment = newComment;
    // 코멘트는 입력 중 계속 호출되므로 notifyListeners()를 호출하지 않거나,
    // 필요에 따라 디바운스(debounce) 처리를 할 수 있습니다.
    // 여기서는 간단하게 setComment가 완료되는 시점에만 상태를 갖도록 합니다.
  }

  /// 설문 제출 (시뮬레이션)
  void submitSurvey() {
    print("--- 설문 제출 ---");
    print("선택된 이모지 인덱스: $_selectedEmojiIndex");
    print("별점: $_starRating");
    print("코멘트: $_comment");

    // 상태 초기화
    _selectedEmojiIndex = -1;
    _starRating = 0;
    _comment = '';

    // 이 메서드가 끝나고 UI가 전환될 것이므로
    // notifyListeners() 호출은 필수는 아닙니다.
  }
}
