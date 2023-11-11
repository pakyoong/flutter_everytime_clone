import './Enums.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class TermGrades {
  TermGrades({required this.termName});

  final String termName;
  final _totalGradePoints = BehaviorSubject<double>.seeded(0.0);
  final _totalCredits = BehaviorSubject<int>.seeded(0);
  final _majorGradePoints = BehaviorSubject<double>.seeded(0.0);
  final _majorCredits = BehaviorSubject<int>.seeded(0);
  final _passFailCredits = BehaviorSubject<int>.seeded(0);
  final _averageGradePoint = BehaviorSubject<double>.seeded(0.0);
  final _averageMajorGradePoint = BehaviorSubject<double>.seeded(0.0);
  final _totalEarnedCredits = BehaviorSubject<int>.seeded(0);
  final _gradeCounts = List.generate(Grade.allGrades.length, (index) => BehaviorSubject<int>.seeded(0));
  final _courseInfos = BehaviorSubject<List<CourseInfo>>.seeded([]);

  Stream<double> get totalGradePoints => _totalGradePoints.stream;
  Stream<int> get totalCredits => _totalCredits.stream;
  Stream<double> get majorGradePoints => _majorGradePoints.stream;
  Stream<int> get majorCredits => _majorCredits.stream;
  Stream<int> get passFailCredits => _passFailCredits.stream;
  Stream<double> get averageGradePoint => _averageGradePoint.stream;
  Stream<double> get averageMajorGradePoint => _averageMajorGradePoint.stream;
  Stream<int> get totalEarnedCredits => _totalEarnedCredits.stream;
  Stream<List<CourseInfo>> get courseInfos => _courseInfos.stream;

  Stream<int> gradeCountAt(int index) => _gradeCounts[index].stream;
  int currentGradeCountAt(int index) => _gradeCounts[index].value;

  void addCourse(CourseInfo courseInfo) {
    final courses = List<CourseInfo>.from(_courseInfos.value);
    courses.add(courseInfo);
    _courseInfos.sink.add(courses);
    _updateGrades();
  }

  void removeCourse(int index) {
    final courses = List<CourseInfo>.from(_courseInfos.value);
    if (index >= 0 && index < courses.length) {
      courses.removeAt(index);
      _courseInfos.sink.add(courses);
      _updateGrades();
    }
  }

  void updateCourse(int index, CourseInfo newCourseInfo) {
    final courses = List<CourseInfo>.from(_courseInfos.value);
    if (index >= 0 && index < courses.length) {
      courses[index] = newCourseInfo;
      _courseInfos.sink.add(courses);
      _updateGrades();
    }
  }

  void _updateGrades() {
    double totalGradePoint = 0.0;
    int totalCredit = 0;
    double majorGradePoint = 0.0;
    int majorCredit = 0;
    int passFailCredit = 0;
    final gradeCounts = List<int>.filled(Grade.allGrades.length, 0);

    for (var course in _courseInfos.value) {
      if (course.isPassFail) {
        passFailCredit += course.courseCredits;
      } else {
        totalGradePoint += course.courseGrade.point * course.courseCredits;
        totalCredit += course.courseCredits;
        gradeCounts[Grade.allGrades.indexOf(course.courseGrade)] += course.courseCredits;
        if (course.isMajorCourse) {
          majorGradePoint += course.courseGrade.point * course.courseCredits;
          majorCredit += course.courseCredits;
        }
      }
    }

    _totalGradePoints.sink.add(totalGradePoint);
    _totalCredits.sink.add(totalCredit);
    _majorGradePoints.sink.add(majorGradePoint);
    _majorCredits.sink.add(majorCredit);
    _passFailCredits.sink.add(passFailCredit);
    _averageGradePoint.sink.add(totalCredit == 0 ? 0 : totalGradePoint / totalCredit);
    _averageMajorGradePoint.sink.add(majorCredit == 0 ? 0 : majorGradePoint / majorCredit);
    _totalEarnedCredits.sink.add(totalCredit + passFailCredit);

    for (int i = 0; i < gradeCounts.length; i++) {
      _gradeCounts[i].sink.add(gradeCounts[i]);
    }
  }

  void dispose() {
    _totalGradePoints.close();
    _totalCredits.close();
    _majorGradePoints.close();
    _majorCredits.close();
    _passFailCredits.close();
    _averageGradePoint.close();
    _averageMajorGradePoint.close();
    _totalEarnedCredits.close();
    _courseInfos.close();
    for (var subject in _gradeCounts) {
      subject.close();
    }
  }
}

class CourseInfo {
  String courseName = '';
  int courseCredits = 0;
  Grade courseGrade = Grade.AP;
  bool isPassFail = false;
  bool isMajorCourse = false;
}
