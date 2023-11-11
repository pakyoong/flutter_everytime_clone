import 'package:flutter/material.dart';
import 'package:everytime/screen_dimensions.dart'; // 화면 크기 정보를 제공하는 커스텀 라이브러리

class DynamicAppBar extends StatelessWidget {
  // DynamicAppBar 생성자, 필수로 actions과 title을 받습니다.
  const DynamicAppBar({
    Key? key,
    required this.actions, // 앱 바의 오른쪽에 배치될 위젯 리스트
    required this.title, // 앱 바에 표시될 제목
  }) : super(key: key);

  final List<Widget> actions; // 앱 바에 추가될 액션 버튼들
  final String title; // 앱 바의 제목

  @override
  Widget build(BuildContext context) {
    // 앱 바의 높이, 전체 높이의 5.7%로 설정
    final double appBarHeight = availableHeight * 0.057;

    return Container(
      height: appBarHeight, // 컨테이너의 높이 설정
      alignment: Alignment.topLeft, // 내용을 상단 왼쪽에 정렬
      padding: EdgeInsets.symmetric(horizontal: availableWidth * 0.065), // 양쪽 여백 설정
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 자식들을 양 끝으로 분산 배치
        crossAxisAlignment: CrossAxisAlignment.start, // 자식들을 상단에 정렬
        children: [
          Container(
            child: Text(
              title, // 제목 텍스트
              style: const TextStyle(
                color: Colors.black, // 텍스트 색상
                fontSize: 27, // 텍스트 크기
                fontWeight: FontWeight.bold, // 글꼴 두께
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: actions), // 액션 버튼들을 중앙 정렬로 표시
        ],
      ),
    );
  }
}
