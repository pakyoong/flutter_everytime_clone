import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everytime/model/time_table_enums.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/class_info.dart';
import 'package:rxdart/subjects.dart';

class GradeOfTerm {
  String? id; // Firestore 문서 ID (null 가능)
  final String term; // 학기

  // BehaviorSubjects
  final _totalGrade = BehaviorSubject<double>.seeded(0.0); // 총 학점
  final _totalCredit = BehaviorSubject<int>.seeded(0); // 총 이수 학점
  final _majorGrade = BehaviorSubject<double>.seeded(0.0); // 전공 학점
  final _majorCredit = BehaviorSubject<int>.seeded(0); // 전공 이수 학점
  final _pCredit = BehaviorSubject<int>.seeded(0); // P/NP 학점
  final _totalGradeAve = BehaviorSubject<double>.seeded(0.0); // 총 평균 학점
  final _majorGradeAve = BehaviorSubject<double>.seeded(0.0); // 전공 평균 학점
  final _creditAmount = BehaviorSubject<int>.seeded(0); // 총 이수 학점 + P/NP 학점
  final _subjects = BehaviorSubject<List<ClassInfo>>.seeded([]); // 과목 정보 리스트
  final List<BehaviorSubject<int>> _gradeAmounts = List.generate(
      Grade.values.length, (index) => BehaviorSubject<int>.seeded(0)); // 각 학점별 과목 수



  // 스트림 및 BehaviorSubject 업데이트 함수
  Stream<double> get totalGrade => _totalGrade.stream;
  Stream<int> get totalCredit => _totalCredit.stream;
  Stream<double> get majorGrade => _majorGrade.stream;
  Stream<int> get majorCredit => _majorCredit.stream;
  Stream<int> get pCredit => _pCredit.stream;

  // 스트림 및 BehaviorSubject 업데이트 함수
  Stream<double> get totalGradeAve => _totalGradeAve.stream;
  double get currentTotalGradeAve => _totalGradeAve.value;
  Stream<double> get majorGradeAve => _majorGradeAve.stream;
  double get currentMajorGradeAve => _majorGradeAve.value;
  Stream<int> get creditAmount => _creditAmount.stream;

  Stream<int> gradeAmountsElementAt(int index) => _gradeAmounts[index].stream;
  int currentGradeAmountsElementAt(int index) => _gradeAmounts[index].value;

  double get currentTotalGrade => _totalGrade.value;
  int get currentTotalCredit => _totalCredit.value;
  double get currentMajorGrade => _majorGrade.value;
  int get currentMajorCredit => _majorCredit.value;
  int get currentPCredit => _pCredit.value;

  // BehaviorSubjects를 업데이트하는 private 메서드들
  void _updateTotalGrade(double value) {
    _totalGrade.sink.add(value);
  }

  void _updateTotalCredit(int value) {
    _totalCredit.sink.add(value);
  }

  void _updateMajorGrade(double value) {
    _majorGrade.sink.add(value);
  }

  void _updateMajorCredit(int value) {
    _majorCredit.sink.add(value);
  }

  void _updatePCredit(int value) {
    _pCredit.sink.add(value);
  }

  void _updateTotalGradeAve(double totalGrade, int totalCredit) {
    _totalGradeAve.sink.add(totalGrade / (totalCredit > 0 ? totalCredit : 1));
  }

  void _updateMajorGradeAve(double majorGrade, int majorCredit) {
    _majorGradeAve.sink.add(majorGrade / (majorCredit > 0 ? majorCredit : 1));
  }

  void _updateCreditAmount(int totalCreditWithPCredit) {
    _creditAmount.sink.add(totalCreditWithPCredit);
  }

  void _updateSubjects(List<ClassInfo> subjects) {
    _subjects.sink.add(subjects);
  }

  // Constructor
  GradeOfTerm({required this.term, this.id});

  // Firestore에서 문서를 생성하는 함수
  Future<void> createFirestoreData() async {
    if (id == null) {
      DocumentReference docRef = FirebaseFirestore.instance.collection('gradesOfTerms').doc();
      id = docRef.id;
      await docRef.set(toFirestore());
    }
  }

  // Firestore 문서를 업데이트하는 함수
  Future<void> updateFirestoreData() async {
    if (id != null) {
      await FirebaseFirestore.instance.collection('gradesOfTerms').doc(id).update(toFirestore());
    }
  }

  // Firestore에서 읽어온 데이터를 객체로 변환
  static Future<GradeOfTerm> fromFirestore(DocumentSnapshot doc) async {
    var data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid Firestore data');
    }

