import 'package:everytime/bloc/user_profile_management_bloc.dart';
import 'package:everytime/component/custom_button_modal_bottom_sheet.dart';
import 'package:everytime/component/custom_cupertino_alert_dialog.dart';
import 'package:everytime/global_variable.dart';
import 'package:everytime/model/time_table_enums.dart';
import 'package:everytime/model/time_table_page/lecture_time_and_location.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeTableChart extends StatelessWidget {
  // 생성자에서 필요한 속성들을 초기화
  const TimeTableChart({
    Key? key,
    required this.userBloc, // 사용자 블록
    this.isActivateButton = true, // 버튼 활성화 여부
    this.shadowDataList, // 그림자 데이터 리스트
    required this.timeTableData, // 시간표 데이터
    required this.startHour, // 시작 시간
    required this.timeList, // 시간 목록
    required this.dayOfWeekList, // 요일 목록
    this.scrollController, // 스크롤 컨트롤러
  }) : super(key: key);

  final List<int> timeList;
  final List<Weekday> dayOfWeekList;
  final List<TimeTableData> timeTableData;
  final List<LectureTimeAndLocation>? shadowDataList;
  final UserProfileManagementBloc userBloc;
  final bool isActivateButton;
  final ScrollController? scrollController;

  final int startHour;

  List<Widget> _buildShadows(BuildContext context) {
    List<Widget> result = [];

    for (LectureTimeAndLocation data in shadowDataList ?? []) {
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
    return appWidth * 0.8995 / dayOfWeekList.length;
  }

  double _getContainerHeight(LectureTimeAndLocation data) {
    DateTime startTime = DateTime(1970, 1, 1, data.endHour, data.endMinute);
    DateTime endTime = DateTime(1970, 1, 1, data.startHour, data.startMinute);
    int diff = startTime.difference(endTime).inMinutes;

    return (appHeight * diff / 5 * 0.00483);
  }

  double _getPositionLeft(LectureTimeAndLocation data) {
    double pos = appWidth *
        (0.8995 / dayOfWeekList.length) *
        (Weekday.indexOfWeekday(data.weekday));
    return (appWidth * 0.055) + pos;
  }

  double _getPositionTop(LectureTimeAndLocation data) {
    DateTime startTime = DateTime(1970, 1, 1, data.startHour, data.startMinute);
    DateTime endTime = DateTime(1970, 1, 1, timeList[0], 0);
    int diff = startTime.difference(endTime).inMinutes;

    return ((appHeight * 0.022) + (appHeight * diff / 5 * 0.00483));
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

                userBloc.removeTimeTableDataAt(
                  currentIndex,
                  timeTableData,
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
    for (int i = 0; i < timeTableData.length; i++) {
      for (LectureTimeAndLocation data in timeTableData[i].times) {
        result.add(
          Positioned(
            top: _getPositionTop(data),
            left: _getPositionLeft(data),
            child: Container(
              height: _getContainerHeight(data),
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
                              height: appHeight * 0.085 +
                                  (appHeight * 0.06 * 5) +
                                  paddingBottom +
                                  appHeight * 0.095,
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
                        timeTableData[i].className,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        data.location,
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
          top: appHeight * 0.035,
          left: appWidth * 0.065,
          right: appWidth * 0.065,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeTableData[index].className,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              timeTableData[index].professor,
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
                ? appHeight * 0.022
                : appHeight * 0.0579125,
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
                    ? appWidth * 0.055
                    : appWidth * 0.8995 / dayOfWeekList.length,
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
