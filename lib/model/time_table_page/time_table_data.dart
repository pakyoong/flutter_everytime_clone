import 'package:everytime/model/time_table_enums.dart';
import 'package:everytime/model/time_table_page/lecture_time_and_location.dart';

class TimeTableData {
  /// 대학
  final String university;

  /// 교수
  final String professor;

  /// 요일, 장소, 시간 리스트
  final List<LectureTimeAndLocation> times;

  /// 전공
  final String? major;

  /// 들을 수 있는 학년
  final List<int>? yearGroups;

  /// 과목 이름
  final String className;

  /// 과목 종류
  final ClassType classType;

  /// 과목 코드
  final String classCode;

  TimeTableData({
    this.university = '금오공대',
    this.professor = '',
    required this.times,
    this.major,
    this.yearGroups,
    this.className = '',
    this.classType = ClassType.selectLiberalArts,
    this.classCode = '000000-000',
  });
}