    return GradeOfTerm(
      id: doc.id,
      term: data['term'],
    );
  }


  // Firestore 문서로부터 데이터를 가져와서 BehaviorSubjects를 업데이트하는 함수
  Future<void> loadFromFirestore() async {
    if (id != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('gradesOfTerms').doc(id).get();
      var data = doc.data() as Map<String, dynamic>;

      _updateTotalGrade(data['totalGrade']);
      _updateTotalCredit(data['totalCredit']);
      _updateMajorGrade(data['majorGrade']);
      _updateMajorCredit(data['majorCredit']);
      _updatePCredit(data['pCredit']);
      _updateTotalGradeAve(data['totalGrade'], data['totalCredit']);
      _updateMajorGradeAve(data['majorGrade'], data['majorCredit']);
      _updateCreditAmount(data['totalCredit'] + data['pCredit']);
      _updateSubjects((data['subjects'] as List).map((e) => ClassInfo.fromFirestore(e as QueryDocumentSnapshot)).toList());
    }
  }

  // Firestore에 데이터를 저장하기 위한 Map 변환
  Map<String, dynamic> toFirestore() {
    return {
      'term': term,
      'totalGrade': _totalGrade.value,
      'totalCredit': _totalCredit.value,
      'majorGrade': _majorGrade.value,
      'majorCredit': _majorCredit.value,
      'pCredit': _pCredit.value,
      'totalGradeAve': _totalGradeAve.value,
      'majorGradeAve': _majorGradeAve.value,
      'creditAmount': _creditAmount.value,
      'subjects': _subjects.value.map((subject) => subject.toFirestore()).toList(),
    };
  }

  // 성적을 업데이트하는 함수
  void updateGrades() {
    double totalGrade = 0.0;
    int totalCredit = 0;
    double majorGrade = 0.0;
    int majorCredit = 0;
    int pCredit = 0;

    for (var subject in _subjects.value) {
      if (subject.isPassFail) {
        if (subject.classGrade == Grade.P) {
          pCredit += subject.classCredits;
        }
        continue;
      }

      if (subject.isMajorClass) {
        majorGrade += subject.classGrade.point * subject.classCredits;
        majorCredit += subject.classCredits;
      }

      totalGrade += subject.classGrade.point * subject.classCredits;
      totalCredit += subject.classCredits;
    }

    _updateTotalGrade(totalGrade);
    _updateTotalCredit(totalCredit);
    _updateMajorGrade(majorGrade);
    _updateMajorCredit(majorCredit);
    _updatePCredit(pCredit);
    _updateTotalGradeAve(totalGrade, totalCredit);
    _updateMajorGradeAve(majorGrade, majorCredit);
    _updateCreditAmount(totalCredit + pCredit);
    updateFirestoreData();
    updateFirestoreData();
  }

  Stream<List<ClassInfo>> get subjects => _subjects.stream;

  // 과목을 추가하는 함수
  void addSubject(ClassInfo subject) {
    List<ClassInfo> updatedSubjects = List.from(_subjects.value);
    updatedSubjects.add(subject);
    _subjects.sink.add(updatedSubjects);
    updateFirestoreData();
  }

  // 과목을 업데이트하는 함수
  void updateSubject(int index, ClassInfo updatedSubject) {
    List<ClassInfo> updatedSubjects = List.from(_subjects.value);
    if (index >= 0 && index < updatedSubjects.length) {
      updatedSubjects[index] = updatedSubject;
      _subjects.sink.add(updatedSubjects);
      updateFirestoreData();
    }
  }

  /// subjects배열 길이의 기본값
  // ignore: constant_identifier_names
  static const DEFAULT_SUBJECTS_LENGTH = 10;


// 빈 과목 제거
  Future<void> removeEmptySubjects() async {
    if (_subjects.value.length <= DEFAULT_SUBJECTS_LENGTH) return;

    List<ClassInfo> updatedSubjects = [];
    for (var subject in _subjects.value) {
      if (subject.isMajorClass == false &&
          subject.classCredits == 0 &&
          subject.className.isEmpty &&
          subject.classGrade == Grade.aPlus) {
        continue; // 제거 대상 과목은 추가하지 않음
      }
      updatedSubjects.add(subject);
    }

    _subjects.sink.add(updatedSubjects);
    await updateFirestoreData(); // Firestore 문서 업데이트
  }

  // 추가된 과목 초기화
  Future<void> removeAdditionalSubjects() async {
    if (_subjects.value.length <= DEFAULT_SUBJECTS_LENGTH) return;

    List<ClassInfo> updatedSubjects = _subjects.value.sublist(0, DEFAULT_SUBJECTS_LENGTH);
    _subjects.sink.add(updatedSubjects);
    await updateFirestoreData(); // Firestore 문서 업데이트
  }

  // 과목을 기본값으로 설정하는 함수
  void setDefaultSubject(int index) {
    if (index >= 0 && index < _subjects.value.length) {
      _subjects.value[index] = ClassInfo(
        className: '',
        classCredits: 0,
        classGrade: Grade.undefined, // 적절한 기본값 설정
        isPassFail: false,
        isMajorClass: false,
      );
      _subjects.sink.add(List.from(_subjects.value));
      updateFirestoreData();
    }
  }

  // 리소스 해제 함수
  void dispose() {
    _totalGrade.close();
    _totalCredit.close();
    _majorGrade.close();
    _majorCredit.close();
    _pCredit.close();
    _totalGradeAve.close();
    _majorGradeAve.close();
    _creditAmount.close();
    _subjects.close();
  }
}
