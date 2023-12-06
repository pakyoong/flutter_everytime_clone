import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:rxdart/subjects.dart';

class TimeTable {
  String id; // Firestore 문서 ID
  final _title = BehaviorSubject<String>(); // 시간표 제목
  String term; // 학기
  final _timeTableData = BehaviorSubject<List<TimeTableData>>.seeded([]); // 시간표 데이터
  final _isPrimary = BehaviorSubject<bool>.seeded(false); // 주 시간표 여부

  TimeTable({
    required this.id,
    required String title,
    required this.term,
    List<TimeTableData> timeTableData = const [],
    bool isPrimary = false,
  }) {
    _title.add(title);
    _timeTableData.add(timeTableData);
    _isPrimary.add(isPrimary);
  }

  // Firestore 문서로부터 TimeTable 객체를 생성하는 정적 메서드
  static Future<TimeTable> fromFirestore(DocumentSnapshot doc) async {
    var data = doc.data() as Map<String, dynamic>;
    return TimeTable(
      id: doc.id,
      title: data['title'],
      term: data['term'],
      timeTableData: (data['timeTableData'] as List)
          .map((data) => TimeTableData.fromFirestore(data as Map<String, dynamic>))
          .toList(),
      isPrimary: data['isPrimary'],
    );
  }

  // Firestore에 객체 저장
  Future<void> saveToFirestore() async {
    if (!isValid()) {
      throw Exception('Invalid TimeTable data');
    }
    try {
      await FirebaseFirestore.instance.collection('timetables').doc(id).set(toFirestore());
    } catch (e) {
      print('Error saving to Firestore: $e');
      // 사용자에게 오류 피드백 제공
    }
  }

  // Firestore에 새로운 객체 생성
  Future<void> createInFirestore() async {
    if (!isValid()) {
      throw Exception('Invalid TimeTable data');
    }
    try {
      id = FirebaseFirestore.instance.collection('timetables').doc().id;
      await saveToFirestore();
    } catch (e) {
      print('Error creating in Firestore: $e');
      // 사용자에게 오류 피드백 제공
    }
  }

  // Firestore 문서로 변환하는 함수
  Map<String, dynamic> toFirestore() {
    return {
      'title': _title.value,
      'term': term,
      'timeTableData': _timeTableData.value.map((data) => data.toFirestore()).toList(),
      'isPrimary': _isPrimary.value,
    };
  }

  // Firestore 문서를 업데이트하는 함수
  Future<void> updateFirestoreData() async {
    if (!isValid()) {
      throw Exception('Invalid TimeTable data');
    }
    try {
      await FirebaseFirestore.instance.collection('timetables').doc(id).update(toFirestore());
    } catch (e) {
      print('Error updating Firestore: $e');
      // 사용자에게 오류 피드백 제공
    }
  }

  // 데이터 유효성 검증
  bool isValid() {
    return _title.value.isNotEmpty && term.isNotEmpty;
  }

  // 클래스를 추가하고 Firestore 문서 업데이트
  void addClass(TimeTableData data) {
    var tempList = List<TimeTableData>.from(_timeTableData.value);
    tempList.add(data);
    _timeTableData.add(tempList);
    updateFirestoreData();
  }

  // 클래스를 제거하고 Firestore 문서 업데이트
  void removeClass(int index) {
    var tempList = List<TimeTableData>.from(_timeTableData.value);
    if (index >= 0 && index < tempList.length) {
      tempList.removeAt(index);
      _timeTableData.add(tempList);
      updateFirestoreData();
    }
  }

  // 제목 업데이트
  void updateTitle(String newTitle) {
    _title.add(newTitle);
    updateFirestoreData();
  }

  // isPrimary 상태 업데이트
  void updateIsPrimary(bool newIsPrimary) {
    _isPrimary.add(newIsPrimary);
    updateFirestoreData();
  }

  // 스트림과 getter
  Stream<String> get titleStream => _title.stream;
  String get currentTitle => _title.value;

  Stream<List<TimeTableData>> get timeTableDataStream => _timeTableData.stream;
  List<TimeTableData> get currentTimeTableData => _timeTableData.value;

  Stream<bool> get isPrimaryStream => _isPrimary.stream;
  bool get currentIsPrimary => _isPrimary.value;

  // timeTableData getter 추가
  List<TimeTableData> get timeTableData => _timeTableData.value;

  // 리소스 해제 함수
  void dispose() {
    _title.close();
    _timeTableData.close();
    _isPrimary.close();
  }
}
