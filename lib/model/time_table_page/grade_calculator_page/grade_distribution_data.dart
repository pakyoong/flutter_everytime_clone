class GradeDistributionData {
  int? percentage; // 성적 분포의 백분율 (null 가능)
  String gradeLabel; // 성적 레이블

  GradeDistributionData({
    this.percentage,
    required this.gradeLabel,
  });

  // Firestore에 데이터를 저장하기 위한 Map 변환
  Map<String, dynamic> toFirestore() {
    if (!isValid()) {
      throw Exception('Invalid GradeDistributionData data');
    }

    return {
      'percentage': percentage,
      'gradeLabel': gradeLabel,
    };
  }

  // Firestore에서 읽어온 데이터를 객체로 변환
  static GradeDistributionData fromFirestore(Map<String, dynamic> firestoreData) {
    if (firestoreData.isEmpty) {
      throw Exception('Invalid Firestore data');
    }

    return GradeDistributionData(
      percentage: firestoreData['percentage'],
      gradeLabel: firestoreData['gradeLabel'] ?? '',
    );
  }

  // 데이터 유효성 검증
  bool isValid() {
    return gradeLabel.isNotEmpty;
  }
}
