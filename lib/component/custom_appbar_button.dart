import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomAppBarButton extends StatelessWidget {
  // 생성자에서 필요한 속성들을 초기화
  CustomAppBarButton({
    super.key,
    required this.icon, // 아이콘 데이터
    this.onPressed, // 버튼 클릭 이벤트 핸들러
  });

  final IconData icon;
  final Function? onPressed;

  final double _appBarHeight = appHeight * 0.057; // 앱바의 높이

  @override
  Widget build(BuildContext context) {
    return Container(
      width: appWidth * 0.07, // 컨테이너 너비
      height: _appBarHeight, // 컨테이너 높이
      margin: EdgeInsets.only(
        left: appWidth * 0.055, // 좌측 마진
      ),
      child: MaterialButton(
        splashColor: Colors.transparent, // 스플래시 효과 제거
        highlightColor: Colors.transparent, // 하이라이트 효과 제거
        padding: EdgeInsets.only(
          bottom: appHeight * 0.02, // 하단 패딩
        ),
        child: Icon(
          icon, // 아이콘 설정
          color: Theme.of(context).highlightColor, // 아이콘 색상
        ),
        onPressed: () {
          onPressed?.call(); // 클릭 이벤트 처리
        },
      ),
    );
  }
}