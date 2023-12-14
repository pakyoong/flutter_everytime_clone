import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class ShowGradeLarge extends StatelessWidget {
  // 생성자에서 필요한 속성들을 초기화
  const ShowGradeLarge({
    Key? key,
    required this.title, // 제목
    required this.currentValue, // 현재 값
    required this.totalValue, // 총 값
    this.isShowButton = false, // 버튼 표시 여부
    this.icon = Icons.settings, // 아이콘
    this.onPressed, // 버튼 클릭 이벤트 핸들러
  }) : super(key: key);

  final String title;
  final String currentValue;
  final String totalValue;
  final bool isShowButton;
  final IconData icon;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: appWidth * 0.225, // 너비
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14, // 제목 스타일
            ),
          ),
          SizedBox(
            height: appHeight * 0.01, // 여백
          ),
          (!isShowButton)
              ? Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: currentValue,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22, // 현재 값 스타일
                        ),
                        children: [
                          TextSpan(
                            text: ' / $totalValue',
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 10, // 총 값 스타일
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: appHeight * 0.03, // 버튼 높이
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    minWidth: appWidth * 0.022,
                    // 버튼 최소 너비
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: currentValue,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                            children: [
                              TextSpan(
                                text: ' / $totalValue',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            icon,
                            size: 10, // 아이콘 크기
                            color: Theme.of(context).hintColor, // 아이콘 색상
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      onPressed?.call(); // 클릭 이벤트 처리
                    },
                  ),
                ),
        ],
      ),
    );
  }
}