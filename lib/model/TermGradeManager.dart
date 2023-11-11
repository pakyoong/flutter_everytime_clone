import './Enums.dart';
import './TimeTableDataModels.dart';
import 'package:rxdart/subjects.dart';

class TermGrades {
  TermGrades({
    required this.termName,
  });

  final String termName;

  final _totalGradePoints = BehaviorSubject<double>.seeded(0.0);

  final _totalCredits = BehaviorSubject<int>.seeded(0);

  final _majorGradePoints = BehaviorSubject<double>.seeded(0.0);

  final _majorCredits = BehaviorSubject<int>.seeded(0);

  final _passFailCredits = BehaviorSubject<int>.seeded(0);

  final _averageGradePoint = BehaviorSubject<double>.seeded(0.0);

  final _averageMajorGradePoint = BehaviorSubject<double>.seeded(0.0);

  final _totalEarnedCredits = BehaviorSubject<int>.seeded(0);

  final List<BehaviorSubject<int>> _gradeCounts = List.generate(
      Grade.allGrades().length, (index) => BehaviorSubject.seeded(0));

  Stream<double> get totalGrade => _totalGradePoints.stream;
  Stream<int> get totalCredit => _totalCredits.stream;
  Stream<double> get majorGrade => _majorGradePoints.stream;
  Stream<int> get majorCredit => _majorCredits.stream;
  Stream<int> get pCredit => _passFailCredits.stream;

  Function(double) get _updateTotalGrade => _totalGradePoints.sink.add;
  Function(int) get _updateTotalCredit => _totalCredits.sink.add;
  Function(double) get _updateMajorGrade => _majorGradePoints.sink.add;
  Function(int) get _updateMajorCredit => _majorCredits.sink.add;
  Function(int) get _updatePCredit => _passFailCredits.sink.add;

  Stream<double> get totalGradeAve => _averageGradePoint.stream;
  double get currentTotalGradeAve => _averageGradePoint.value;
  Stream<double> get majorGradeAve => _averageMajorGradePoint.stream;
  double get currentMajorGradeAve => _averageMajorGradePoint.value;
  Stream<int> get creditAmount => _totalEarnedCredits.stream;

  Stream<int> gradeAmountsElementAt(int index) => _gradeCounts[index].stream;
  void _updateGradeAmountsElementAt(int index, int newValue) =>
      _gradeCounts[index].sink.add(newValue);
  int currentGradeAmountsElementAt(int index) => _gradeCounts[index].value;

  double get currentTotalGrade => _totalGradePoints.value;
  int get currentTotalCredit => _totalCredits.value;
  double get currentMajorGrade => _majorGradePoints.value;
  int get currentMajorCredit => _majorCredits.value;
  int get currentPCredit => _passFailCredits.value;

  void _updateTotalGradeAve(double newTotalGrade, int newTotalCredit) =>
      _averageGradePoint.sink.add(double.parse(
          (newTotalGrade / ((newTotalCredit == 0) ? 1 : newTotalCredit))
              .toStringAsFixed(2)));

  void _updateMajorGradeAve(double newMajorGrade, int newMajorCredit) =>
      _averageMajorGradePoint.sink.add(double.parse(
          (newMajorGrade / ((newMajorCredit == 0) ? 1 : newMajorCredit))
              .toStringAsFixed(2)));

  void _updateCreditAmount(int newTotalCredit, int newPCredit) =>
      _totalEarnedCredits.sink.add(newTotalCredit + newPCredit);

  /// subjects배열 길이의 기본값
  // ignore: constant_identifier_names
  static const DEFAULT_SUBJECTS_LENGTH = 10;

  /// 과목 정보들
  // ignore: prefer_final_fields
  final _subjects = BehaviorSubject<List<CourseInfo>>.seeded([
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
    CourseInfo(),
  ]);

  /// 임시로 각 성적의 총합을 저장할 공간. 자주 사용하는거 같아서 전역 변수로 선언해줌.
  // ignore: prefer_for_elements_to_map_fromiterable, prefer_final_fields
  Map<Grade, int> _tempGrades = Map.fromIterable(Grade.allGrades(),
      key: (element) => element, value: (element) => 0);

