import './academic_enums.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

// ClassTimetable: 하나의 학기에 대한 시간표 정보를 관리하는 클래스
class ClassTimetable {
  final _title = BehaviorSubject<String>.seeded('시간표'); // 시간표의 제목
  final String term; // 학기 정보 (예: "2023 Spring")
  final _classTimetableData = BehaviorSubject<List<ClassTimeTable>>.seeded([]); // 강의 시간표 데이터
  final _isPrimary = BehaviorSubject<bool>.seeded(false); // 이 시간표가 주 시간표인지 여부

  ClassTimetable({required this.term}); // 생성자

  // 스트림 및 업데이트 함수
  Stream<String> get titleStream => _title.stream;
  Function(String) get updateTitle => _title.sink.add;
  String get currentTitle => _title.value;

  Stream<List<ClassTimeTable>> get classTimetableData => _classTimetableData.stream;
  List<ClassTimeTable> get currentClassTimetableData => _classTimetableData.value;
  void updateClassTimetableData(List<ClassTimeTable> newData) => _classTimetableData.sink.add(newData);

  Stream<bool> get isPrimary => _isPrimary.stream;
  Function(bool) get updateIsPrimary => _isPrimary.sink.add;
  bool get isPrimaryClassTimetable => _isPrimary.value;

  // 강의 제거 및 추가
  void removeClass(int index) {
    var tempList = List<ClassTimeTable>.from(currentClassTimetableData);
    tempList.removeAt(index);
    updateClassTimetableData(tempList);
  }

  void addClass(ClassTimeTable classTimetable) {
    var tempList = List<ClassTimeTable>.from(currentClassTimetableData);
    tempList.add(classTimetable);
    updateClassTimetableData(tempList);
  }

  void dispose() { // 자원 해제
    _title.close();
    _classTimetableData.close();
    _isPrimary.close();
  }
}

// ClassTimeAndLocation: 강의 시간과 위치 정보를 나타내는 클래스
class ClassTimeAndLocation {
  Weekday weekday; // 요일
  int startHour; // 시작 시간 (시)
  int startMinute; // 시작 시간 (분)
  int endHour; // 종료 시간 (시)
  int endMinute; // 종료 시간 (분)
  String location; // 위치

  ClassTimeAndLocation({
    this.weekday = Weekday.monday,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 10,
    this.endMinute = 0,
    this.location = '',
  });
}

// ClassTimeTable: 개별 강의에 대한 상세 시간표 정보
class ClassTimeTable {
  String university; // 대학 이름
  String professor; // 교수 이름
  List<ClassTimeAndLocation> times; // 강의 시간 및 위치 정보 리스트
  String? major; // 전공 (해당되는 경우)
  List<int>? yearGroups; // 대상 학년 (해당되는 경우)
  String className; // 강의명
  SubjectType classType; // 과목 유형 (교양, 전공 등)
  String classCode; // 강의 코드

  ClassTimeTable({
    this.university = '금오공대',
    this.professor = '',
    required this.times,
    this.major,
    this.yearGroups,
    this.className = '',
    this.classType = SubjectType.selectLiberalArts,
    this.classCode = '000000-000',
  });
}

// TermClassTimetable: 학기별 시간표 데이터를 담는 클래스
class TermClassTimetable {
  String termName; // 학기명
  List<ClassTimetable> classTimetable = []; // 시간표 목록

  TermClassTimetable({required this.termName});
}

// GradeDistributionData: 성적 분포 데이터를 나타내는 클래스
class GradeDistributionData {
  int? percentage; // 퍼센티지
  String gradeLabel; // 성적 레이블 (예: A+, B)

  GradeDistributionData({required this.percentage, required this.gradeLabel});
}

// TermGradePointData: 학기별 성적 점수 데이터를 나타내는 클래스
class TermGradePointData {
  String? term; // 학기
  double? overallGPA; // 전체 평균 성적
  double? majorGPA; // 전공 평균 성적

  TermGradePointData({required this.term, required this.overallGPA, required this.majorGPA});
}

// CourseInfo: 강의 정보를 담는 클래스
class CourseInfo {
  String courseName = ''; // 강의명
  int courseCredits = 0; // 학점 수
  Grade courseGrade = Grade.aPlus; // 강의 등급
  bool isPassFail = false; // Pass/Fail 여부
  bool isMajorCourse = false; // 전공 과목 여부
}
