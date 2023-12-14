import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:rxdart/subjects.dart';

class TimeTable {
  // 시간표 이름
  final _title = BehaviorSubject<String>.seeded('시간표');

  // 학기 정보 (예: "2023 1학기")
  final String term;

  // 시간표 데이터
  final _timeTableData = BehaviorSubject<List<TimeTableData>>.seeded([]);
  
  // 이 시간표가 주 시간표인지 여부
  final _isPrimary = BehaviorSubject<bool>.seeded(false);

  TimeTable({
    required this.term,
  });

  Stream<String> get titleStream => _title.stream;
  Function(String) get updateTitle => _title.sink.add;
  String get currentTitle => _title.value;

  Stream<List<TimeTableData>> get timeTableData => _timeTableData.stream;
  void _updateTimeTableData(List<TimeTableData> newData) =>
      _timeTableData.sink.add(newData);
  List<TimeTableData> get currentTimeTableData => _timeTableData.value;

  Stream<bool> get isPrimary => _isPrimary.stream;
   Function(bool) get updateIsPrimary => _isPrimary.sink.add;
  bool get currentIsPrimary => _isPrimary.value;


  // 강의 제거
  void removeClass(int index) {
    List<TimeTableData> tempList = currentTimeTableData;
    currentTimeTableData.removeAt(index);

    _updateTimeTableData(tempList);
  }

  // 강의 추가
  void addClass(TimeTableData data) {
    List<TimeTableData> tempList = currentTimeTableData;
    currentTimeTableData.add(data);

    _updateTimeTableData(tempList);
  }

  dispose() {
    _title.close();
    _timeTableData.close();
    _isPrimary.close();
  }
}
