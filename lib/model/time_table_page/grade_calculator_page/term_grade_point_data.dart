// TermGradePointData: 학기별 성적 점수 데이터를 나타내는 클래스
class TermGradePointData {
  final String? term;  // 학기
  final double? allGPA;  // 전체 평균 성적
  final double? majorGPA;  // 전공 평균 성적

  TermGradePointData({
    required this.term,
    required this.majorGPA,
    required this.allGPA,
  });
}
