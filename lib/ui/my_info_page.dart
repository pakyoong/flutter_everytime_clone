import 'package:flutter/material.dart';

class CampusPickPage extends StatelessWidget {
  const CampusPickPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'campus pick page',
          style: TextStyle(
            color: Theme.of(context).highlightColor,
          ),
        ),
      ),
    );
  }
}
