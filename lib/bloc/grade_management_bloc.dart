import 'package:rxdart/subjects.dart';

class GradeManagementBloc {
  // BehaviorSubject를 사용하여 선택된 학기, 성적 선택기의 표시 여부, 선택된 성적 인덱스 및 업데이트 지연 여부를 관리합니다.
  final _selectedTerm = BehaviorSubject<int>.seeded(0); // 선택된 학기 인덱스 관리
  final _showingGradeSelector = BehaviorSubject<bool>.seeded(false); // 성적 선택기의 표시 여부
  final _selectingGradeIndex = BehaviorSubject<int?>.seeded(null); // 선택된 성적 인덱스 관리
  final _updateDelay = BehaviorSubject<bool>(); // 업데이트 지연 상태 관리

  // 현재 선택된 학기에 대한 스트림 getter
  Stream<int> get selectedTerm => _selectedTerm.stream;

  // 현재 선택된 학기를 업데이트하는 함수
  Function(int) get updateSelectedTerm => _selectedTerm.sink.add;

  // 현재 선택된 학기 값을 가져오는 getter
  int get currentSelectedTerm => _selectedTerm.value;

  // ModalBottomSheet의 표시 여부에 대한 스트림 getter
  Stream<bool> get showingGradeSelector => _showingGradeSelector.stream;

  // ModalBottomSheet의 표시 여부를 업데이트하는 함수
  Function(bool) get updateShowingGradeSelector =>
      _showingGradeSelector.sink.add;

  // 현재 선택 중인 성적 인덱스에 대한 스트림 getter
  Stream<int?> get selectingGradeIndex => _selectingGradeIndex.stream;

  // 현재 선택 중인 성적 인덱스를 업데이트하는 함수
  Function(int?) get updateSelectingGradeIndex =>
      _selectingGradeIndex.sink.add;

  // 애니메이션 딜레이에 대한 스트림 getter
  Stream<bool> get updateDelay => _updateDelay.stream;

  // 애니메이션 딜레이를 업데이트하는 함수
  Function(bool) get setUpdateDelay => _updateDelay.sink.add;

  // Bloc의 리소스를 해제하는 함수
  dispose() {
    _selectedTerm.close();

    _showingGradeSelector.close();
    _selectingGradeIndex.close();

    _updateDelay.close();
  }
}
