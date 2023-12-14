import 'package:everytime/model/time_table_enums.dart';
import 'package:everytime/model/time_table_page/lecture_time_and_location.dart';
import 'package:rxdart/subjects.dart';

// 강의 시간과 위치를 관리하는 클래스입니다.
class LectureScheduleBloc {
  // 강의 시간 및 장소 데이터를 관리하는 리스트입니다.
  final _lectureScheduleList = BehaviorSubject<List<LectureTimeAndLocation>>.seeded([]);

  // 현재 저장된 강의 시간 및 장소 데이터를 스트림 형태로 제공합니다.
  Stream<List<LectureTimeAndLocation>> get lectureSchedule => _lectureScheduleList.stream;

  // 새로운 강의 시간 및 장소 데이터를 추가하는 함수입니다.
  Function(List<LectureTimeAndLocation>) get _updateLectureScheduleList =>
      _lectureScheduleList.sink.add;

  // 현재 저장된 강의 시간 및 장소 데이터를 리스트 형태로 반환합니다.
  List<LectureTimeAndLocation> get currentLectureScheduleData => _lectureScheduleList.value;

  // 저장된 모든 강의 시간 및 장소 데이터를 초기화하는 함수입니다.
  void resetLectureSchedule() {
    _updateLectureScheduleList([]);
  }

  // 지정된 인덱스의 강의 시간 및 장소 데이터를 업데이트하는 함수입니다.
  void updateLectureScheduleEntry(
      int index, {
        String? location,
        int? startHour,
        int? startMinute,
        int? endHour,
        int? endMinute,
        Weekday? dayOfWeek,
      }) {
    if (location != null ||
        startHour != null ||
        startMinute != null ||
        endHour != null ||
        endMinute != null ||
        dayOfWeek != null) {
      List<LectureTimeAndLocation> temp = _lectureScheduleList.value;
      if (location != null) temp[index].location = location;
      if (startHour != null) temp[index].startHour = startHour;
      if (startMinute != null) temp[index].startMinute = startMinute;
      if (endHour != null) temp[index].endHour = endHour;
      if (endMinute != null) temp[index].endMinute = endMinute;
      if (dayOfWeek != null) temp[index].weekday = dayOfWeek;

      _updateLectureScheduleList(temp);
    }
  }

  // 지정된 인덱스의 강의 시간 및 장소 데이터를 삭제하는 함수입니다.
  void removeLectureScheduleEntry(int index) {
    List<LectureTimeAndLocation> temp = currentLectureScheduleData;
    temp.removeAt(index);
    _updateLectureScheduleList(temp);
  }

  // 새로운 강의 시간 및 장소 데이터를 리스트에 추가하는 함수입니다.
  void addLectureScheduleEntry({
    String? location,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    Weekday? dayOfWeek,
  }) {
    _updateLectureScheduleList([
      ...currentLectureScheduleData,
      LectureTimeAndLocation(),
    ]);
  }

  // 모든 리소스를 정리하는 함수입니다.
  void dispose() {
    _lectureScheduleList.close();
  }
}
