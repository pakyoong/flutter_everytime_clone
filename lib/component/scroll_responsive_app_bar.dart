import 'package:flutter/material.dart';
import 'package:everytime/screen_dimensions.dart'; // 화면 크기 정보를 제공하는 커스텀 라이브러리

class ScrollResponsiveAppBar extends StatelessWidget {
  // ScrollResponsiveAppBar 생성자, 필수로 scrollOffsetStream과 title을 받습니다.
  const ScrollResponsiveAppBar({
    Key? key,
    required this.scrollOffsetStream, // 스크롤 오프셋에 대한 스트림
    required this.title, // 앱 바에 표시될 제목
  }) : super(key: key);

  final Stream<double> scrollOffsetStream; // 스크롤 위치에 따른 오프셋 값을 받는 스트림
  final String title; // 앱 바의 제목

  // 스크롤 오프셋에 따라 앱 바의 높이를 계산하는 함수
  double _calHeight(double scrollOffset) {
    double threshold = availableHeight * 0.02;
    if (scrollOffset >= threshold) {
      return availableHeight * 0.035;
    } else if (scrollOffset <= 0) {
      return availableHeight * 0.055;
    } else {
      return (threshold - scrollOffset) + availableHeight * 0.035;
    }
  }

  // 스크롤 오프셋에 따라 앱 바의 투명도를 계산하는 함수
  double _calOpacity(double scrollOffset) {
    double threshold = availableHeight * 0.02;
    if (scrollOffset >= threshold) {
      return 0;
    } else if (scrollOffset <= 0) {
      return 1;
    } else {
      return (threshold - scrollOffset) / threshold;
    }
  }

  @override
  Widget build(BuildContext context) {
    // StreamBuilder를 사용하여 스크롤 오프셋 스트림을 구독하고, 스크롤 변화에 따라 위젯을 재구성합니다.
    return StreamBuilder<double>(
      stream: scrollOffsetStream,
      builder: (context, snapshot) {
        double height = _calHeight(snapshot.data ?? 0); // 현재 스크롤 위치에 따른 앱 바 높이 계산
        double opacity = _calOpacity(snapshot.data ?? 0); // 현재 스크롤 위치에 따른 앱 바 투명도 계산

        return Container(
          height: height, // 계산된 높이를 적용
          alignment: Alignment.bottomLeft, // 내용을 하단 왼쪽에 정렬
          padding: EdgeInsets.only(left: availableWidth * 0.065), // 왼쪽 여백 설정
          color: Colors.white.withOpacity(opacity), // 계산된 투명도를 적용한 배경색 설정
          child: Text(
            title, // 제목 텍스트
            style: const TextStyle(
              color: Colors.black, // 텍스트 색상
              fontSize: 14.5, // 텍스트 크기
            ),
          ),
        );
      },
    );
  }
}
