class TermGradePointData {
  String? term; // 학기
  double? allGPA; // 전체 GPA
  double? majorGPA; // 전공 GPA

  TermGradePointData({
    this.term,
    this.allGPA,
    this.majorGPA,
  });

  // Firestore에 데이터를 저장하기 위한 Map 변환
  Map<String, dynamic> toFirestore() {
    if (!isValid()) {
      throw Exception('Invalid TermGradePointData data');
    }

    return {
      'term': term,
      'allGPA': allGPA,
      'majorGPA': majorGPA,
    };
  }

  // Firestore에서 읽어온 데이터를 객체로 변환
  static TermGradePointData fromFirestore(Map<String, dynamic> firestoreData) {
    if (firestoreData.isEmpty) {
      throw Exception('Invalid Firestore data');
    }

    return TermGradePointData(
      term: firestoreData['term'],
      allGPA: firestoreData['allGPA'],
      majorGPA: firestoreData['majorGPA'],
    );
  }

  // 데이터 유효성 검증
  bool isValid() {
    return term != null && term!.isNotEmpty && allGPA != null && majorGPA != null;
  }
}
