import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import '../../component/dynamic_app_bar.dart';
import '../../component/scroll_responsive_app_bar.dart';
import '../../component/app_bar_button.dart';
import '../../screen_dimensions.dart'; // screen_dimensions.dart 파일의 경로를 확인하세요.
import '../../bloc/user_profile_management_bloc.dart';
import '../../model/time_table_data_models.dart';
import '../../model/academic_enums.dart';
import 'time_table_at_time_table_page.dart';
import 'grade_calculator_at_time_table_page.dart';
import 'add_subject_page/add_subject_page.dart';
import 'time_table_list_page/time_table_list_page.dart';
import 'package:scrolls_to_top/scrolls_to_top.dart';
import 'package:flutter/cupertino.dart';
import '../../component/custom_button_modal_bottom_sheet.dart';
import '../../component/custom_cupertino_alert_dialog.dart';


class TimeTablePage extends StatefulWidget {
  const TimeTablePage({
    Key? key,
    required this.scrollController,
    required this.userBloc,
    required this.isOnScreen,
  }) : super(key: key);

  final ScrollController scrollController;
  final EverytimeUserBloc userBloc;
  final bool isOnScreen;

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage>
    with AutomaticKeepAliveClientMixin {
  final _scrollOffset = BehaviorSubject<double>.seeded(0);
  final _timeTableNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });
  }

  @override
  void dispose() {
    super.dispose();

    widget.scrollController.removeListener(() {
      _scrollOffset.sink.add(widget.scrollController.offset);
    });

    _scrollOffset.close();
    _timeTableNameController.dispose();
  }

  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ScrollsToTop(
      onScrollsToTop: (event) async {
        if (!widget.isOnScreen) return;
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            event.to,
            duration: event.duration,
            curve: event.curve,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              StreamBuilder(
                stream: widget.userBloc.selectedClassTimetable,
                builder: (_, selectedTimeTableSnapshot) {
                  if (selectedTimeTableSnapshot.data == null) {
                    return StreamBuilder(
                      stream: widget.userBloc.termString,
                      builder: (_, termStringSnapshot) {
                        return ScrollResponsiveAppBar(
                          scrollOffsetStream: _scrollOffset.stream,
                          title: termStringSnapshot.data ?? '',
                        );
                      },
                    );
                  } else {
                    return ScrollResponsiveAppBar(
                      scrollOffsetStream: _scrollOffset.stream,
                      title: selectedTimeTableSnapshot.data!.term,
                    );
                  }
                },
              ),
              StreamBuilder(
                stream: widget.userBloc.selectedClassTimetable,
                builder: (_, selectedTimeTableSnapshot) {
                  return DynamicAppBar(
                    title: selectedTimeTableSnapshot.data == null
                        ? '시간표'
                        : selectedTimeTableSnapshot.data!.currentTitle,
                    actions: [
                      Visibility(
                        visible: selectedTimeTableSnapshot.data == null
                            ? false
                            : true,
                        child: AppBarButton(
                          icon: Icons.add_box_outlined,
                          onPressed: () => _routeAddTimeTablePage(context),
                        ),
                      ),
                      Visibility(
                        visible: selectedTimeTableSnapshot.data == null
                            ? false
                            : true,
                        child: AppBarButton(
                          icon: Icons.settings_outlined,
                          onPressed: () =>
                              _buildEditSettingBottomSheet(context),
                        ),
                      ),
                      StreamBuilder(
                        stream: widget.userBloc.classTimetableList,
                        builder: (_, timeTableListSnapshot) {
                          if (timeTableListSnapshot.hasData) {
                            return Visibility(
                              visible: timeTableListSnapshot.data!.isNotEmpty,
                              child: AppBarButton(
                                icon: Icons.format_list_bulleted_outlined,
                                onPressed: () =>
                                    _routeTimeTableListPage(context),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: CustomScrollView(
                  controller: widget.scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: TimeTableAtTimeTablePage(
                        userBloc: widget.userBloc,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: GradeCalculatorAtTimeTablePage(
                        userBloc: widget.userBloc,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _routeAddTimeTablePage(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: ((context, animation, secondaryAnimation) =>
            AddSubjectPage(
              userBloc: widget.userBloc,
            )),
        transitionsBuilder: ((context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }),
      ),
    );
  }

  _buildEditSettingBottomSheet(BuildContext context) {
    List<CustomButtonModalBottomSheetButton> buttonList = [];

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return CustomButtonModalBottomSheet(
          buttonList: _buildButtonList(bottomSheetContext),
        );
      },
    );
  }

  List<CustomButtonModalBottomSheetButton> _buildButtonList(
      BuildContext bottomSheetContext) {
    List<CustomButtonModalBottomSheetButton> buttonList = [
      CustomButtonModalBottomSheetButton(
        icon: Icons.edit_outlined,
        title: '이름 변경',
        onPressed: () {
          Navigator.pop(bottomSheetContext);
          _buildEditNameDialog(context);
        },
      ),
      CustomButtonModalBottomSheetButton(
        icon: Icons.image_outlined,
        title: '이미지로 저장',
        onPressed: () {},
      ),
      CustomButtonModalBottomSheetButton(
        icon: Icons.share_outlined,
        title: 'URL로 공유',
        onPressed: () {},
      ),
      CustomButtonModalBottomSheetButton(
        icon: Icons.chat_outlined,
        title: '카카오톡으로 공유',
        onPressed: () {},
      ),
      CustomButtonModalBottomSheetButton(
        icon: Icons.delete_outline,
        title: '삭제',
        onPressed: () {
          Navigator.pop(bottomSheetContext);
          _buildRemoveTimeTableDialog(context);
        },
      ),
    ];

    if (!widget.userBloc.currentSelectedClassTimetable!.isPrimaryClassTimetable) {
      buttonList.add(
        CustomButtonModalBottomSheetButton(
          icon: Icons.push_pin_outlined,
          title: '기본 시간표로 지정',
          onPressed: () {
            ClassTimetable currentDefaultTimeTable =
            widget.userBloc.findClassTimetableAtSpecificTerm(
              widget.userBloc.currentSelectedClassTimetable!.term,
            )!;

            currentDefaultTimeTable.updateIsPrimary(false);
            widget.userBloc.currentSelectedClassTimetable!.updateIsPrimary(true);

            Navigator.pop(bottomSheetContext);
          },
        ),
      );
    }

    return buttonList;
  }

  void _routeTimeTableListPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext pageContext) {
          return TimeTableListPage(
            userBloc: widget.userBloc,
          );
        },
      ),
    );
  }

  void _buildEditNameDialog(BuildContext context) {
    _timeTableNameController.text =
        widget.userBloc.currentSelectedClassTimetable!.currentTitle;
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '변경할 이름을 입력해주세요',
          hasTextField: true,
          textEditingController: _timeTableNameController,
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
                if (_timeTableNameController.text.isEmpty) {
                  _buildWrongNameDialog();
                } else {
                  widget.userBloc.updateTimeTableList(
                    widget.userBloc.currentSelectedClassTimetable!.term,
                    widget.userBloc.currentSelectedClassTimetable!.currentTitle,
                    newName: _timeTableNameController.text,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _buildWrongNameDialog() {
    showCupertinoDialog(
      context: context,
      builder: (alertDialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '올바른 이름이 아닙니다.',
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Text(
                '닫기',
              ),
              onPressed: () {
                Navigator.pop(alertDialogContext);
              },
            ),
          ],
        );
      },
    );
  }




  void _buildRemoveTimeTableDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CustomCupertinoAlertDialog(
          isDarkStream: widget.userBloc.isDark,
          title: '시간표를 삭제하시겠습니까?',
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
                widget.userBloc.removeTimeTableList(
                  widget.userBloc.currentSelectedClassTimetable!.term,
                  widget.userBloc.currentSelectedClassTimetable!.currentTitle,
                );

                ClassTimetable? defaultTimeTable = widget.userBloc
                    .findClassTimetableAtSpecificTerm(
                    widget.userBloc.currentTermString);

                widget.userBloc.updateSelectedClassTimetable(defaultTimeTable);
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}
