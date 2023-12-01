import 'package:rxdart/subjects.dart';

class TabNavigationBloc {
  // 탭 바에서 현재 선택된 인덱스를 관리하는 BehaviorSubject
  final BehaviorSubject<int> _currentIndex = BehaviorSubject<int>.seeded(0);

  // 현재 선택된 인덱스에 대한 스트림
  Stream<int> get currentIndexStream => _currentIndex.stream;

  // 현재 인덱스를 업데이트하는 함수
  Function(int) get updateCurrentIndex => _currentIndex.sink.add;

  // TabBarBloc 클래스의 리소스를 해제하는 함수
  dispose() {
    _currentIndex.close(); // BehaviorSubject 리소스 해제
  }
}
