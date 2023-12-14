import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  // 생성자에서 필요한 속성들을 초기화
  CustomAppBar({
    Key? key,
    required this.buttonList, // 앱바에 포함될 버튼 리스트
    required this.title, // 앱바의 제목
  }) : super(key: key);

  final List<Widget> buttonList;
  final String title;

  final double _appBarHeight = appHeight * 0.057; // 앱바의 높이

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _appBarHeight, // 컨테이너 높이 설정
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        left: appWidth * 0.065, // 좌측 패딩
        right: appWidth * 0.065, // 우측 패딩
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 주축 정렬
        crossAxisAlignment: CrossAxisAlignment.start, // 교차축 정렬
        children: [
          SizedBox(
            width: appWidth * 0.475, // 제목 영역의 너비
            child: Text(
              title,
              style: const TextStyle(
                //color: Theme.of(context).highlightColor,
                fontSize: 27, // 폰트 크기
                fontWeight: FontWeight.bold, // 폰트 굵기
              ),
              overflow: TextOverflow.ellipsis, // 오버플로 처리
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttonList, // 버튼 리스트 추가
          ),
        ],
      ),
    );
  }
}