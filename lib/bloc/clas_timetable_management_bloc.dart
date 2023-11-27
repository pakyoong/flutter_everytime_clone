import '../model/academic_enums.dart';
import '../model/time_table_data_models.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

// 사용자의 성적 관련 정보와 상호작용을 관리합니다
class GradeManagementBloc {
  // BehaviorSubject를 사용하여 선택된 학기, 성적 선택기의 표시 여부, 선택된 성적 인덱스 및 업데이트 지연 여부를 관리합니다.
  final _selectedTerm = BehaviorSubject<int>.seeded(0); // 선택된 학기 인덱스 관리
  final _showingGradeSelector = BehaviorSubject<bool>.seeded(false); // 성적 선택기의 표시 여부
  final _selectingGradeIndex = BehaviorSubject<int?>.seeded(null); // 선택된 성적 인덱스 관리
  final _updateDelay = BehaviorSubject<bool>(); // 업데이트 지연 상태 관리

  // 각 상태에 대한 스트림을 제공합니다.
  Stream<int> get selectedTerm => _selectedTerm.stream;
  Stream<bool> get showingGradeSelector => _showingGradeSelector.stream;
  Stream<int?> get selectingGradeIndex => _selectingGradeIndex.stream;
  Stream<bool> get updateDelay => _updateDelay.stream;

  // 각 상태를 업데이트하는 메서드들입니다.
  void updateSelectedTerm(int term) => _selectedTerm.sink.add(term);
  void updateShowingGradeSelector(bool isShowing) => _showingGradeSelector.sink.add(isShowing);
  void updateSelectingGradeIndex(int? index) => _selectingGradeIndex.sink.add(index);
  void setUpdateDelay(bool delay) => _updateDelay.sink.add(delay);

  void dispose() {
    _selectedTerm.close();
    _showingGradeSelector.close();
    _selectingGradeIndex.close();
    _updateDelay.close();
  }
}

// 강의 시간과 위치를 직접 추가하는 기능을 관리합니다.
class DirectAdditionBloc {
  final _classTimes = BehaviorSubject<List<ClassTimeAndLocation>>.seeded([]);

  // 강의 시간과 위치에 대한 스트림을 제공합니다.
  Stream<List<ClassTimeAndLocation>> get classTimes => _classTimes.stream;
  List<ClassTimeAndLocation> get currentClassTimes => _classTimes.value;

  // 강의 시간을 추가, 업데이트, 제거하는 메서드들입니다.
  void updateClassTimes(List<ClassTimeAndLocation> times) => _classTimes.sink.add(times);
  void resetClassTimes() => updateClassTimes([]);

  // 클래스 시간 업데이트 로직
  void updateClassTime(
      int index, {
        String? location,
        int? startHour,
        int? startMinute,
        int? endHour,
        int? endMinute,
        Weekday? weekday,
      }) {
    var temp = List<ClassTimeAndLocation>.from(_classTimes.value);
    if (location != null) temp[index].location = location;
    if (startHour != null) temp[index].startHour = startHour;
    if (startMinute != null) temp[index].startMinute = startMinute;
    if (endHour != null) temp[index].endHour = endHour;
    if (endMinute != null) temp[index].endMinute = endMinute;
    if (weekday != null) temp[index].weekday = weekday;

    updateClassTimes(temp);
  }

  // 클래스 시간을 추가하거나 제거하는 메서드들
  void addClassTime({
    String? location,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    Weekday? weekday,
}) {
    updateClassTimes([
      ..._classTimes.value,
      ClassTimeAndLocation(),
    ]);
  }

  void removeClassTime(int index) {
    var temp = List<ClassTimeAndLocation>.from(_classTimes.value);
    temp.removeAt(index);
    updateClassTimes(temp);
  }

  void dispose() {
    _classTimes.close();
  }
}

// 시간표 목록을 관리합니다.
class TimeTableListManagerBloc {
  final _sortedClassTimetable = BehaviorSubject<List<TermClassTimetable>>.seeded([]);

  // 정렬된 시간표 목록에 대한 스트림을 제공합니다.
  Stream<List<TermClassTimetable>> get sortedClassTimetable => _sortedClassTimetable.stream;
  void updateSortedClassTimetable(List<TermClassTimetable> classTimetable) => _sortedClassTimetable.sink.add(classTimetable);

  // 시간표 목록을 정렬하는 메서드
  void sortClassTimetable(List<ClassTimetable> classTimetableList) {
    var tempSortedClassTimetable = List<TermClassTimetable>.from(_sortedClassTimetable.value);

    for (var classTimetable in classTimetableList) {
      var found = tempSortedClassTimetable.firstWhere(
            (s) => s.termName == classTimetable.term,
        orElse: () => TermClassTimetable(termName: classTimetable.term),
      );

      if (found.classTimetable.isEmpty) {
        tempSortedClassTimetable.add(found);
      }
      found.classTimetable.add(classTimetable);
    }

    updateSortedClassTimetable(tempSortedClassTimetable);
  }

  final _termPickerList = BehaviorSubject<List<String>>.seeded([]);
  final _selectedTermIndex = BehaviorSubject<int>.seeded(0);

  // 학기 선택기와 선택된 학기 인덱스에 대한 스트림을 제공합니다.
  Stream<int> get selectedTermIndex => _selectedTermIndex.stream;
  Stream<List<String>> get termPickerList => _termPickerList.stream;

  // 현재 학기 목록을 반환하는 getter
  List<String> get currentTermPickerList => _termPickerList.value;

  // 현재 선택된 학기 인덱스를 반환하는 getter
  int get currentSelectedTermIndex => _selectedTermIndex.value;

  // 학기 선택기 목록을 생성하고 업데이트하는 메서드들입니다.
  void updateTermPickerList(List<String> terms) => _termPickerList.sink.add(terms);
  void generateTermPickerList(DateTime startDate, DateTime endDate) {
    var termList = <String>[];

    for (int i = 0; i <= endDate.year - startDate.year; i++) {
      termList.addAll([
        '${endDate.year - i}년 겨울학기',
        '${endDate.year - i}년 2학기',
        '${endDate.year - i}년 여름학기',
        '${endDate.year - i}년 1학기',
      ]);
    }

    updateTermPickerList(termList);
  }
  void updateSelectedTermIndex(int index) => _selectedTermIndex.sink.add(index);

  void dispose() {
    _sortedClassTimetable.close();
    _termPickerList.close();
    _selectedTermIndex.close();
  }
}
