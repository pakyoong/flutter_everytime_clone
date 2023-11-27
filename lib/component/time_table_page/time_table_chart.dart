import '../../bloc/user_profile_management_bloc.dart';
import 'package:everytime/component/custom_button_modal_bottom_sheet.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/screen_dimensions.dart';
import '../../model/time_table_data_models.dart';
import '../../model/academic_enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeTableChart extends StatelessWidget {
  const TimeTableChart({
    super.key,
    required this.userBloc,
    this.isActivateButton = true,
    this.shadowDataList,
    required this.classTimetable,
    required this.startHour,
    required this.timeList,
    required this.dayOfWeekList,
    this.scrollController,
  });

  final List<int> timeList;
  final List<Weekday> dayOfWeekList;
  final List<ClassTimeTable> classTimetable;
  final List<ClassTimeAndLocation>? shadowDataList;
  final EverytimeUserBloc userBloc;
  final bool isActivateButton;
  final ScrollController? scrollController;

  final int startHour;

  List<Widget> _buildShadows(BuildContext context) {
    List<Widget> result = [];

    for (ClassTimeAndLocation data in shadowDataList ?? []) {
      result.add(
        StreamBuilder(
          stream: userBloc.isDark,
          builder: (_, isDarkSnapshot) {
            if (isDarkSnapshot.hasData) {
              return Positioned(
                top: _getPositionTop(data),
                left: _getPositionLeft(data),
                child: Container(
                  height: _getContainerHeight(data),
                  width: _getContainerWidth(),
                  color: isDarkSnapshot.data!
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.2),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );
    }

    return result;
  }

  double _getContainerWidth() {
    return availableWidth * 0.8995 / dayOfWeekList.length;
  }

  double _getContainerHeight(ClassTimeAndLocation data) {
    DateTime startTime = DateTime(1970, 1, 1, data.endHour, data.endMinute);
    DateTime endTime = DateTime(1970, 1, 1, data.startHour, data.startMinute);
    int diff = startTime.difference(endTime).inMinutes;

    return (availableHeight * diff / 5 * 0.00483);
  }

  double _getPositionLeft(ClassTimeAndLocation data) {
    double pos = availableWidth *
        (0.8995 / dayOfWeekList.length) *
        (Weekday.indexOfWeekday(data.weekday));
    return (availableWidth * 0.055) + pos;
  }

  double _getPositionTop(ClassTimeAndLocation data) {
    DateTime startTime = DateTime(1970, 1, 1, data.startHour, data.startMinute);
    DateTime endTime = DateTime(1970, 1, 1, timeList[0], 0);
    int diff = startTime.difference(endTime).inMinutes;

    return ((availableHeight * 0.022) + (availableHeight * diff / 5 * 0.00483));
  }

  void _buildRemoveDialog(BuildContext context, int currentIndex) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: userBloc.isDark,
          title: '수업을 삭제하시겠습니까?',
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
              child: const Text('삭제'),
              onPressed: () {
                // TODO: 전체 시간표 목록 갱신해야함.

                userBloc.removeClassTimetableDataAt(
                  currentIndex,
                  classTimetable,
                );

                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    List<Widget> result = [];
    for (int i = 0; i < classTimetable.length; i++) {
      for (ClassTimeAndLocation time in classTimetable[i].times) {
        result.add(
          Positioned(
            top: _getPositionTop(time),
            left: _getPositionLeft(time),
            child: Container(
              height: _getContainerHeight(time),
              width: _getContainerWidth(),
              color: Colors.green,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: isActivateButton
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          builder: (bottomSheetContext) {
                            return SizedBox(
                              height: availableHeight * 0.085 +
                                  (availableHeight * 0.06 * 5) +
                                  bottomPadding +
                                  availableHeight * 0.095,
                              child: Column(
                                children: [
                                  _buildSubjectInfo(context, i),
                                  CustomButtonModalBottomSheet(
                                    buttonList: [
                                      CustomButtonModalBottomSheetButton(
                                        icon: Icons.chat_outlined,
                                        title: '강의평',
                                      ),
                                      CustomButtonModalBottomSheetButton(
                                        icon: Icons.note_add_outlined,
                                        title: '메모 추가',
                                      ),
                                      CustomButtonModalBottomSheetButton(
                                        icon:
                                            Icons.format_list_bulleted_outlined,
                                        title: '할일 보기',
                                      ),
                                      CustomButtonModalBottomSheetButton(
                                        icon: Icons.edit_outlined,
                                        title: '약칭 지정',
                                      ),
                                      CustomButtonModalBottomSheetButton(
                                        icon: Icons.delete_outline,
                                        title: '삭제',
                                        onPressed: () {
                                          Navigator.pop(bottomSheetContext);
                                          _buildRemoveDialog(context, i);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    : null,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(2),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        classTimetable[i].className,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        time.location,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return result;
  }

  Widget _buildSubjectInfo(BuildContext context, int index) {
    return Expanded(
      child: Container(
        alignment: Alignment.topLeft,
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(
          top: availableWidth * 0.035,
          left: availableWidth * 0.065,
          right: availableWidth * 0.065,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              classTimetable[index].className,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              classTimetable[index].professor,
              style: const TextStyle(
                fontSize: 17,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeTableElement(
      BuildContext context, int currentRowIndex, int currentColIndex) {
    if (currentRowIndex == 0) {
      if (currentColIndex == 0) {
        return const Center(
          child: SizedBox.shrink(),
        );
      } else {
        return Center(
          child: Container(
            alignment: Alignment.topRight,
            child: Text(
              timeList[currentColIndex - 1].toString(),
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
        );
      }
    } else {
      if (currentColIndex == 0) {
        return Center(
          child: Text(
            dayOfWeekList[currentRowIndex - 1].string,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        );
      } else {
        return const Center();
      }
    }
  }

  Widget _buildTimeTableCol(BuildContext context, int currentRowIndex) {
    return Column(
      children: List.generate(
        timeList.length + 1,
        (currentColIndex) {
          return Container(
            height: (currentColIndex == 0)
                ? availableHeight * 0.022
                : availableHeight * 0.0579125,
            decoration: (currentColIndex + 1 == timeList.length + 1)
                ? null
                : BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
            child: _buildTimeTableElement(
              context,
              currentRowIndex,
              currentColIndex,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: List.generate(
            dayOfWeekList.length + 1,
            (rowIndex) {
              return Container(
                width: (rowIndex == 0)
                    ? availableWidth * 0.055
                    : availableWidth * 0.8995 / dayOfWeekList.length,
                decoration: (rowIndex + 1 == dayOfWeekList.length + 1)
                    ? null
                    : BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                child: _buildTimeTableCol(context, rowIndex),
              );
            },
          ),
        ),
        ..._buildButtons(context),
        ..._buildShadows(context),
      ],
    );
  }
}
