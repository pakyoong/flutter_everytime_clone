import 'package:everytime/bloc/time_table_page/lecture_schedule_bloc.dart';
import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/time_table_page/round_button.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/time_table_enums.dart';
import 'package:everytime/model/time_table_page/lecture_time_and_location.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarAtAddDirectPage extends StatelessWidget {
  const AppBarAtAddDirectPage({
    Key? key,
    required this.userBloc,
    required this.addDirectBloc,
    required this.subjectNameController,
    required this.profNameController,
    required this.lastDayOfWeekIndex,
    required this.lastStartHour,
    required this.lastEndHour,
  }) : super(key: key);

  final UserProfileManagementBloc userBloc;
  final LectureScheduleBloc addDirectBloc;
  final TextEditingController subjectNameController;
  final TextEditingController profNameController;

  final int lastDayOfWeekIndex;
  final int lastStartHour;
  final int lastEndHour;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeight * 0.055,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: appWidth * 0.15,
            margin: EdgeInsets.only(
              right: appWidth * 0.025,
            ),
            child: MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Icon(
                Icons.clear,
                color: Theme.of(context).highlightColor,
              ),
              onPressed: () {
                _removeShadow();

                userBloc.updateIsShowingKeyboard(false);
                Navigator.pop(context);
              },
            ),
          ),
          const Text(
            '수업 추가',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          RoundButton(
            title: '완료',
            onPressed: () => _onPressedButton(context),
          ),
        ],
      ),
    );
  }

  void _removeShadow() {
    int tempDayOfWeekIndex = userBloc.defaultDayOfWeekListLast;
    int tempStartHour = userBloc.defaultTimeListFirst;
    int tempEndHour = userBloc.defaultTimeListLast;

    for (LectureTimeAndLocation dates in addDirectBloc.currentLectureScheduleData) {
      if (Weekday.indexOfWeekday(dates.weekday) > tempDayOfWeekIndex) {
        tempDayOfWeekIndex = Weekday.indexOfWeekday(dates.weekday);
      }

      if (dates.startHour < tempStartHour) {
        tempStartHour = dates.startHour;
      }

      if (dates.endHour > tempEndHour) {
        tempEndHour = dates.endHour;
      }
    }

    addDirectBloc.resetLectureSchedule();
    userBloc.removeDayOfWeek(
      tempDayOfWeekIndex,
      [
        LectureTimeAndLocation(
          weekday: Weekday.weekdayAtIndex(lastDayOfWeekIndex),
          startHour: lastStartHour,
          endHour: lastEndHour,
        ),
      ],
    );
    userBloc.removeTimeList(
      tempStartHour,
      tempEndHour,
      [
        LectureTimeAndLocation(
          weekday: Weekday.weekdayAtIndex(lastDayOfWeekIndex),
          startHour: lastStartHour,
          endHour: lastEndHour,
        ),
      ],
    );
  }

  void _onPressedButton(BuildContext context) {
    if (primaryFocus?.hasFocus ?? false) {
      primaryFocus?.unfocus();
    }

    if (userBloc.currentIsShowingKeyboard) {
      userBloc.updateIsShowingKeyboard(false);
    }

    if (addDirectBloc.currentLectureScheduleData.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) {
          return CustomCupertinoAlertDialog(
            isDarkStream: userBloc.isDark,
            title: '시간정보를 입력해주세요',
            actions: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );
      return;
    }

    TimeTableData tempData = TimeTableData(
      professor: profNameController.text,
      times: addDirectBloc.currentLectureScheduleData,
      className: subjectNameController.text,
    );
    String? result = userBloc.checkTimeTableCrash(tempData);

    if (result != null) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) {
          return CustomCupertinoAlertDialog(
            isDarkStream: userBloc.isDark,
            title: '$result 수업과\n 시간이 겹칩니다.',
            actions: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (subjectNameController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) {
          return CustomCupertinoAlertDialog(
            isDarkStream: userBloc.isDark,
            title: '수업명을 입력해주세요',
            actions: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('확인'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        },
      );
      return;
    }

    //TODO: 전체 시간표 목록 갱신해야함.
    userBloc.currentSelectedTimeTable!.addClass(tempData);

    profNameController.text = '';
    subjectNameController.text = '';
    addDirectBloc.resetLectureSchedule();

    Navigator.pop(context);

    //TODO: 전체 시간표 배열에서도 업데이트하는 구문 필요함.
  }
}
