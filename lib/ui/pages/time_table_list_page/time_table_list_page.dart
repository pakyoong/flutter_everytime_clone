import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import './appbar_at_time_table_list_page.dart';
import './time_tables_at_time_table_list_page.dart';
import 'package:flutter/material.dart';

class TimeTableListPage extends StatefulWidget {
  const TimeTableListPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<TimeTableListPage> createState() => _TimeTableListPageState();
}

class _TimeTableListPageState extends State<TimeTableListPage> {
  final _pageScrollController = ScrollController();

  final _timeTableListBloc = TimeTableListManagerBloc();

  @override
  void initState() {
    super.initState();

    _timeTableListBloc.sortClassTimetable(widget.userBloc.currentClassTimetableList);
  }

  @override
  void dispose() {
    super.dispose();

    _pageScrollController.dispose();

    _timeTableListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarAtTimeTableListPage(
              pageContext: context,
              userBloc: widget.userBloc,
              timeTableListBloc: _timeTableListBloc,
            ),
            TimeTablesAtTimeTableListPage(
              userBloc: widget.userBloc,
              timeTableListBloc: _timeTableListBloc,
              pageScrollController: _pageScrollController,
              pageContext: context,
            ),
          ],
        ),
      ),
    );
  }
}
