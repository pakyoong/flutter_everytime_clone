import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/component/custom_picker_modal_bottom_sheet.dart';
import 'package:everytime/component/time_table_page/custom_text_field.dart';
import 'package:everytime/screen_dimensions.dart';
import '../../../model/academic_enums.dart';
import '../../../model/time_table_data_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataInputAtAddDirectPage extends StatelessWidget {
  const DataInputAtAddDirectPage({
    Key? key,
    required this.userBloc,
    required this.addDirectBloc,
    required this.subjectNameController,
    required this.profNameController,
    required this.timeTableScrollController,
    required this.lastDayOfWeekIndex,
    required this.lastStartHour,
    required this.lastEndHour,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final DirectAdditionBloc addDirectBloc;
  final TextEditingController subjectNameController;
  final TextEditingController profNameController;
  final ScrollController timeTableScrollController;

  final int lastDayOfWeekIndex;
  final int lastStartHour;
  final int lastEndHour;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: addDirectBloc.classTimes,
        builder: (_, timeNPlaceDataSnapshot) {
          if (timeNPlaceDataSnapshot.hasData) {
            return ListView(
              children: _buildListViewChildren(
                  context, timeNPlaceDataSnapshot.data!.length),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<Widget> _buildListViewChildren(
    BuildContext context,
    int currentLength,
  ) {
    return List.generate(
      currentLength + 2,
      (index) {
        if (index == 0) {
          return _buildListViewChildrenFirst(context);
        } else if (index + 1 == currentLength + 2) {
          return _buildListViewChildrenLast(context);
        } else {
          return _buildListViewChildrenRemain(context, index);
        }
      },
    );
  }

  Widget _buildListViewChildrenFirst(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: availableWidth * 0.05,
        right: availableWidth * 0.05,
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: subjectNameController,
            hintText: '수업명',
            isHintBold: true,
            onTap: () {
              userBloc.updateIsShowingKeyboard(true);
            },
            onSubmitted: (value) {
              userBloc.updateIsShowingKeyboard(false);
            },
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(
              bottom: availableHeight * 0.0125,
            ),
            color: Theme.of(context).dividerColor,
          ),
          CustomTextField(
            controller: profNameController,
            hintText: '교수명',
            onTap: () {
              userBloc.updateIsShowingKeyboard(true);
            },
            onSubmitted: (value) {
              userBloc.updateIsShowingKeyboard(false);
            },
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(
              bottom: availableHeight * 0.0125,
            ),
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  Widget _buildListViewChildrenLast(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: availableWidth,
      margin: EdgeInsets.only(
        left: availableWidth * 0.05,
        right: availableWidth * 0.05,
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Text(
          '시간 및 장소 추가',
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontSize: 21,
          ),
        ),
        onPressed: () {
          if (timeTableScrollController.hasClients) {
            timeTableScrollController.animateTo(
              _getScrollOffsetY(
                ClassTimeAndLocation(),
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
            );
          }
          addDirectBloc.addClassTime();
        },
      ),
    );
  }

  Widget _buildListViewChildrenRemain(
    BuildContext context,
    int index,
  ) {
    return Container(
      margin: EdgeInsets.only(
        left: availableWidth * 0.05,
        right: availableWidth * 0.05,
        bottom: availableHeight * 0.0125,
      ),
      child: Column(
        children: [
          MaterialButton(
            padding: EdgeInsets.zero,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: StreamBuilder(
              stream: addDirectBloc.classTimes,
              builder: (_, timeNPlaceDataSnapshot) {
                if (timeNPlaceDataSnapshot.hasData) {
                  return Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: timeNPlaceDataSnapshot
                                  .data![index - 1].weekday.string,
                            ),
                            TextSpan(
                              text: _buildTimeString(
                                timeNPlaceDataSnapshot
                                    .data![index - 1].startHour,
                                timeNPlaceDataSnapshot
                                    .data![index - 1].startMinute,
                              ),
                            ),
                            const TextSpan(
                              text: '-',
                            ),
                            TextSpan(
                              text: _buildTimeString(
                                timeNPlaceDataSnapshot.data![index - 1].endHour,
                                timeNPlaceDataSnapshot
                                    .data![index - 1].endMinute,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Theme.of(context).focusColor,
                        size: 15,
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            onPressed: () {
              _buildSelectTimeBottomSheet(context, index);
            },
          ),
          Row(
            children: [
              Container(
                height: availableHeight * 0.05,
                width: availableWidth * 0.8,
                padding: EdgeInsets.only(
                  right: availableWidth * 0.02,
                ),
                child: CustomTextField(
                  maxLines: 1,
                  scrollPadding: EdgeInsets.zero,
                  isDense: true,
                  hintText: '장소',
                  onTap: () {
                    userBloc.updateIsShowingKeyboard(true);
                  },
                  onChanged: (value) {
                    addDirectBloc.updateClassTime(
                      index - 1,
                      location: value,
                    );
                  },
                  onSubmitted: (value) {
                    userBloc.updateIsShowingKeyboard(false);
                  },
                ),
              ),
              SizedBox(
                width: availableWidth * 0.1,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: const Center(
                    child: Icon(
                      Icons.delete_outlined,
                    ),
                  ),
                  onPressed: () {
                    _buildRemoveDialog(context, index);
                  },
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: EdgeInsets.only(
              bottom: availableHeight * 0.0125,
            ),
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }

  double _getScrollOffsetY(ClassTimeAndLocation data) {
    DateTime startTime = DateTime(1970, 1, 1, data.endHour, data.endMinute);
    DateTime endTime = DateTime(1970, 1, 1, userBloc.currentTimeList[0], 0);
    int diff = startTime.difference(endTime).inMinutes;

    double tempOffset = (availableHeight * diff / 5 * 0.00483);

    return (tempOffset - availableHeight * 0.28) + availableHeight * 0.072;
  }

  String _buildTimeString(int hour, int minute) {
    String tempHour = '';
    String tempMinute = '';
    if (hour < 10) {
      tempHour = '0$hour';
    } else {
      tempHour = '$hour';
    }

    if (minute < 10) {
      tempMinute = '0$minute';
    } else {
      tempMinute = '$minute';
    }

    return ' $tempHour:$tempMinute ';
  }

  void _buildSelectTimeBottomSheet(BuildContext context, int currentIndex) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        int dayOfWeekIndex = Weekday.indexOfWeekday(
            addDirectBloc.currentClassTimes[currentIndex - 1].weekday);
        DateTime startTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          addDirectBloc.currentClassTimes[currentIndex - 1].startHour,
          addDirectBloc.currentClassTimes[currentIndex - 1].startMinute,
        );
        DateTime endTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          addDirectBloc.currentClassTimes[currentIndex - 1].endHour,
          addDirectBloc.currentClassTimes[currentIndex - 1].endMinute,
        );

        return CustomPickerModalBottomSheet(
          title: '시간 선택',
          onPressedCancel: () {
            Navigator.pop(bottomSheetContext);
          },
          onPressedSave: () {
            if (startTime.hour > endTime.hour ||
                (startTime.hour == endTime.hour &&
                    startTime.minute >= endTime.minute)) {
              _buildSetEndTimeDialog(context);
            } else {
              _doPassOnPressedSave(
                bottomSheetContext: bottomSheetContext,
                dayOfWeekIndex: dayOfWeekIndex,
                startTime: startTime,
                endTime: endTime,
                currentIndex: currentIndex,
              );
            }
          },
          picker: Container(
            padding: EdgeInsets.only(
              right: availableWidth * 0.05,
              left: availableWidth * 0.05,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // DayOfWeek Picker
                SizedBox(
                  width: availableWidth * 0.2,
                  child: CupertinoPicker(
                    itemExtent: 32,
                    scrollController: FixedExtentScrollController(
                      initialItem: Weekday.indexOfWeekday(addDirectBloc
                          .currentClassTimes[currentIndex - 1].weekday),
                    ),
                    children: List.generate(
                      Weekday.allWeekdays().length,
                      (index) {
                        return Center(
                          child: Text(
                            Weekday.allWeekdays()[index].string,
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (value) {
                      dayOfWeekIndex = value;
                    },
                  ),
                ),
                // StartTime Picker
                SizedBox(
                  width: availableWidth * 0.3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      addDirectBloc
                          .currentClassTimes[currentIndex - 1].startHour,
                      addDirectBloc
                          .currentClassTimes[currentIndex - 1].startMinute,
                    ),
                    minuteInterval: 5,
                    use24hFormat: true,
                    onDateTimeChanged: (value) {
                      startTime = value;
                    },
                  ),
                ),
                // EndTime Picker
                SizedBox(
                  width: availableWidth * 0.3,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    initialDateTime: DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      addDirectBloc
                          .currentClassTimes[currentIndex - 1].endHour,
                      addDirectBloc
                          .currentClassTimes[currentIndex - 1].endMinute,
                    ),
                    minuteInterval: 5,
                    use24hFormat: true,
                    onDateTimeChanged: (value) {
                      endTime = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _buildSetEndTimeDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '종료시간을 시작시간\n이후로 설정해주세요.',
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

  void _doPassOnPressedSave({
    required BuildContext bottomSheetContext,
    required int dayOfWeekIndex,
    required DateTime startTime,
    required DateTime endTime,
    required int currentIndex,
  }) {
    Navigator.pop(bottomSheetContext);

    userBloc.addDayOfWeek(dayOfWeekIndex);
    userBloc.addTimeList(startTime.hour, endTime.hour);

    addDirectBloc.updateClassTime(
      currentIndex - 1,
      weekday: Weekday.weekdayAtIndex(dayOfWeekIndex),
      startHour: startTime.hour,
      startMinute: startTime.minute,
      endHour: endTime.hour,
      endMinute: endTime.minute,
    );

    if (timeTableScrollController.hasClients) {
      timeTableScrollController.animateTo(
        _getScrollOffsetY(
          ClassTimeAndLocation(
            startHour: startTime.hour,
            startMinute: startTime.minute,
            endHour: endTime.hour,
            endMinute: endTime.minute,
          ),
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  void _buildRemoveDialog(
    BuildContext context,
    int currentIndex,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '삭제하시겠습니까?',
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(dialogContext);

                int tempDayOfWeek = Weekday.indexOfWeekday(addDirectBloc
                    .currentClassTimes[currentIndex - 1].weekday);
                int tempStartHour = addDirectBloc
                    .currentClassTimes[currentIndex - 1].startHour;
                int tempEndHour = addDirectBloc
                    .currentClassTimes[currentIndex - 1].endHour;

                addDirectBloc.removeClassTime(currentIndex - 1);
                userBloc.removeDayOfWeek(
                  tempDayOfWeek,
                  [
                    ...addDirectBloc.currentClassTimes,
                    ClassTimeAndLocation(
                      startHour: lastStartHour,
                      endHour: lastEndHour,
                      weekday: Weekday.weekdayAtIndex(lastDayOfWeekIndex),
                    ),
                  ],
                );
                userBloc.removeTimeList(
                  tempStartHour,
                  tempEndHour,
                  [
                    ...addDirectBloc.currentClassTimes,
                    ClassTimeAndLocation(
                      startHour: lastStartHour,
                      endHour: lastEndHour,
                      weekday: Weekday.weekdayAtIndex(lastDayOfWeekIndex),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
