import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/bloc/time_table_page/time_table_list_manager_bloc.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/ui/time_table_page/add_time_table_page/add_time_table_page.dart';

class AppBarAtTimeTableListPage extends StatelessWidget {
  AppBarAtTimeTableListPage({
    super.key,
    required this.pageContext,
    required this.userBloc,
    required this.timeTableListBloc,
  });

  final BuildContext pageContext;
  final UserProfileManagementBloc userBloc;
  final TimeTableListManagerBloc timeTableListBloc;

  final double _buttonWidth = appWidth * 0.15;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.055,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: _buttonWidth,
            child: MaterialButton(
              padding: EdgeInsets.only(
                right: appWidth * 0.07,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.pop(pageContext);
              },
            ),
          ),
          const Text(
            '시간표 목록',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          SizedBox(
            width: _buttonWidth,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(Icons.add_box_outlined),
              onPressed: () {
                Navigator.push(
                  pageContext,
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (newPageContext) {
                      return AddTimeTablePage(
                        userBloc: userBloc,
                        timeTableListBloc: timeTableListBloc,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
