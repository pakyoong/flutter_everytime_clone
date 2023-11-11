import 'package:flutter/material.dart';
import 'package:everytime/screen_dimensions.dart';

class ScrollResponsiveAppBar extends StatelessWidget {
  const ScrollResponsiveAppBar({
    Key? key,
    required this.scrollOffsetStream,
    required this.title,
  }) : super(key: key);

  final Stream<double> scrollOffsetStream;
  final String title;

  double _calHeight(double scrollOffset) {
    double threshold = availableHeight * 0.02;
    if (scrollOffset >= threshold) {
      return availableHeight * 0.033;
    } else if (scrollOffset <= 0) {
      return availableHeight * 0.053;
    } else {
      return (threshold - scrollOffset) + availableHeight * 0.033;
    }
  }

  double _calOpacity(double scrollOffset) {
    double threshold = availableHeight * 0.02;
    if (scrollOffset >= threshold) {
      return 0;
    } else if (scrollOffset <= 0) {
      return 1;
    } else {
      return (threshold - scrollOffset) / threshold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: scrollOffsetStream,
      builder: (context, snapshot) {
        double height = _calHeight(snapshot.data ?? 0);
        double opacity = _calOpacity(snapshot.data ?? 0);

        return Container(
          height: height,
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(left: availableWidth * 0.065),
          color: Colors.white.withOpacity(opacity),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14.5,
            ),
          ),
        );
      },
    );
  }
}