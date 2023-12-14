import 'package:everytime/model/time_table_page/time_table.dart';

class TermTimetables {
  final String termName; //학기명

  final List<TimeTable> timeTables = []; // 시간표 목록

  TermTimetables({
    required this.termName,
  });
}
