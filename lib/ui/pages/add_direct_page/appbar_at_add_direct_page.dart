import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/time_table_page/round_button.dart';
import 'package:everytime/screen_dimensions.dart';
import '../../../model/academic_enums.dart';
import '../../../model/time_table_data_models.dart';
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

  final EverytimeUserBloc userBloc;
  final DirectAdditionBloc addDirectBloc;
  final TextEditingController subjectNameController;
  final TextEditingController profNameController;

  final int lastDayOfWeekIndex;
  final int lastStartHour;
  final int lastEndHour;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: availableHeight * 0.055,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: availableWidth * 0.15,
            margin: EdgeInsets.only(
              right: availableWidth * 0.025,
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

    for (ClassTimeAndLocation dates in addDirectBloc.currentClassTimes) {
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

    addDirectBloc.resetClassTimes();
    userBloc.removeDayOfWeek(
      tempDayOfWeekIndex,
      [
        ClassTimeAndLocation(
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
        ClassTimeAndLocation(
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

    if (addDirectBloc.currentClassTimes.isEmpty) {
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

    ClassTimeTable tempData = ClassTimeTable(
      professor: profNameController.text,
      times: addDirectBloc.currentClassTimes,
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
    userBloc.currentSelectedClassTimetable!.addClass(tempData);

    profNameController.text = '';
    subjectNameController.text = '';
    addDirectBloc.resetClassTimes();

    Navigator.pop(context);

    //TODO: 전체 시간표 배열에서도 업데이트하는 구문 필요함.
  }
}
