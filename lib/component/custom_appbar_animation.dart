import 'package:everytime/global_variable.dart';
import 'package:flutter/material.dart';

class CustomAppBarAnimation extends StatelessWidget {
  // 생성자에서 필요한 속성들을 초기화
  const CustomAppBarAnimation({
    super.key,
    required this.scrollOffsetStream, // 스크롤 오프셋 스트림
    required this.title, // 제목
  });

  final Stream<double> scrollOffsetStream;
  final String title;

  // 스크롤 오프셋에 따라 높이를 계산하는 함수
  double _calHeight(double scrollOffset) {
    if (scrollOffset >= appHeight * 0.02) {
      return appHeight * 0.033; // 최소 높이
    } else if (scrollOffset <= 0) {
      return appHeight * 0.053; // 최대 높이
    } else {
      return (appHeight * 0.02 - scrollOffset) + appHeight * 0.033;
    }
  }

  // 스크롤 오프셋에 따라 투명도를 계산하는 함수
  double _calOpacity(double scrollOffset) {
    if (scrollOffset >= appHeight * 0.02) {
      return 0; // 투명
    } else if (scrollOffset <= 0) {
      return 1; // 불투명
    } else {
      return (appHeight * 0.02 - scrollOffset) / (appHeight * 0.02);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: scrollOffsetStream,
      builder: (context, AsyncSnapshot<double> snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: _calHeight(snapshot.data as double), // 높이 계산
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(
              left: appWidth * 0.065, // 좌측 마진
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Color.fromRGBO(
                  195, 90, 69,
                  _calOpacity(snapshot.data as double), // 투명도 계산
                ),
                fontSize: 14.5, // 폰트 크기
              ),
            ),
          );
        }

        return Container(
          height: appHeight * 0.053, // 기본 높이
        );
      },
    );
  }
}
