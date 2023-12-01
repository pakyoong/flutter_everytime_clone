enum ClassType {
  selectLiberalArts,    // 교양 선택
  essentialLiberalArts, // 교양 필수
  selectMajor,          // 전공 선택
  essentialMajor        // 전공 필수
}


/// 요일
enum Weekday {
  undefined('?'),
  monday('월'),
  tuesday('화'),
  wednesday('수'),
  thursday('목'),
  friday('금'),
  saturday('토'),
  sunday('일');

  const Weekday(this.string);

  /// 요일의 문자값
  final String string;

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


  // 인덱스에 해당하는 요일을 반환하는 함수
  static Weekday weekdayAtIndex(int index) {
    return allWeekdays()[index];
  }


  // 특정 요일의 인덱스를 반환하는 함수
  static int indexOfWeekday(Weekday weekday) {
    return allWeekdays().indexOf(weekday);
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

  const Grade(this.label, this.point); // 성적의 레이블과 점수를 정의하는 생성자

  final String label; // 성적의 문자열 레이블
  final double point; // 성적에 해당하는 점수

  // 특정 인덱스의 성적을 반환하는 함수
  static getByIndex(int index) {
    return Grade.allGrades()[index];
  }

  // 모든 성적을 리스트로 반환하는 함수
  static List<Grade> allGrades() {
    return [
      Grade.aPlus,
      Grade.A,
      Grade.bPlus,
      Grade.B,
      Grade.cPlus,
      Grade.C,
      Grade.dPlus,
      Grade.D,
      Grade.F,
      Grade.P,
      Grade.nP,
    ];
  }

  // 특정 성적의 인덱스를 반환하는 함수
  static int indexOfGrade(Grade grade) {
    return Grade.allGrades().indexOf(grade);
  }

  // 특정 인덱스의 성적 레이블을 반환하는 함수
  static String gradeLabelAtIndex(int index) {
    return Grade.allGrades()[index].label;
  }
}
