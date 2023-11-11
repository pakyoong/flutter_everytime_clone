import './Enums.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class Schedule {
  final _title = BehaviorSubject<String>.seeded('시간표');
  final String term;
  final _scheduleData = BehaviorSubject<List<ClassSchedule>>.seeded([]);
  final _isPrimary = BehaviorSubject<bool>.seeded(false);

  Schedule({required this.term});

  Stream<String> get titleStream => _title.stream;
  Function(String) get updateTitle => _title.sink.add;
  String get currentTitle => _title.value;

  Stream<List<ClassSchedule>> get scheduleData => _scheduleData.stream;
  List<ClassSchedule> get currentScheduleData => _scheduleData.value;
  void updateScheduleData(List<ClassSchedule> newData) => _scheduleData.sink.add(newData);

  Stream<bool> get isPrimary => _isPrimary.stream;
  Function(bool) get updateIsPrimary => _isPrimary.sink.add;
  bool get isPrimarySchedule => _isPrimary.value;

  void removeClass(int index) {
    var tempList = List<ClassSchedule>.from(currentScheduleData);
    tempList.removeAt(index);
    updateScheduleData(tempList);
  }

  void addClass(ClassSchedule classSchedule) {
    var tempList = List<ClassSchedule>.from(currentScheduleData);
    tempList.add(classSchedule);
    updateScheduleData(tempList);
  }

  void dispose() {
    _title.close();
    _scheduleData.close();
    _isPrimary.close();
  }
}

class ClassTimeAndLocation {
  Weekday weekday;
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  String location;

  ClassTimeAndLocation({
    this.weekday = Weekday.Monday,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 10,
    this.endMinute = 0,
    this.location = '',
  });
}

class ClassSchedule {
  String university;
  String professor;
  List<ClassTimeAndLocation> times;
  String? major;
  List<int>? yearGroups;
  String className;
  SubjectType classType;
  String classCode;

  ClassSchedule({
    this.university = '금오공대',
    this.professor = '',
    required this.times,
    this.major,
    this.yearGroups,
    this.className = '',
    this.classType = SubjectType.LiberalArtsSelect,
    this.classCode = '000000-000',
  });
}

class TermSchedule {
  String termName;
  List<Schedule> schedules = [];

  TermSchedule({required this.termName});
}

class GradeDistributionData {
  int? percentage;
  String gradeLabel;

  GradeDistributionData({required this.percentage, required this.gradeLabel});
}

class TermGradePointData {
  String? term;
  double? overallGPA;
  double? majorGPA;

  TermGradePointData({required this.term, required this.overallGPA, required this.majorGPA});
}

class CourseInfo {
  String courseName = '';
  int courseCredits = 0;
  Grade courseGrade = Grade.AP;
  bool isPassFail = false;
  bool isMajorCourse = false;
}

class SortedTimeTable {
  final String termString;

  final List<Schedule> timeTables = [];

  SortedTimeTable({
    required this.termString,
  });
}