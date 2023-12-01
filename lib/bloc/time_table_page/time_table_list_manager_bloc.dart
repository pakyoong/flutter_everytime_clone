import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/model/time_table_page/time_tables_page/sorted_time_table.dart';
import 'package:rxdart/subjects.dart';

class TimeTableListManagerBloc {
  // BehaviorSubject를 사용하여 정렬된 시간표 목록을 관리하는 변수
  final _sortedTimeTables = BehaviorSubject<List<TermTimetables>>.seeded([]);

  // 정렬된 시간표 스트림을 가져오는 getter
  Stream<List<TermTimetables>> get sortedClassTimetable => _sortedTimeTables.stream;

  // 정렬된 시간표를 업데이트하는 함수
  Function(List<TermTimetables>) get updateSortedTimeTable =>
      _sortedTimeTables.sink.add;

  // 현재 정렬된 시간표 목록을 가져오는 getter
  List<TermTimetables> get currentSortedTimeTable => _sortedTimeTables.value;

  // 입력된 시간표 목록을 정렬하고 정렬된 목록을 업데이트하는 함수
  void sortTimeTables(List<TimeTable> classTimeTableList) {
    List<TermTimetables> tempSortedClassTimetable = currentSortedTimeTable;

    // 각 시간표에 대해 처리
    for (TimeTable timeTable in classTimeTableList) {
      bool result = false;
      int? index;

      // 이미 정렬된 시간표 중에서 같은 학기의 시간표가 있는지 확인
      for (int i = 0; i < tempSortedClassTimetable.length; i++) {
        if (tempSortedClassTimetable[i].termString == timeTable.term) {
          result = true;
          index = i;
          break;
        }
      }

      // 이미 존재하는 학기에 시간표 추가 또는 새로운 학기 시간표 생성
      if (result) {
        tempSortedClassTimetable[index!].timeTables.add(timeTable);
      } else {
        TermTimetables newSortedTimeTable = TermTimetables(
          termString: timeTable.term,
        );

        if (classTimeTableList.length == 1) {
          timeTable.updateIsPrimary(true);
        }

        newSortedTimeTable.timeTables.add(timeTable);
        tempSortedClassTimetable.add(newSortedTimeTable);
      }
    }

    // 학기 순으로 정렬해야 함 (미구현)

    updateSortedTimeTable(tempSortedClassTimetable);
  }

  // 학기 목록을 관리하는 BehaviorSubject 변수
  final _termList = BehaviorSubject<List<String>>.seeded([]);

  // 학기 목록 스트림을 가져오는 getter
  Stream<List<String>> get termList => _termList.stream;

  // 학기 목록을 업데이트하는 함수
  Function(List<String>) get _updateTermList => _termList.sink.add;

  // 현재 학기 목록을 가져오는 getter
  List<String> get currentTermList => _termList.value;

  // 시작 시간과 끝 시간을 기반으로 학기 목록을 생성하는 함수
  void createTermList(DateTime startDate, DateTime endDate) {
    List<String> result = [];

    // 각 년도에 대한 학기 생성
    for (int i = 0; i <= endDate.year - startDate.year; i++) {
      result.add('${endDate.year - i}년 겨울학기');
      result.add('${endDate.year - i}년 2학기');
      result.add('${endDate.year - i}년 여름학기');
      result.add('${endDate.year - i}년 1학기');
    }

    _updateTermList(result);
  }

  // 사용자가 선택한 인덱스를 관리하는 BehaviorSubject 변수
  final _pickerIndex = BehaviorSubject<int>.seeded(0);

  // 선택된 인덱스 스트림을 가져오는 getter
  Stream<int> get pickerIndex => _pickerIndex.stream;

  // 선택된 인덱스를 업데이트하는 함수
  Function(int) get updatePickerIndex => _pickerIndex.sink.add;

  // 현재 선택된 인덱스를 가져오는 getter
  int get currentPickerIndex => _pickerIndex.value;

  // Bloc의 리소스를 해제하는 함수
  dispose() {
    _sortedTimeTables.close();
    _termList.close();
    _pickerIndex.close();
  }
}
