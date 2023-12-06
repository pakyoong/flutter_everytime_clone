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
import 'package:cloud_firestore/cloud_firestore.dart';

class AppBarAtAddDirectPage extends StatelessWidget {
  AppBarAtAddDirectPage({
    super.key,
    required this.userBloc,
    required this.addDirectBloc,
    required this.subjectNameController,
    required this.profNameController,
    required this.lastDayOfWeekIndex,
    required this.lastStartHour,
    required this.lastEndHour,
  });

  final UserProfileManagementBloc userBloc;
  final LectureScheduleBloc addDirectBloc;
  final TextEditingController subjectNameController;
  final TextEditingController profNameController;

  final int lastDayOfWeekIndex;
  final int lastStartHour;
  final int lastEndHour;

  // Firestore 인스턴스 추가
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                color: Theme
                    .of(context)
                    .highlightColor,
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

    for (LectureTimeAndLocation dates in addDirectBloc
        .currentLectureScheduleData) {
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
    // 키보드가 열려있다면 닫음
    if (primaryFocus?.hasFocus ?? false) {
      primaryFocus?.unfocus();
    }

    // 키보드 상태 업데이트
    if (userBloc.currentIsShowingKeyboard) {
      userBloc.updateIsShowingKeyboard(false);
    }

    // 강의 시간 및 장소 데이터가 없는 경우 다이얼로그 표시
    if (addDirectBloc.currentLectureScheduleData.isEmpty) {
      _showDialog(context, '시간정보를 입력해주세요');
      return;
    }

    // 수업 데이터 객체 생성
    TimeTableData tempData = TimeTableData(
      professor: profNameController.text,
      times: addDirectBloc.currentLectureScheduleData,
      className: subjectNameController.text,
    );

    // 시간표 충돌 검사
    String? result = userBloc.checkTimeTableCrash(tempData);

    // 시간표 충돌 발생 시 다이얼로그 표시
    if (result != null) {
      _showDialog(context, '$result 수업과\n 시간이 겹칩니다.');
      return;
    }

    // 수업명이 비어있는 경우 다이얼로그 표시
    if (subjectNameController.text.isEmpty) {
      _showDialog(context, '수업명을 입력해주세요');
      return;
    }

    // Firestore에 수업 정보 저장
    firestore.collection('timeTables').add({
      'professor': profNameController.text,
      'className': subjectNameController.text,
      'times': addDirectBloc.currentLectureScheduleData.map((e) =>
      {
        'weekday': e.weekday.index,
        'startHour': e.startHour,
        'startMinute': e.startMinute,
        'endHour': e.endHour,
        'endMinute': e.endMinute,
        'location': e.location, // 필요한 경우
      }).toList(),
    }).then((value) {
      // 성공적으로 추가된 경우
      profNameController.text = '';
      subjectNameController.text = '';
      addDirectBloc.resetLectureSchedule();

      Navigator.pop(context);
    }).catchError((error) {
      // 에러 처리
      _showDialog(context, '오류가 발생했습니다. 다시 시도해주세요');
    });
  }

  void _showDialog(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: message,
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
  }
}