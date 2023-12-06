enum ClassType {
  selectLiberalArts, // 선택 교양
  essentialLiberalArts, // 필수 교양
  selectMajor, // 선택 전공
  essentialMajor; // 필수 전공

  // Firestore에 저장하기 위한 문자열로 변환
  String toFirestore() {
    return toString().split('.').last;
  }

  // Firestore에서 읽어온 문자열을 Enum으로 변환
  static ClassType fromFirestore(String stringValue) {
    return ClassType.values.firstWhere(
          (type) => type.toString().split('.').last == stringValue,
      orElse: () => ClassType.selectLiberalArts, // 기본값 설정
    );
  }
}

/// 요일
enum Weekday {
  monday('월'), // 월요일
  tuesday('화'), // 화요일
  wednesday('수'), // 수요일
  thursday('목'), // 목요일
  friday('금'), // 금요일
  saturday('토'), // 토요일
  sunday('일'); // 일요일

  const Weekday(this.string);

  /// 요일의 문자값
  final String string;

  /// Firestore에 저장하기 위한 문자열로 변환
  String toFirestore() {
    return string;
  }

  /// Firestore에서 읽어온 문자열을 Enum으로 변환
  static Weekday fromFirestore(String stringValue) {
    return Weekday.values.firstWhere(
          (day) => day.string == stringValue,
    );
  }

  /// 시간표에서 사용할 요일 배열
  static List<Weekday> allWeekdays() {
    return [
      Weekday.monday,
      Weekday.tuesday,
      Weekday.wednesday,
      Weekday.thursday,
      Weekday.friday,
      Weekday.saturday,
      Weekday.sunday,
    ];
  }

  /// 인덱스에 해당하는 요일을 반환하는 함수
  static Weekday weekdayAtIndex(int index) {
    return Weekday.values[index];
  }

  /// 특정 요일의 인덱스를 반환하는 함수
  static int indexOfWeekday(Weekday weekday) {
    return Weekday.values.indexOf(weekday);
  }

  /// 특정 인덱스의 요일 문자값을 반환하는 함수
  static String stringAtIndex(int index) {
    return Weekday.values[index].string;
  }
}

/// 성적을 나타내는 열거형
enum Grade {
  aPlus('A+', 4.5), // A+ 학점
  A('A0', 4.0),  // A 학점
  bPlus('B+', 3.5), // B+ 학점
  B('B0', 3.0),  // B 학점
  cPlus('C+', 2.5), // C+ 학점
  C('C0', 2.0),  // C 학점
  dPlus('D+', 1.5), // D+ 학점
  D('D0', 1.0),  // D 학점
  F('F', 0.0),   // F 학점
  P('P', 0.0),   // P 학점 (통과)
  nP('NP', 0.0), // NP 학점 (불통과)
  undefined('undefined', 0.0); // 정의되지 않은 학점

  final String label; // 성적 레이블
  final double point; // 성적 점수

  const Grade(this.label, this.point);

  // 모든 성적을 리스트로 반환하는 함수
  static List<Grade> allGrades() {
    return Grade.values.where((grade) => grade != Grade.undefined).toList();
  }

  // 문자열로부터 Grade 객체를 반환하는 함수
  static Grade fromString(String label) {
    return Grade.values.firstWhere((grade) => grade.label == label,
        orElse: () => Grade.undefined);
  }

  // Firestore에 저장하기 위한 문자열로 변환
  String toFirestore() {
    return label;
  }

  // 특정 인덱스의 성적을 반환하는 함수
  static Grade getByIndex(int index) {
    return Grade.values[index];
  }

  // 특정 성적의 인덱스를 반환하는 함수
  static int indexOfGrade(Grade grade) {
    return Grade.values.indexOf(grade);
  }

  // 특정 인덱스의 성적 레이블을 반환하는 함수
  static String gradeLabelAtIndex(int index) {
    return Grade.values[index].label;
  }
}
