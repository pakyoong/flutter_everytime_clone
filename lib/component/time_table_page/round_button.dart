import 'package:everytime/global_variable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  // 라운드 버튼 위젯의 생성자
  const RoundButton({
    Key? key,
    required this.title, // 버튼의 타이틀
    this.onPressed, // 버튼 클릭 이벤트 핸들러
  }) : super(key: key);

  final String title; // 버튼의 타이틀
  final Function? onPressed; // 클릭 시 실행될 함수

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeight * 0.04, // 컨테이너 높이
      width: appWidth * 0.125, // 컨테이너 너비
      margin: EdgeInsets.only(
        right: appWidth * 0.05, // 오른쪽 마진
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(appHeight * 0.04 / 2), // 라운드 처리
        color: Theme.of(context).focusColor, // 배경 색상
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero, // 버튼의 패딩
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor, // 텍스트 색상
          ),
        ),
        onPressed: () {
          onPressed?.call(); // 클릭 시 함수 호출
        },
      ),
    );
  }
}