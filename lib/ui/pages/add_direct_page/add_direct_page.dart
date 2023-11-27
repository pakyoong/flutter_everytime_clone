import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'appbar_at_add_direct_page.dart';
import 'data_input_at_add_direct_page.dart';
import 'time_table_chart_at_add_direct_page.dart';
import 'package:flutter/material.dart';

class AddDirectPage extends StatefulWidget {
  const AddDirectPage({
    Key? key,
    required this.userBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;

  @override
  State<AddDirectPage> createState() => _AddDirectPageState();
}

class _AddDirectPageState extends State<AddDirectPage> {
  final _subjectNameController = TextEditingController();
  final _profNameController = TextEditingController();
  final _timeTableScrollController = ScrollController();

  late final int _lastDayOfWeekIndex;
  late final int _lastStartHour;
  late final int _lastEndHour;

  final _addDirectBloc = DirectAdditionBloc();

  @override
  void initState() {
    super.initState();

    _lastDayOfWeekIndex = widget.userBloc.currentDayOfWeek.length - 1;
    _lastStartHour = widget.userBloc.currentTimeList[0];
    _lastEndHour = widget.userBloc.currentTimeList.last;
  }

  @override
  dispose() {
    super.dispose();

    _subjectNameController.dispose();
    _profNameController.dispose();
    _timeTableScrollController.dispose();

    _addDirectBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () {
            if (widget.userBloc.currentIsShowingKeyboard) {
              widget.userBloc.updateIsShowingKeyboard(false);
            }
            if (primaryFocus?.hasFocus ?? false) {
              primaryFocus?.unfocus();
            }
          },
          child: Column(
            children: [
              AppBarAtAddDirectPage(
                userBloc: widget.userBloc,
                addDirectBloc: _addDirectBloc,
                subjectNameController: _subjectNameController,
                profNameController: _profNameController,
                lastDayOfWeekIndex: _lastDayOfWeekIndex,
                lastStartHour: _lastStartHour,
                lastEndHour: _lastEndHour,
              ),
              TimeTableChartAtAddDirectPage(
                userBloc: widget.userBloc,
                addDirectBloc: _addDirectBloc,
                timeTableScrollController: _timeTableScrollController,
              ),
              DataInputAtAddDirectPage(
                userBloc: widget.userBloc,
                addDirectBloc: _addDirectBloc,
                subjectNameController: _subjectNameController,
                profNameController: _profNameController,
                timeTableScrollController: _timeTableScrollController,
                lastDayOfWeekIndex: _lastDayOfWeekIndex,
                lastStartHour: _lastStartHour,
                lastEndHour: _lastEndHour,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
