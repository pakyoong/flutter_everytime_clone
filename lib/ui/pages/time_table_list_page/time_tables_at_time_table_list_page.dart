import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/component/custom_container.dart';
import 'package:everytime/component/custom_container_title.dart';
import 'package:everytime/screen_dimensions.dart';
import '../../../model/time_table_data_models.dart';
import 'package:flutter/material.dart';

class TimeTablesAtTimeTableListPage extends StatelessWidget {
  TimeTablesAtTimeTableListPage({
    Key? key,
    required this.userBloc,
    required this.timeTableListBloc,
    required this.pageScrollController,
    required this.pageContext,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final TimeTableListManagerBloc timeTableListBloc;
  final ScrollController pageScrollController;
  final BuildContext pageContext;

  final double _buttonHeight = availableHeight * 0.025;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: timeTableListBloc.sortedClassTimetable,
        builder: (_, sortedTimeTableSnapshot) {
          if (sortedTimeTableSnapshot.hasData) {
            return ListView(
              controller: pageScrollController,
              children: List.generate(
                sortedTimeTableSnapshot.data!.length,
                (sortedTimeTableIndex) {
                  return CustomContainer(
                    child: Column(
                      children: [
                        CustomContainerTitle(
                          title: sortedTimeTableSnapshot
                              .data![sortedTimeTableIndex].termName,
                          type: CustomContainerTitleType.none,
                        ),
                        _buildContents(
                          sortedTimeTableSnapshot.data!,
                          sortedTimeTableIndex,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContents(
    List<TermClassTimetable> sortedTimeTable,
    int sortedTimeTableIndex,
  ) {
    return Container(
      height: sortedTimeTable[sortedTimeTableIndex].classTimetable.length *
              (_buttonHeight + availableHeight * 0.03) -
          availableHeight * 0.03,
      margin: EdgeInsets.only(
        top: availableHeight * 0.01,
        left: availableWidth * 0.05,
        right: availableWidth * 0.05,
      ),
      child: Column(
        children: List.generate(
          sortedTimeTable[sortedTimeTableIndex].classTimetable.length,
          (timeTableIndex) {
            return Container(
              margin: EdgeInsets.only(
                top: timeTableIndex != 0 ? availableHeight * 0.03 : 0,
              ),
              height: _buttonHeight,
              child: MaterialButton(
                padding: EdgeInsets.zero,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sortedTimeTable[sortedTimeTableIndex]
                          .classTimetable[timeTableIndex]
                          .currentTitle,
                      style: const TextStyle(
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      width: availableWidth * 0.03,
                    ),
                    Visibility(
                      visible: sortedTimeTable[sortedTimeTableIndex]
                          .classTimetable[timeTableIndex]
                          .isPrimaryClassTimetable,
                      child: Text(
                        '기본',
                        style: TextStyle(
                            color: Theme.of(pageContext).focusColor,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  userBloc.updateSelectedClassTimetable(
                    sortedTimeTable[sortedTimeTableIndex]
                        .classTimetable[timeTableIndex],
                  );
                  Navigator.pop(pageContext);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
