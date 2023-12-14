import 'package:everytime/model/time_table_enums.dart';

// CourseInfo: 강의 정보를 담는 클래스
class ClassInfo {
  String className = '';  // 강의명
  int classsCredits = 0;  // 학점 수
  Grade classGrade = Grade.aPlus;  // 강의 등급
  bool isPassFail = false;  // Pass/Fail 여부
  bool isMajorClass = false;  // 전공 과목 여부
}
