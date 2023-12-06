import 'package:everytime/model/time_table_enums.dart';

class LectureTimeAndLocation {
  Weekday weekday; // 요일
  int startHour; // 시작 시간(시)
  int startMinute; // 시작 시간(분)
  int endHour; // 종료 시간(시)
  int endMinute; // 종료 시간(분)
  String location; // 장소

  LectureTimeAndLocation({
    this.weekday = Weekday.monday,
    this.startHour = 9,
    this.startMinute = 0,
    this.endHour = 10,
    this.endMinute = 0,
    this.location = '',
  });

  // Firestore에 저장하기 위해 Map 형태로 변환
  Map<String, dynamic> toFirestore() {
    if (!isValid()) {
      throw Exception('Invalid LectureTimeAndLocation data');
    }

    return {
      'weekday': weekday.string,
      'startHour': startHour,
      'startMinute': startMinute,
      'endHour': endHour,
      'endMinute': endMinute,
      'location': location,
    };
  }

  // Firestore에서 데이터를 읽어와 객체로 변환
  static LectureTimeAndLocation fromFirestore(Map<String, dynamic> firestoreData) {
    if (firestoreData.isEmpty) {
      throw Exception('Invalid Firestore data');
    }

    return LectureTimeAndLocation(
      weekday: Weekday.values.firstWhere(
              (w) => w.string == firestoreData['weekday'],
          orElse: () => Weekday.monday),
      startHour: firestoreData['startHour'] ?? 9,
      startMinute: firestoreData['startMinute'] ?? 0,
      endHour: firestoreData['endHour'] ?? 10,
      endMinute: firestoreData['endMinute'] ?? 0,
      location: firestoreData['location'] ?? '',
    );
  }

  // 데이터 유효성 검증
  bool isValid() {
    return startHour >= 0 && startHour < 24 &&
        endHour >= 0 && endHour < 24 &&
        startMinute >= 0 && startMinute < 60 &&
        endMinute >= 0 && endMinute < 60 &&
        location.isNotEmpty;
  }
}
