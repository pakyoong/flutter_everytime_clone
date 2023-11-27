import '../../../bloc/user_profile_management_bloc.dart';
import '../../../bloc/clas_timetable_management_bloc.dart';
import 'package:everytime/component/time_table_page/custom_text_field.dart';
import 'package:everytime/screen_dimensions.dart';
import '../add_time_table_page/appbar_at_add_time_table_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTimeTablePage extends StatefulWidget {
  const AddTimeTablePage({
    Key? key,
    required this.userBloc,
    required this.timeTableListBloc,
  }) : super(key: key);

  final EverytimeUserBloc userBloc;
  final TimeTableListManagerBloc timeTableListBloc;

  @override
  State<AddTimeTablePage> createState() => _AddTimeTablePageState();
}

class _AddTimeTablePageState extends State<AddTimeTablePage> {
  final _timeTableNameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.timeTableListBloc.generateTermPickerList(
      DateTime(2010, 3, 1),
      DateTime.now(),
    );
    widget.timeTableListBloc.updateSelectedTermIndex(0);
  }

  @override
  void dispose() {
    super.dispose();

    _timeTableNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppBarAtAddTimeTablePage(
              pageContext: context,
              userBloc: widget.userBloc,
              timeTableListBloc: widget.timeTableListBloc,
              timeTableNameController: _timeTableNameController,
            ),
            Expanded(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: availableHeight * 0.01,
                      left: availableWidth * 0.06,
                      right: availableWidth * 0.06,
                    ),
                    child: CustomTextField(
                      controller: _timeTableNameController,
                      autofocus: true,
                      isDense: true,
                      textInputAction: TextInputAction.newline,
                      maxLines: 1,
                      hintText: '시간표 이름',
                      onSubmitted: (value) {},
                      onChanged: (value) {},
                    ),
                  ),
                  Container(
                    height: 1,
                    margin: EdgeInsets.only(
                      top: availableHeight * 0.015,
                      left: availableWidth * 0.06,
                      right: availableWidth * 0.06,
                    ),
                    color: Theme.of(context).dividerColor,
                  ),
                  SizedBox(
                    height: availableHeight * 0.28,
                    child: CupertinoPicker(
                      itemExtent: availableHeight * 0.05,
                      children: _buildPickerList(),
                      onSelectedItemChanged: (index) {
                        widget.timeTableListBloc.updateSelectedTermIndex(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPickerList() {
    return [
      StreamBuilder<List<String>>(
        stream: widget.timeTableListBloc.termPickerList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // 데이터가 없을 경우 표시할 위젯
            return Text('데이터 로딩 중...');
          }

          List<String> terms = snapshot.data!;
          return Column(
            children: terms.map((term) {
              return Container(
                height: availableHeight * 0.05,
                alignment: Alignment.center,
                child: Text(
                  term,
                  style: const TextStyle(
                    fontSize: 27.5,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    ];
  }
}
