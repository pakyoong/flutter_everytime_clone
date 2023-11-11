import 'package:flutter/material.dart';
import 'package:everytime/screen_dimensions.dart';

class DynamicAppBar extends StatelessWidget {
  const DynamicAppBar({
    Key? key,
    required this.actions,
    required this.title,
  }) : super(key: key);

  final List<Widget> actions;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = availableHeight * 0.057; // 수정된 부분

    return Container(
      height: appBarHeight,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: availableWidth * 0.065), // 수정된 부분
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: actions),
        ],
      ),
    );
  }
}