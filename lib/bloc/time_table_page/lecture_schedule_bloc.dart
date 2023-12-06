import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/model/time_table_enums.dart';
import 'package:everytime/model/time_table_page/lecture_time_and_location.dart';
import 'package:rxdart/subjects.dart';

class LectureScheduleBloc {
  final _lectureScheduleList = BehaviorSubject<List<LectureTimeAndLocation>>.seeded([]);
  final String collectionPath; // Firestore 컬렉션 경로

  LectureScheduleBloc(this.collectionPath) {
    _loadLectureSchedule();
  }

  Stream<List<LectureTimeAndLocation>> get lectureSchedule => _lectureScheduleList.stream;

  List<LectureTimeAndLocation> get currentLectureScheduleData => _lectureScheduleList.value;

  void _loadLectureSchedule() async {
    // Firestore에서 강의 시간 및 장소 데이터를 불러옵니다.
    var collection = FirebaseFirestore.instance.collection(collectionPath);
    var snapshot = await collection.get();
    var lectureSchedule = snapshot.docs
        .map((doc) => LectureTimeAndLocation.fromFirestore(doc.data()))
        .toList();
    _lectureScheduleList.sink.add(lectureSchedule);
  }

  void addLectureScheduleEntry(LectureTimeAndLocation lecture) {
    var newSchedule = List<LectureTimeAndLocation>.from(_lectureScheduleList.value)..add(lecture);
    _updateLectureScheduleList(newSchedule);
    _saveLectureSchedule();
  }

  void updateLectureScheduleEntry(int index, LectureTimeAndLocation updatedLecture) {
    var updatedSchedule = List<LectureTimeAndLocation>.from(_lectureScheduleList.value);
    updatedSchedule[index] = updatedLecture;
    _updateLectureScheduleList(updatedSchedule);
    _saveLectureSchedule();
  }

  void removeLectureScheduleEntry(int index) {
    var updatedSchedule = List<LectureTimeAndLocation>.from(_lectureScheduleList.value)..removeAt(index);
    _updateLectureScheduleList(updatedSchedule);
    _saveLectureSchedule();
  }

  void _updateLectureScheduleList(List<LectureTimeAndLocation> schedule) {
    _lectureScheduleList.sink.add(schedule);
  }

  void _saveLectureSchedule() async {
    // 강의 시간 및 장소 데이터를 Firestore에 저장합니다.
    var collection = FirebaseFirestore.instance.collection(collectionPath);
    for (var lecture in _lectureScheduleList.value) {
      var docRef = collection.doc(); // 새 문서 ID를 생성합니다.
      await docRef.set(lecture.toFirestore());
    }
  }

  void resetLectureSchedule() {
    // 강의 시간 및 장소 데이터를 초기화합니다.
    _updateLectureScheduleList([]);
    _saveLectureSchedule();
  }

  void dispose() {
    _lectureScheduleList.close();
  }
}
