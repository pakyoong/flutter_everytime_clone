// TimeTableManagementBloc.dart

import '../model/Enums.dart';
import '../model/TimeTableDataModels.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

// 성적 관리 블록
class GradeManagementBloc {
  final _selectedTerm = BehaviorSubject<int>.seeded(0);
  final _showingGradeSelector = BehaviorSubject<bool>.seeded(false);
  final _selectingGradeIndex = BehaviorSubject<int?>.seeded(null);
  final _updateDelay = BehaviorSubject<bool>();

  Stream<int> get selectedTerm => _selectedTerm.stream;
  void updateSelectedTerm(int term) => _selectedTerm.sink.add(term);

  Stream<bool> get showingGradeSelector => _showingGradeSelector.stream;
  void updateShowingGradeSelector(bool isShowing) => _showingGradeSelector.sink.add(isShowing);

  Stream<int?> get selectingGradeIndex => _selectingGradeIndex.stream;
  void updateSelectingGradeIndex(int? index) => _selectingGradeIndex.sink.add(index);

  Stream<bool> get updateDelay => _updateDelay.stream;
  void setUpdateDelay(bool delay) => _updateDelay.sink.add(delay);

  void dispose() {
    _selectedTerm.close();
    _showingGradeSelector.close();
    _selectingGradeIndex.close();
    _updateDelay.close();
  }
}

// 직접 추가 블록
class DirectAdditionBloc {
  final _scheduleTimes = BehaviorSubject<List<ClassTimeAndLocation>>.seeded([]);

  Stream<List<ClassTimeAndLocation>> get scheduleTimes => _scheduleTimes.stream;
  void updateScheduleTimes(List<ClassTimeAndLocation> times) => _scheduleTimes.sink.add(times);
  List<ClassTimeAndLocation> get currentScheduleTimes => _scheduleTimes.value;

  void resetScheduleTimes() {
    updateScheduleTimes([]);
  }

  void updateScheduleTime(
      int index, {
        String? location,
        int? startHour,
        int? startMinute,
        int? endHour,
        int? endMinute,
        Weekday? weekday,
      }) {
    var temp = List<ClassTimeAndLocation>.from(_scheduleTimes.value);
    if (location != null) temp[index].location = location;
    if (startHour != null) temp[index].startHour = startHour;
    if (startMinute != null) temp[index].startMinute = startMinute;
    if (endHour != null) temp[index].endHour = endHour;
    if (endMinute != null) temp[index].endMinute = endMinute;
    if (weekday != null) temp[index].weekday = weekday;

    updateScheduleTimes(temp);
  }

  void addScheduleTime(ClassTimeAndLocation timeAndLocation) {
    var temp = List<ClassTimeAndLocation>.from(_scheduleTimes.value);
    temp.add(timeAndLocation);
    updateScheduleTimes(temp);
  }

  void removeScheduleTime(int index) {
    var temp = List<ClassTimeAndLocation>.from(_scheduleTimes.value);
    temp.removeAt(index);
    updateScheduleTimes(temp);
  }

  void dispose() {
    _scheduleTimes.close();
  }
}

// 시간표 목록 관리 블록
class TimeTableListManagerBloc {
  final _sortedSchedules = BehaviorSubject<List<TermSchedule>>.seeded([]);

  Stream<List<TermSchedule>> get sortedSchedules => _sortedSchedules.stream;
  void updateSortedSchedules(List<TermSchedule> schedules) => _sortedSchedules.sink.add(schedules);

  void sortSchedules(List<Schedule> scheduleList) {
    var tempSortedSchedules = List<TermSchedule>.from(_sortedSchedules.value);

    for (var schedule in scheduleList) {
      var found = tempSortedSchedules.firstWhere(
            (s) => s.termName == schedule.term,
        orElse: () => TermSchedule(termName: schedule.term),
      );

      if (found != null) {
        found.schedules.add(schedule);
      } else {
        tempSortedSchedules.add(
          TermSchedule(termName: schedule.term)..schedules.add(schedule),
        );
      }
    }

    updateSortedSchedules(tempSortedSchedules);
  }

  final _termPickerList = BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>> get termPickerList => _termPickerList.stream;
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

  final _selectedTermIndex = BehaviorSubject<int>.seeded(0);

  Stream<int> get selectedTermIndex => _selectedTermIndex.stream;
  void updateSelectedTermIndex(int index) => _selectedTermIndex.sink.add(index);

  void dispose() {
    _sortedSchedules.close();
    _termPickerList.close();
    _selectedTermIndex.close();
  }
}
