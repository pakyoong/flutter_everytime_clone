// ignore_for_file: constant_identifier_names

import './academic_enums.dart';
import './time_table_data_models.dart';
import 'package:rxdart/subjects.dart';

class TermGrades {
  // TermGrades 생성자, 학기명을 필수로 받음
  TermGrades({
    required this.termName, // 학기명
  });

  final String termName;

  // BehaviorSubject 인스턴스들을 사용하여 학점 관련 데이터를 관리
  // 각 BehaviorSubject는 초기값으로 시작되며, 데이터의 변화를 스트림으로 제공
  final _totalGradePoints = BehaviorSubject<double>.seeded(0.0); // 총 학점 점수
  final _totalCredits = BehaviorSubject<int>.seeded(0); // 총 학점 수
  final _majorGradePoints = BehaviorSubject<double>.seeded(0.0); // 전공 학점 점수
  final _majorCredits = BehaviorSubject<int>.seeded(0); // 전공 학점 수
  final _passFailCredits = BehaviorSubject<int>.seeded(0); // P/NP 과목 학점 수
  final _averageGradePoint = BehaviorSubject<double>.seeded(0.0); // 평균 학점 점수
  final _averageMajorGradePoint = BehaviorSubject<double>.seeded(0.0); // 전공 평균 학점 점수
  final _totalEarnedCredits = BehaviorSubject<int>.seeded(0); // 취득 학점 수

  // 성적별 학점 수를 관리하는 BehaviorSubject 리스트
  // Grade 열거형의 모든 항목에 대해 초기값이 0인 BehaviorSubject를 생성
  final List<BehaviorSubject<int>> _gradeCounts = List.generate(
      Grade.allGrades().length, (index) => BehaviorSubject.seeded(0));

  // 각 BehaviorSubject의 스트림에 접근하는 getter 메서드들
  // 이를 통해 외부에서 스트림 데이터에 접근 가능
  Stream<double> get totalGrade => _totalGradePoints.stream;
  Stream<int> get totalCredit => _totalCredits.stream;
  Stream<double> get majorGrade => _majorGradePoints.stream;
  Stream<int> get majorCredit => _majorCredits.stream;
  Stream<int> get pCredit => _passFailCredits.stream;

  // BehaviorSubject의 값을 업데이트하기 위한 private 함수들
  Function(double) get _updateTotalGrade => _totalGradePoints.sink.add;
  Function(int) get _updateTotalCredit => _totalCredits.sink.add;
  Function(double) get _updateMajorGrade => _majorGradePoints.sink.add;
  Function(int) get _updateMajorCredit => _majorCredits.sink.add;
  Function(int) get _updatePCredit => _passFailCredits.sink.add;

  // 평균 학점 계산과 관련된 getter 메서드와 함수들
  Stream<double> get totalGradeAve => _averageGradePoint.stream;
  double get currentTotalGradeAve => _averageGradePoint.value;
  Stream<double> get majorGradeAve => _averageMajorGradePoint.stream;
  double get currentMajorGradeAve => _averageMajorGradePoint.value;
  Stream<int> get creditAmount => _totalEarnedCredits.stream;

  // 성적별 학점 수 관련 메서드들
  Stream<int> gradeAmountsElementAt(int index) => _gradeCounts[index].stream;
  void _updateGradeAmountsElementAt(int index, int newValue) =>
      _gradeCounts[index].sink.add(newValue);
  int currentGradeAmountsElementAt(int index) => _gradeCounts[index].value;

  // 현재 상태를 반환하는 getter 메서드들
  double get currentTotalGrade => _totalGradePoints.value;
  int get currentTotalCredit => _totalCredits.value;
  double get currentMajorGrade => _majorGradePoints.value;
  int get currentMajorCredit => _majorCredits.value;
  int get currentPCredit => _passFailCredits.value;

  // 평균 학점 계산을 위한 private 함수들
  void _updateTotalGradeAve(double newTotalGrade, int newTotalCredit) =>
      _averageGradePoint.sink.add(double.parse(
          (newTotalGrade / ((newTotalCredit == 0) ? 1 : newTotalCredit)).toStringAsFixed(2)));

  void _updateMajorGradeAve(double newMajorGrade, int newMajorCredit) =>
      _averageMajorGradePoint.sink.add(double.parse(
          (newMajorGrade / ((newMajorCredit == 0) ? 1 : newMajorCredit)).toStringAsFixed(2)));

  void _updateCreditAmount(int newTotalCredit, int newPCredit) =>
      _totalEarnedCredits.sink.add(newTotalCredit + newPCredit);

  // 과목 정보를 저장하는 BehaviorSubject
  static const DEFAULT_SUBJECTS_LENGTH = 10;
  final _subjects = BehaviorSubject<List<CourseInfo>>.seeded([
    // 초기값 설정
    for (var i = 0; i < DEFAULT_SUBJECTS_LENGTH; i++) CourseInfo(),
  ]);

  // 임시로 각 성적의 총합을 저장할 공간
  final Map<Grade, int> _tempGrades = { for (var element in Grade.allGrades()) element : 0 };

  // 과목 정보 관련 스트림과 메서드들
  Stream<List<CourseInfo>> get subjects => _subjects.stream;
  List<CourseInfo> get currentSubjects => _subjects.value;
  void _updateSubjects(List<CourseInfo> newSubjects) => _subjects.sink.add(newSubjects);
  void updateSubjects() => _updateSubjects(currentSubjects);


