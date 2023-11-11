import 'package:flutter/material.dart';
import 'package:everytime/screen_dimensions.dart';

class AppBarButton extends StatelessWidget {
  const AppBarButton({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback? onPressed; // VoidCallback을 사용하여 함수 타입을 명시적으로 선언합니다.

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = availableHeight * 0.057;
    final double buttonWidth = availableWidth * 0.07;
    final double buttonMarginLeft = availableWidth * 0.055;

    return Container(
      width: buttonWidth,
      height: appBarHeight,
      margin: EdgeInsets.only(left: buttonMarginLeft),
      child: MaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(bottom: appBarHeight * 0.35),
        onPressed: onPressed, // 버튼 아이콘의 위치 조정
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}