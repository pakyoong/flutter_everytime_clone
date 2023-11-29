import 'package:rxdart/subjects.dart';

class GradeCalculatorBloc {
  // 현재 선택된 학기를 관리하는 BehaviorSubject
  final _currentTerm = BehaviorSubject<int>.seeded(0);

  // 성적 변경 시 ModalBottomSheet의 표시 여부를 관리하는 BehaviorSubject
  final _isShowingSelectGrade = BehaviorSubject<bool>.seeded(false);

  // 현재 선택 중인 성적의 인덱스를 관리하는 BehaviorSubject
  final _currentSelectingIndex = BehaviorSubject<int?>.seeded(null);

  // 창 애니메이션이 끝났는지 확인하기 위한 딜레이를 관리하는 BehaviorSubject
  final _delay = BehaviorSubject<bool>();

  // 현재 선택된 학기에 대한 스트림 getter
  Stream<int> get currentTerm => _currentTerm.stream;

  // 현재 선택된 학기를 업데이트하는 함수
  Function(int) get updateCurrentTerm => _currentTerm.sink.add;

  // 현재 선택된 학기 값을 가져오는 getter
  int get currentCurrentTerm => _currentTerm.value;

  // ModalBottomSheet의 표시 여부에 대한 스트림 getter
  Stream<bool> get isShowingSelectGrade => _isShowingSelectGrade.stream;

  // ModalBottomSheet의 표시 여부를 업데이트하는 함수
  Function(bool) get updateIsShowingSelectGrade =>
      _isShowingSelectGrade.sink.add;

  // 현재 선택 중인 성적 인덱스에 대한 스트림 getter
  Stream<int?> get currentSelectingIndex => _currentSelectingIndex.stream;

  // 현재 선택 중인 성적 인덱스를 업데이트하는 함수
  Function(int?) get updateCurrentSelectingIndex =>
      _currentSelectingIndex.sink.add;

  // 애니메이션 딜레이에 대한 스트림 getter
  Stream<bool> get delay => _delay.stream;

  // 애니메이션 딜레이를 업데이트하는 함수
  Function(bool) get updateDelay => _delay.sink.add;

  // Bloc의 리소스를 해제하는 함수
  dispose() {
    _currentTerm.close();

    _isShowingSelectGrade.close();
    _currentSelectingIndex.close();

    _delay.close();
  }
}