  // 추가적인 과목을 생성하거나 제거하는 함수들
  void addSubject() {
    List<CourseInfo> tempList = currentSubjects;
    tempList.add(CourseInfo());
    _updateSubjects(tempList);
  }

  void removeEmptySubjects() {
    if (currentSubjects.length == DEFAULT_SUBJECTS_LENGTH) return;

    CourseInfo targetSubject;
    List<int> removeIndexes = [];
    List<CourseInfo> tempList = currentSubjects;

    for (int i = 0; i < (tempList.length - DEFAULT_SUBJECTS_LENGTH); i++) {
      targetSubject = tempList[DEFAULT_SUBJECTS_LENGTH + i];
      if (targetSubject.isMajorCourse == false &&
          targetSubject.courseCredits == 0 &&
          targetSubject.courseName.isEmpty &&
          targetSubject.courseGrade == Grade.aPlus) {
        removeIndexes.add(DEFAULT_SUBJECTS_LENGTH + i);
      }
    }

    for (int i = removeIndexes.length - 1; i >= 0; i--) {
      if (i < 0) continue;
      tempList.removeAt(removeIndexes[i]);
    }
    _updateSubjects(tempList);
  }

  void removeAdditionalSubjects() {
    if (currentSubjects.length == DEFAULT_SUBJECTS_LENGTH) return;
    List<CourseInfo> tempList = currentSubjects;
    for (int i = tempList.length - DEFAULT_SUBJECTS_LENGTH - 1; i >= 0; i--) {
      tempList.removeLast();
    }
    _updateSubjects(tempList);
  }

  // 현재 학기의 성적을 최신 값으로 갱신하는 함수
  void updateGrades() {
    double tempTotalGrade = 0.0;
    int tempTotalCredit = 0;
    double tempMajorGrade = 0.0;
    int tempMajorCredit = 0;
    int tempPCredit = 0;
    _tempGrades.forEach((key, value) => _tempGrades[key] = 0);

    int courseCredits = 0;
    Grade courseGrade = Grade.F;
    bool isMajorCourse = false;
    bool isPassFail = false;

    for (int i = 0; i < currentSubjects.length; i++) {
      courseCredits = currentSubjects[i].courseCredits;
      courseGrade = currentSubjects[i].courseGrade;
      isMajorCourse = currentSubjects[i].isMajorCourse;
      isPassFail = currentSubjects[i].isPassFail;

      if (courseCredits != 0) {
        if (courseGrade.point > 0) {
          tempTotalGrade += courseGrade.point * courseCredits;
          tempTotalCredit += courseCredits;

          if (isMajorCourse) {
            tempMajorGrade += courseGrade.point * courseCredits;
            tempMajorCredit += courseCredits;
          }
        } else if (courseGrade == Grade.P && isPassFail) {
          tempPCredit += courseCredits;
        }

        _tempGrades.update(courseGrade, (value) => value += courseCredits);
      }
    }

    _tempGrades.forEach(
      (key, value) =>
          _updateGradeAmountsElementAt(Grade.indexOfGrade(key), value),
    );

    _updateTotalGrade(tempTotalGrade);
    _updateTotalCredit(tempTotalCredit);
    _updateMajorGrade(tempMajorGrade);
    _updateMajorCredit(tempMajorCredit);
    _updatePCredit(tempPCredit);

    _updateTotalGradeAve(tempTotalGrade, tempTotalCredit);
    _updateMajorGradeAve(tempMajorGrade, tempMajorCredit);
    _updateCreditAmount(tempTotalCredit, tempPCredit);
  }

  // 특정 과목을 갱신하는 함수
  void updateSubject(
    int index, {
    String? courseName,
    int? courseCredits,
    Grade? courseGrade,
    bool? isPassFail,
    bool? isMajorCourse,
  }) {
    if (courseName != null) currentSubjects[index].courseName = courseName;
    if (courseCredits != null) {
      currentSubjects[index].courseCredits = courseCredits;
    }
    if (courseGrade != null) currentSubjects[index].courseGrade = courseGrade;
    if (isPassFail != null) currentSubjects[index].isPassFail = isPassFail;
    if (isMajorCourse != null) {
      currentSubjects[index].isMajorCourse = isMajorCourse;
    }

    if (courseCredits != null ||
        courseGrade != null ||
        isPassFail != null ||
        isMajorCourse != null) {
      updateGrades();
    }
  }

  // 특정 과목을 초기값으로 되돌리는 함수
  // 과목의 이름, 학점, 성적 등을 초기값으로 설정하고 성적 데이터를 업데이트
  void setDefault(int index) {
    currentSubjects[index].courseName = '';
    currentSubjects[index].courseCredits = 0;
    currentSubjects[index].courseGrade = Grade.aPlus;
    currentSubjects[index].isMajorCourse = false;
    currentSubjects[index].isPassFail = false;
    updateGrades();
  }

  // 클래스에서 사용한 자원을 해제하는 메서드
  // BehaviorSubject 인스턴스들을 닫아 리소스를 정리
  void dispose() {
    _totalGradePoints.close();
    _totalCredits.close();
    _majorGradePoints.close();
    _majorCredits.close();
    _passFailCredits.close();

    _averageGradePoint.close();
    _averageMajorGradePoint.close();
    _totalEarnedCredits.close();

    for (int i = 0; i < _gradeCounts.length; i++) {
      _gradeCounts[i].close();
    }

    _subjects.close();
  }
}
