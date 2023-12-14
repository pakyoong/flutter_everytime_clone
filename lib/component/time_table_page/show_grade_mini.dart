import 'package:flutter/material.dart';

class ShowGradeMini extends StatelessWidget {
  // 생성자에서 필요한 속성들을 초기화
  const ShowGradeMini({
    Key? key,
    required this.title, // 제목
    required this.current, // 현재 값
    required this.max, // 최대 값
  }) : super(key: key);

  final String title;
  final String current;
  final String max;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title ',
          style: TextStyle(
            fontSize: 19, // 제목 폰트 크기
            color: Theme.of(context).highlightColor, // 제목 색상
          ),
        ),
        Text(
          current,
          style: TextStyle(
            fontSize: 19, // 현재 값 폰트 크기
            fontWeight: FontWeight.bold, // 현재 값 볼드 처리
            color: Theme.of(context).focusColor, // 현재 값 색상
          ),
        ),
        Text(
          '/ $max',
          style: TextStyle(
            fontSize: 15, // 최대 값 폰트 크기
            color: Theme.of(context).hintColor, // 최대 값 색상
          ),
        ),
      ],
    );
  }
}