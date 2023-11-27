import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/time_table_page/round_button.dart';
import 'package:everytime/screen_dimensions.dart';
import '../../../model/time_table_data_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarAtAddTimeTablePage extends StatelessWidget {
  const AppBarAtAddTimeTablePage({
    Key? key,
    required this.pageContext,
    required this.userBloc,
    required this.timeTableListBloc,
    required this.timeTableNameController,
  }) : super(key: key);

  final BuildContext pageContext;
  final EverytimeUserBloc userBloc;
  final TimeTableListManagerBloc timeTableListBloc;
  final TextEditingController timeTableNameController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: availableWidth * 0.055,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: availableWidth * 0.15,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: const Icon(Icons.clear_outlined),
              onPressed: () {
                Navigator.pop(pageContext);
              },
            ),
          ),
          const Text(
            '새 시간표 만들기',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          RoundButton(
            title: '완료',
            onPressed: () {
              if (timeTableNameController.text.isEmpty) {
                _buildIncorrectTimeTableNameDialog();
              } else {ClassTimetable timeTable = ClassTimetable(
                term: timeTableListBloc.currentTermPickerList[timeTableListBloc.currentSelectedTermIndex],
              );
              timeTable.updateTitle(timeTableNameController.text);

                timeTableListBloc.sortClassTimetable([timeTable]);
                userBloc.addTimeTableList(timeTable);

                Navigator.pop(pageContext);
              }
            },
          ),
        ],
      ),
    );
  }

  void _buildIncorrectTimeTableNameDialog() {
    showCupertinoDialog(
      context: pageContext,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '올바른 이름이 아닙니다.',
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('닫기'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}
