import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:rxdart/subjects.dart';

// 강의 시간과 위치를 관리하는 클래스입니다.
class AddDirectBloc {
  // 강의 시간 및 장소 데이터를 관리하는 리스트입니다.
  final _timeNPlaceDataList = BehaviorSubject<List<TimeNPlaceData>>.seeded([]);

  // 현재 저장된 강의 시간 및 장소 데이터를 스트림 형태로 제공합니다.
  Stream<List<TimeNPlaceData>> get timeNPlaceData => _timeNPlaceDataList.stream;

  // 새로운 강의 시간 및 장소 데이터를 추가하는 함수입니다.
  Function(List<TimeNPlaceData>) get _updateTimeNPlaceData =>
      _timeNPlaceDataList.sink.add;

  // 현재 저장된 강의 시간 및 장소 데이터를 리스트 형태로 반환합니다.
  List<TimeNPlaceData> get currentTimeNPlaceData => _timeNPlaceDataList.value;

  // 저장된 모든 강의 시간 및 장소 데이터를 초기화하는 함수입니다.
  void resetTimeNPlaceData() {
    _updateTimeNPlaceData([]);
  }

  // 지정된 인덱스의 강의 시간 및 장소 데이터를 업데이트하는 함수입니다.
  void updateTimeNPlaceData(
      int index, {
        String? place,
        int? startHour,
        int? startMinute,
        int? endHour,
        int? endMinute,
        DayOfWeek? dayOfWeek,
      }) {
    if (place != null ||
        startHour != null ||
        startMinute != null ||
        endHour != null ||
        endMinute != null ||
        dayOfWeek != null) {
      List<TimeNPlaceData> temp = _timeNPlaceDataList.value;
      if (place != null) temp[index].place = place;
      if (startHour != null) temp[index].startHour = startHour;
      if (startMinute != null) temp[index].startMinute = startMinute;
      if (endHour != null) temp[index].endHour = endHour;
      if (endMinute != null) temp[index].endMinute = endMinute;
      if (dayOfWeek != null) temp[index].dayOfWeek = dayOfWeek;

      _updateTimeNPlaceData(temp);
    }
  }

  // 지정된 인덱스의 강의 시간 및 장소 데이터를 삭제하는 함수입니다.
  void removeTimeNPlaceData(int index) {
    List<TimeNPlaceData> temp = currentTimeNPlaceData;
    temp.removeAt(index);
    _updateTimeNPlaceData(temp);
  }

  // 새로운 강의 시간 및 장소 데이터를 리스트에 추가하는 함수입니다.
  void addTimeNPlaceData({
    String? place,
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    DayOfWeek? dayOfWeek,
  }) {
    _updateTimeNPlaceData([
      ...currentTimeNPlaceData,
      TimeNPlaceData(),
    ]);
  }

  // 모든 리소스를 정리하는 함수입니다.
  void dispose() {
    _timeNPlaceDataList.close();
  }
}