  Stream<List<CourseInfo>> get subjects => _subjects.stream;
  List<CourseInfo> get currentSubjects => _subjects.value;
  void _updateSubjects(List<CourseInfo> newSubjects) {
    _subjects.sink.add(newSubjects);
  }

  void updateSubjects() {
    _updateSubjects(currentSubjects);
  }

  /// 학점계산기 페이지에서 [더 입력하기] 버튼을 눌렀을 경우 실행될 함수.
  ///
  /// 현재의 [_subjects]에 새로운 [SubjectInfo]를 추가한다.
  void addSubject() {
    List<CourseInfo> tempList = currentSubjects;
    tempList.add(CourseInfo());
    _updateSubjects(tempList);
  }

  /// 학점계산기 페이지에서 다른 학기를 눌렀을 때 실행될 함수
  ///
  /// [더 입력하기] 버튼으로 추가된 새로운 [SubjectInfo]들 중에서 값을 입력
  /// 받지 않은 [SubjectInfo]를 삭제하는 함수.
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
          targetSubject.courseGrade == Grade.AP) {
        removeIndexes.add(DEFAULT_SUBJECTS_LENGTH + i);
      }
    }

    for (int i = removeIndexes.length - 1; i >= 0; i--) {
      if (i < 0) {
        continue;
      }

      tempList.removeAt(removeIndexes[i]);
    }
    _updateSubjects(tempList);
  }

  /// 학점계산기 페이지에서 [초기화] 버튼을 눌렀을 때 실행될 함수
  ///
  /// 모든 [더 입력하기] 버튼으로 생성된 [SubjectInfo]를 삭제하는 함수
  void removeAdditionalSubjects() {
    if (currentSubjects.length == DEFAULT_SUBJECTS_LENGTH) return;
    List<CourseInfo> tempList = currentSubjects;
    for (int i = tempList.length - DEFAULT_SUBJECTS_LENGTH - 1; i >= 0; i--) {
      tempList.removeLast();
    }
    _updateSubjects(tempList);
  }

  /// 현재 학기의 성적을 최신 값으로 갱신하는 함수
  void updateGrades() {
    double tempTotalGrade = 0.0;
    int tempTotalCredit = 0;
    double tempMajorGrade = 0.0;
    int tempMajorCredit = 0;
    int tempPCredit = 0;
    _tempGrades.forEach(
          (key, value) => _tempGrades[key] = 0,
    );

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

  /// [_subjects]의 [index] 번째 과목을 갱신하는 함수
  ///
  /// inputs
  /// * [index] : [_subjects]에서 갱신할 [SubjectInfo]가 있는 [index]
  ///
  /// inputs(option)
  /// * [courseName] : 과목 이름
  /// * [courseCredits] : 학점
  /// * [courseGrade] : 성적
  /// * [isPassFail] : P 또는 NP 과목 여부
  /// * [isMajorCourse] : 전공과목 여부
  ///
  /// ### [option] 값 들 중 [courseName]을 제외한 나머지 값들 중 하나라도 [null]이 아닐 경우,
  /// -> [updateGrades()] 가 실행된다.
  void updateSubject(
      int index, {
        String? courseName,
        int? courseCredits,
        Grade? courseGrade,
        bool? isPassFail,
        bool? isMajorCourse,
      }) {
    if (courseName != null) currentSubjects[index].courseName = courseName;
    if (courseCredits != null) currentSubjects[index].courseCredits = courseCredits;
    if (courseGrade != null) currentSubjects[index].courseGrade = courseGrade;
    if (isPassFail != null) currentSubjects[index].isPassFail = isPassFail;
    if (isMajorCourse != null) currentSubjects[index].isMajorCourse = isMajorCourse;

    if (courseCredits != null ||
        courseGrade != null ||
        isPassFail != null ||
        isMajorCourse != null) {
      updateGrades();
    }
  }

  /// [_subjects]의 [index]에 있는 [SubjectInfo]를 초기값으로 되돌리는 함수.
  void setDefault(int index) {
    currentSubjects[index].courseName = '';
    currentSubjects[index].courseCredits = 0;
    currentSubjects[index].courseGrade = Grade.AP;
    currentSubjects[index].isMajorCourse = false;
    currentSubjects[index].isPassFail = false;
    updateGrades();
  }

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
