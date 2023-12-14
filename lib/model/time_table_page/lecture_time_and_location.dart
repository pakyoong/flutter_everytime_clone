import 'package:everytime/model/time_table_enums.dart';

class LectureTimeAndLocation {
  /// 요일
  Weekday weekday;

  /// 시작 시간의 시간
  int startHour;

  /// 시작 시간의 분
  int startMinute;

  /// 종료 시간의 시간
  int endHour;

  /// 종료 시간의 분
  int endMinute;

  /// 장소
  String location;

  LectureTimeAndLocation({
    this.weekday = Weekday.monday,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 10,
    this.endMinute = 0,
    this.location = '',
  });
}
