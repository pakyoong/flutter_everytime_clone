import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/model/time_table_enums.dart';

class ClassInfo {
  String className; // 강의 이름
  int classCredits; // 학점 수
  Grade classGrade; // 성적
  bool isPassFail; // 패스/논패스 여부
  bool isMajorClass; // 전공 수업 여부

  ClassInfo({
    required this.className,
    required this.classCredits,
    required this.classGrade,
    required this.isPassFail,
    required this.isMajorClass,
  });

  // Firestore에 데이터를 저장하기 위한 Map 변환
  Map<String, dynamic> toFirestore() {
    if (!isValid()) {
      throw Exception('Invalid ClassInfo data');
    }

    return {
      'className': className,
      'classCredits': classCredits,
      'classGrade': classGrade.toFirestore(), // Enum을 문자열로 변환
      'isPassFail': isPassFail,
      'isMajorClass': isMajorClass,
    };
  }

  // Firestore에서 읽어온 데이터를 객체로 변환
  static ClassInfo fromFirestore(QueryDocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>; // Object를 Map<String, dynamic>으로 변환

    return ClassInfo(
      className: data['className'] ?? '',
      classCredits: data['classCredits'] ?? 0,
      classGrade: Grade.fromString(data['classGrade'] ?? Grade.undefined.toString()),
      isPassFail: data['isPassFail'] ?? false,
      isMajorClass: data['isMajorClass'] ?? false,
    );
  }


  // 데이터 유효성 검증
  bool isValid() {
    return className.isNotEmpty && classCredits > 0;
  }
}
