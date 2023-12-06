import 'package:everytime/model/time_table_enums.dart';
import 'package:everytime/model/time_table_page/lecture_time_and_location.dart';

class TimeTableData {
  String university;
  String professor;
  List<LectureTimeAndLocation> times;
  String? major;
  List<int>? yearGroups;
  String className;
  ClassType classType;
  String classCode;

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

  // Firestore에 저장하기 위한 Map 형태로 변환
  Map<String, dynamic> toFirestore() {
    if (!isValid()) {
      throw Exception('Invalid TimeTableData');
    }

    return {
      'university': university,
      'professor': professor,
      'times': times.map((time) => time.toFirestore()).toList(),
      'major': major,
      'yearGroups': yearGroups,
      'className': className,
      'classType': classType.toString(),
      'classCode': classCode,
    };
  }

  // Firestore에서 데이터를 읽어와 객체로 변환
  static TimeTableData fromFirestore(Map<String, dynamic> firestoreData) {
    if (firestoreData.isEmpty) {
      throw Exception('Invalid Firestore data');
    }

    // Firestore에서 저장된 times 데이터를 LectureTimeAndLocation 객체 리스트로 변환
    List<LectureTimeAndLocation> timesList = [];
    if (firestoreData['times'] != null) {
      var timesData = firestoreData['times'] as List;
      timesList = timesData.map((timeMap) {
        return LectureTimeAndLocation.fromFirestore(timeMap as Map<String, dynamic>);
      }).toList();
    }

    return TimeTableData(
      university: firestoreData['university'] ?? '금오공대',
      professor: firestoreData['professor'] ?? '',
      times: (firestoreData['times'] as List? ?? [])
          .map((time) => LectureTimeAndLocation.fromFirestore(time))
          .toList(),
      major: firestoreData['major'],
      yearGroups: List<int>.from(firestoreData['yearGroups'] ?? []),
      className: firestoreData['className'] ?? '',
      classType: ClassType.values.firstWhere(
              (e) => e.toString() == firestoreData['classType'],
          orElse: () => ClassType.selectLiberalArts),
      classCode: firestoreData['classCode'] ?? '000000-000',
    );
  }

  // 데이터 유효성 검증
  bool isValid() {
    return university.isNotEmpty &&
        className.isNotEmpty &&
        classCode.isNotEmpty &&
        times.isNotEmpty;
  }
}
