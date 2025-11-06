import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/sleep_view_model.dart';

class SurveyScreen extends StatelessWidget {
  // 이모지 목록 (UI에 속하므로 View 파일에 둡니다)
  final List<String> _emojis = ['😴', '😐', '🙂', '😄'];
  // 이모지 설명
  final List<String> _emojiDescriptions = ['피곤함', '보통', '좋음', '매우 좋음'];

  @override
  Widget build(BuildContext context) {
    // watch: UI가 ViewModel의 데이터 변경에 반응해야 할 때
    final viewModel = context.watch<SleepViewModel>();
    // read: UI가 ViewModel의 함수만 호출하고 데이터 변경에 반응할 필요 없을 때
    final viewModelRead = context.read<SleepViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('컨디션 설문', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              '오늘의 컨디션',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              '일어난 후의 기분을 기록해주세요.',
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
            SizedBox(height: 40),

            Text(
              '지금 기분이 어떠신가요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // 이모지 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_emojis.length, (index) {
                // ViewModel의 'selectedEmojiIndex'를 사용
                bool isSelected = viewModel.selectedEmojiIndex == index;
                return GestureDetector(
                  onTap: () =>
                      viewModelRead.selectEmoji(index), // ViewModel의 함수 호출
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurpleAccent.withOpacity(0.3)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepPurpleAccent
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(_emojis[index], style: TextStyle(fontSize: 48)),
                        SizedBox(height: 4),
                        Text(
                          _emojiDescriptions[index],
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected ? Colors.white : Colors.grey[400],
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 40),

            Text(
              '어젯밤 수면은 만족스러웠나요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // 별점 선택
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  // ViewModel의 'starRating' 사용
                  icon: Icon(
                    index < viewModel.starRating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: index < viewModel.starRating
                        ? Colors.yellowAccent
                        : Colors.grey[700],
                    size: 40,
                  ),
                  onPressed: () =>
                      viewModelRead.setStarRating(index + 1), // ViewModel 함수 호출
                );
              }),
            ),
            SizedBox(height: 40),

            Text(
              '수면에 대해 남길 말이 있나요?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // 코멘트 입력 필드
            TextField(
              // TextField는 자체 상태 관리를 위해 controller를 사용하는 것이 좋습니다.
              // 여기서는 ViewModel의 'comment'와 동기화합니다.
              // (더 복잡한 앱에서는 TextEditingController를 View 내에서 관리하고
              // 제출 시점에만 ViewModel로 넘기는 것이 더 효율적일 수 있습니다.)
              controller: TextEditingController(text: viewModel.comment),
              onChanged: (value) =>
                  viewModelRead.setComment(value), // ViewModel 함수 호출
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '예: 꿈을 많이 꿨어요, 중간에 고양이 때문에 깼어요...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Color(0xFF16213E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(16),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 50),

            // 기록 완료 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  viewModelRead.submitSurvey(); // ViewModel 함수 호출
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text(
                  '기록 완료',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
