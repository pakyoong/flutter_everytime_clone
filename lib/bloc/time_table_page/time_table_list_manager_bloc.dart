import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/model/time_table_page/time_tables_page/term_time_tables.dart';
import 'package:rxdart/subjects.dart';

class TimeTableListManagerBloc {
  final _sortedTimeTables = BehaviorSubject<List<TermTimetables>>.seeded([]);
  final _termList = BehaviorSubject<List<String>>.seeded([]);
  final _pickerIndex = BehaviorSubject<int>.seeded(0);

  TimeTableListManagerBloc() {
    _loadTermTimetables();
    createTermList(DateTime.now().subtract(Duration(days: 365 * 4)), DateTime.now());
  }

  Stream<List<TermTimetables>> get sortedClassTimetable => _sortedTimeTables.stream;
  Stream<List<String>> get termList => _termList.stream;
  Stream<int> get pickerIndex => _pickerIndex.stream;

  // 현재 정렬된 시간표 목록을 가져오는 getter
  List<TermTimetables> get currentSortedTimeTable => _sortedTimeTables.value;


  // Getter for the current term list
  List<String> get currentTermList => _termList.value;

  // 현재 선택된 인덱스를 가져오는 getter
  int get currentPickerIndex => _pickerIndex.value;

  void _loadTermTimetables() async {
    var collection = FirebaseFirestore.instance.collection('termTimetables');
    var snapshot = await collection.get();
    var termTimetables = await Future.wait(snapshot.docs.map((doc) async {
      return TermTimetables.fromFirestore(doc);
    }));
    _sortedTimeTables.sink.add(termTimetables);
  }
  // 정렬된 시간표를 업데이트하는 함수
  void updateSortedTimeTable(List<TermTimetables> termTimetables) {
    _sortedTimeTables.sink.add(termTimetables);
  }

  void addTimeTable(TimeTable timeTable) async {
    await timeTable.createInFirestore();
    _loadTermTimetables();
  }

  void updateTimeTable(TimeTable timeTable) async {
    await timeTable.updateFirestoreData();
    _loadTermTimetables();
  }

  void removeTimeTable(String timeTableId) async {
    await FirebaseFirestore.instance.collection('timetables').doc(timeTableId).delete();
    _loadTermTimetables();
  }


// 입력된 시간표 목록을 정렬하고 정렬된 목록을 업데이트하는 함수
  void sortTimeTables(List<TimeTable> classTimeTableList) {
    List<TermTimetables> tempSortedClassTimetable = currentSortedTimeTable;

    // 각 시간표에 대해 처리
    for (TimeTable timeTable in classTimeTableList) {
      bool result = false;
      int? index;

      // 이미 정렬된 시간표 중에서 같은 학기의 시간표가 있는지 확인
      for (int i = 0; i < tempSortedClassTimetable.length; i++) {
        if (tempSortedClassTimetable[i].termName == timeTable.term) {
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
          termName: timeTable.term,
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

  Function(List<String>) get _updateTermList => _termList.sink.add;
  Function(int) get updatePickerIndex => _pickerIndex.sink.add;

  void dispose() {
    _sortedTimeTables.close();
    _termList.close();
    _pickerIndex.close();
  }
}
