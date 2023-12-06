import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/model/time_table_page/time_table.dart';

class TermTimetables {
  String? id; // Firestore 문서 ID (null 가능)
  final String termName; // 학기명
  List<TimeTable> timeTables; // 시간표 목록

  TermTimetables({
    this.id,
    required this.termName,
    this.timeTables = const [],
  });

  // Firestore 문서로 변환하는 함수
  Map<String, dynamic> toFirestore() {
    if (!isValid()) {
      throw Exception('Invalid TermTimetables data');
    }

    return {
      'termName': termName,
      'timeTables': timeTables.map((table) => table.toFirestore()).toList(),
    };
  }

  // Firestore 문서로부터 TermTimetables 객체를 생성하는 정적 메서드
  static Future<TermTimetables> fromFirestore(DocumentSnapshot doc) async {
    var data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid Firestore data');
    }

    var timeTablesFutures = (data['timeTables'] as List)
        .map((data) => TimeTable.fromFirestore(data as DocumentSnapshot))
        .toList();

    // 모든 Future<TimeTable> 객체들이 완료될 때까지 기다립니다.
    var timeTables = await Future.wait(timeTablesFutures);

    return TermTimetables(
      id: doc.id,
      termName: data['termName'],
      timeTables: timeTables,
    );
  }

  // Firestore에서 문서를 생성하는 함수
  Future<void> createFirestoreData() async {
    if (id == null) {
      DocumentReference docRef = FirebaseFirestore.instance.collection('termTimetables').doc();
      id = docRef.id;
      await docRef.set(toFirestore());
    }
  }

  // Firestore 문서를 업데이트하는 함수
  Future<void> updateFirestoreData() async {
    if (id != null) {
      await FirebaseFirestore.instance
          .collection('termTimetables')
          .doc(id)
          .update(toFirestore());
    }
  }

  // 데이터 유효성 검증
  bool isValid() {
    return termName.isNotEmpty && timeTables.isNotEmpty;
  }
}
