import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

class GradeManagementBloc {
  // Firestore에서 가져온 현재 학기의 성적 데이터를 관리하는 BehaviorSubject
  final _currentGradeData = BehaviorSubject<Map<String, dynamic>>();

  // 현재 선택된 학기 인덱스를 관리하는 BehaviorSubject
  final _selectedTerm = BehaviorSubject<int>.seeded(0);

  // 성적 선택기의 표시 여부를 관리하는 BehaviorSubject
  final _showingGradeSelector = BehaviorSubject<bool>.seeded(false);

  // 현재 선택 중인 성적 인덱스를 관리하는 BehaviorSubject
  final _selectingGradeIndex = BehaviorSubject<int?>.seeded(null);

  // 업데이트 지연 상태를 관리하는 BehaviorSubject
  final _updateDelay = BehaviorSubject<bool>();

  // Firestore에서 성적 데이터를 불러오는 함수
  void loadGradeData(String termId) {
    FirebaseFirestore.instance
        .collection('grades')
        .doc(termId)
        .snapshots()
        .listen((snapshot) {
      // Firestore에서 가져온 데이터가 null이 아닌 경우에만 값을 추가합니다.
      if (snapshot.data() != null) {
        _currentGradeData.sink.add(snapshot.data()!);
      } else {
        // null인 경우에는 빈 맵을 추가합니다.
        _currentGradeData.sink.add({});
      }
    });
  }


  // 현재 성적 데이터 스트림 getter
  Stream<Map<String, dynamic>> get currentGradeData => _currentGradeData.stream;

  // 선택된 학기 인덱스에 대한 스트림 getter
  Stream<int> get selectedTerm => _selectedTerm.stream;

  // 선택된 학기 인덱스를 업데이트하는 함수
  Function(int) get updateSelectedTerm => _selectedTerm.sink.add;

  // 성적 선택기 표시 여부 스트림 getter
  Stream<bool> get showingGradeSelector => _showingGradeSelector.stream;

  // 성적 선택기 표시 여부를 업데이트하는 함수
  Function(bool) get updateShowingGradeSelector =>
      _showingGradeSelector.sink.add;

  // 선택 중인 성적 인덱스 스트림 getter
  Stream<int?> get selectingGradeIndex => _selectingGradeIndex.stream;

  // 선택 중인 성적 인덱스를 업데이트하는 함수
  Function(int?) get updateSelectingGradeIndex =>
      _selectingGradeIndex.sink.add;

  // 업데이트 지연 상태 스트림 getter
  Stream<bool> get updateDelay => _updateDelay.stream;

  // 업데이트 지연 상태를 설정하는 함수
  Function(bool) get setUpdateDelay => _updateDelay.sink.add;

  // Firestore에 성적 데이터를 업데이트하는 함수
  void updateGradeData(String termId, Map<String, dynamic> newData) {
    FirebaseFirestore.instance
        .collection('grades')
        .doc(termId)
        .update(newData);
  }

  // Bloc 리소스 해제
  dispose() {
    _currentGradeData.close();
    _selectedTerm.close();
    _showingGradeSelector.close();
    _selectingGradeIndex.close();
    _updateDelay.close();
  }
}
