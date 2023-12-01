// GradeDistributionData: 성적 분포 데이터를 나타내는 클래스
class GradeDistributionData {
  final int? percentage;  // 퍼센티지

  final String gradeLabel;  // 성적 레이블 (예: A+, B)

  GradeDistributionData({
    required this.percentage,
    required this.gradeLabel,
  });
}
