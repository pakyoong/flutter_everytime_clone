import 'package:everytime/screen_dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: availableHeight * 0.04,
      width: availableWidth * 0.125,
      margin: EdgeInsets.only(
        right: availableWidth * 0.05,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(availableHeight * 0.04 / 2),
        color: Theme.of(context).focusColor,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        onPressed: () {
          onPressed?.call();
        },
      ),
    );
  }
}
