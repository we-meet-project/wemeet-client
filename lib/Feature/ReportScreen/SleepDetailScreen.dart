import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wemeet_client/Feature/ReportScreen/report_view_model.dart';
import 'package:wemeet_client/Feature/Survey/survey_view_model.dart';
import 'package:wemeet_client/Model/Sleep_report_model.dart';

class SleepDetailScreen extends StatefulWidget {
  const SleepDetailScreen({super.key});

  @override
  State<SleepDetailScreen> createState() => _SleepDetailScreenState();
}

class _SleepDetailScreenState extends State<SleepDetailScreen> {
  late TextEditingController _commentController;
  late ScrollController _scrollController;

  final GlobalKey _surveySectionKey = GlobalKey();

  bool _isSurvey = false;

  // 이모지 데이터
  final List<String> _emojis = ['😴', '😐', '🙂', '😄'];
  final List<String> _emojiDescriptions = ['피곤함', '보통', '좋음', '매우 좋음'];
  @override
  void initState() {
    super.initState();
    // 1. 초기값 설정
    final initialComment = context.read<SurveyViewModel>().comment;
    _commentController = TextEditingController(text: initialComment);

    // 2. 스크롤 컨트롤러 설정
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // 설문 섹션의 RenderBox를 가져옴
    final RenderBox? renderBox =
        _surveySectionKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      // 설문 섹션의 화면 내 절대 위치(Y좌표)를 구함
      final position = renderBox.localToGlobal(Offset.zero).dy;
      // 화면 높이
      final screenHeight = MediaQuery.of(context).size.height;

      // "설문 섹션이 화면의 70% 지점보다 위로 올라오면" Survey Mode로 간주
      // (숫자를 조절하여 민감도 변경 가능)
      if (position < screenHeight * 0.8) {
        if (!_isSurvey) setState(() => _isSurvey = true);
      } else {
        if (_isSurvey) setState(() => _isSurvey = false);
      }
    }
  }

  void _handleButtonPress(SurveyViewModel surveyVM) {
    if (_isSurvey) {
      // [기록 완료 모드] -> 제출
      surveyVM.submitSurvey();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('기록이 저장되었습니다.')));
      Navigator.pop(context);
    } else {
      // [피드백 남기기 모드] -> 스크롤 이동
      Scrollable.ensureVisible(
        _surveySectionKey.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.1, // 0.0은 맨 위, 0.1은 약간 여유를 두고 스크롤
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1A1A2E);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        title: Text(
          DateFormat(
            'M월 d일 (E)',
            'ko',
          ).format(context.read<ReportViewModel>().report.date),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 100),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Consumer<ReportViewModel>(
                  builder: (context, vm, child) {
                    // 차트용 데이터 계산
                    final double score = vm.report.sleepScore;
                    final double remainder = 100.0 - score;

                    return Column(
                      children: [
                        // 1. 파이 차트 영역
                        SizedBox(
                          height: 250,
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${vm.report.sleepScore.toInt()}", // 소수점 제거 or .toStringAsFixed(1)
                                      style: TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: vm.scoreColor,
                                        height: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Sleep Score",
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PieChart(
                                PieChartData(
                                  startDegreeOffset: 270,
                                  sectionsSpace: 0,
                                  centerSpaceRadius:
                                      70, // 두께를 키우기 위해 내부 공간을 살짝 줄임 (취향껏 조절)
                                  sections: [
                                    // 1. 점수 부분 (Active)
                                    PieChartSectionData(
                                      // 단색 color 대신 gradient 사용
                                      gradient: LinearGradient(
                                        colors: [
                                          vm.scoreColor.withValues(
                                            alpha: 0.7,
                                          ), // 시작은 약간 밝거나 투명하게
                                          vm.scoreColor, // 끝은 진하게
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      value: score,
                                      showTitle: false,
                                      radius: 30, // [Point] 남은 부분보다 두껍게 (강조 효과)
                                      badgePositionPercentageOffset: .98,
                                    ),

                                    // 2. 남은 부분 (Inactive - Track)
                                    PieChartSectionData(
                                      // 배경색을 너무 투명하게 하기보다, 짙은 배경에 어울리는 색으로 설정
                                      color: const Color(
                                        0xFF252535,
                                      ), // 혹은 Colors.white.withOpacity(0.05)
                                      value: remainder,
                                      showTitle: false,
                                      radius: 20, // [Point] 점수 부분보다 얇게 (배경 느낌)
                                    ),
                                  ],
                                ),
                                duration: const Duration(
                                  milliseconds: 1200,
                                ), // 애니메이션 시간을 조금 늘려 부드럽게
                                curve: Curves.easeOutCubic, // 끝에서 천천히 멈추는 느낌
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // 2. 상태 메시지
                        Text(
                          vm.scoreMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // 3. 총 수면 시간 카드
                        _buildTotalSleepCard(vm.report.formattedTotal),
                        const SizedBox(height: 16),
                        // 4. 수면 단계 카드
                        _buildSleepStagesCard(vm.report),
                        const SizedBox(height: 30),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 70),
                Consumer<SurveyViewModel>(
                  builder: (context, vm, child) {
                    return Container(
                      key: _surveySectionKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            '오늘의 컨디션',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '일어난 후의 기분을 기록해주세요.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            '지금 기분이 어떠신가요?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // 이모지 선택
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(_emojis.length, (index) {
                              // ViewModel의 'selectedEmojiIndex'를 사용
                              bool isSelected = vm.selectedEmojiIndex == index;
                              return GestureDetector(
                                onTap: () =>
                                    vm.selectEmoji(index), // ViewModel의 함수 호출
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.deepPurpleAccent.withValues(
                                            alpha: 0.3,
                                          )
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
                                      Text(
                                        _emojis[index],
                                        style: const TextStyle(fontSize: 48),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _emojiDescriptions[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[400],
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
                          const SizedBox(height: 40),

                          const Text(
                            '어젯밤 수면은 만족스러웠나요?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 별점 선택
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return IconButton(
                                // ViewModel의 'starRating' 사용
                                icon: Icon(
                                  index < vm.starRating
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: index < vm.starRating
                                      ? Colors.yellowAccent
                                      : Colors.grey[700],
                                  size: 40,
                                ),
                                onPressed: () => vm.setStarRating(
                                  index + 1,
                                ), // ViewModel 함수 호출
                              );
                            }),
                          ),
                          const SizedBox(height: 40),

                          const Text(
                            '수면에 대해 남길 말이 있나요?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 코멘트 입력 필드
                          TextField(
                            controller: _commentController,
                            onChanged: (value) => vm.setComment(value),
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: '예: 꿈을 많이 꿨어요, 중간에 고양이 때문에 깼어요...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              filled: true,
                              fillColor: const Color(0xFF16213E),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // 2. 하단 고정 버튼 (Floating Action Button처럼 동작)
          Positioned(
            left: 20,
            right: 20,
            bottom: 30, // 화면 하단에서 띄움
            child: Consumer<SurveyViewModel>(
              builder: (context, surveyVM, _) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // 모드에 따라 색상 변경 (선택사항)
                      backgroundColor: _isSurvey
                          ? Colors.tealAccent
                          : const Color(0xFF6C63FF),
                      foregroundColor: _isSurvey ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => _handleButtonPress(surveyVM),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                      child: _isSurvey
                          ? Row(
                              key: ValueKey('Submit'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle_outline),
                                SizedBox(width: 8),
                                Text(
                                  context
                                              .read<SurveyViewModel>()
                                              .report
                                              .sleepRating !=
                                          null
                                      ? '수정 완료'
                                      : '기록 완료',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              key: ValueKey('Scroll'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '수면 피드백 남기기',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_downward_rounded),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSleepCard(String time) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2746),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "총 수면 시간",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepStagesCard(SleepReport report) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2746),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "수면 단계 분석",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildStageRow(
            "깊은 잠",
            report.formattedDeepSleep,
            report.percentDeep,
            const Color(0xFF2962FF),
          ),
          const SizedBox(height: 16),
          _buildStageRow(
            "얕은 잠",
            report.formattedLightSleep,
            report.percentLight,
            const Color(0xFF448AFF),
          ),
          const SizedBox(height: 16),
          _buildStageRow(
            "REM 수면",
            report.formattedRemSleep,
            report.percentRem,
            const Color(0xFFAA00FF),
          ),
          const SizedBox(height: 16),
          _buildStageRow(
            "깬 시간",
            report.formattedAwakeSleep,
            report.percentAwake,
            const Color(0xFFFF5252),
          ),
        ],
      ),
    );
  }

  Widget _buildStageRow(
    String label,
    String time,
    double percent,
    Color color,
  ) {
    final double safeWidthFactor = (percent / 100).clamp(0.0, 1.0);

    return Row(
      children: [
        // 라벨
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        // 게이지 바
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: safeWidthFactor,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // 시간 텍스트
        SizedBox(
          width: 70, // 공간 확보를 위해 약간 늘림
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "${percent.toInt()}%", // 퍼센트 표시 추가
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
