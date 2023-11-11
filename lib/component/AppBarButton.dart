import 'package:flutter/material.dart';
import 'package:everytime/screen_dimensions.dart'; // 화면 크기 관련 정보를 제공하는 커스텀 라이브러리

class AppBarButton extends StatelessWidget {
  // AppBarButton 생성자, 필수로 icon을 받고, onPressed는 옵션입니다.
  const AppBarButton({
    Key? key,
    required this.icon, // 아이콘 데이터, IconData 형식
    this.onPressed, // 버튼이 눌렸을 때 실행할 함수, VoidCallback 형식
  }) : super(key: key);

  final IconData icon; // 버튼에 표시될 아이콘
  final VoidCallback? onPressed; // 버튼 클릭 시 호출될 콜백 함수

  @override
  Widget build(BuildContext context) {
    // 앱 바의 높이, 전체 높이의 5.5%로 설정
    final double appBarHeight = availableHeight * 0.055;
    // 버튼의 너비, 전체 너비의 7%로 설정
    final double buttonWidth = availableWidth * 0.07;
    // 버튼의 왼쪽 여백, 전체 너비의 5.5%로 설정
    final double buttonMarginLeft = availableWidth * 0.055;

    return Container(
      width: buttonWidth, // 컨테이너의 너비 설정
      height: appBarHeight, // 컨테이너의 높이 설정
      margin: EdgeInsets.only(left: buttonMarginLeft), // 왼쪽 여백 설정
      child: MaterialButton(
        splashColor: Colors.transparent, // 버튼 클릭 시 나타나는 스플래시 효과 색상을 투명으로 설정
        highlightColor: Colors.transparent, // 버튼 눌림 효과 색상을 투명으로 설정
        padding: EdgeInsets.only(bottom: appBarHeight * 0.35), // 아이콘의 위치를 조정하기 위한 패딩 설정
        onPressed: onPressed, // onPressed 콜백 함수 연결
        child: Icon(icon, color: Colors.black), // 아이콘 설정, 색상은 검정색
      ),
    );
  }
}
