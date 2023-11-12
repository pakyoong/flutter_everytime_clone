import 'package:rxdart/subjects.dart';

// NavigationBloc: 앱 내에서 네비게이션 탭 변경을 관리하는 클래스
class NavigationBloc {
  // 현재 선택된 탭 인덱스를 관리하는 BehaviorSubject
  final _currentIndex = BehaviorSubject<int>.seeded(0);

  // 현재 인덱스의 스트림에 대한 getter. 외부에서 현재 인덱스의 변경을 관찰할 수 있도록 함
  Stream<int> get currentIndexStream => _currentIndex.stream;

  // 현재 인덱스를 변경하는 함수에 대한 getter. 외부에서 인덱스를 변경할 수 있도록 함
  Function(int) get changeIndex => _currentIndex.sink.add;

  // 네비게이션 아이콘이 탭될 때 호출될 메서드. 주어진 인덱스로 현재 인덱스를 변경
  void onNavigationIconTapped(int index) {
    changeIndex(index);
  }

  // 자원 해제를 위한 dispose 메서드. BehaviorSubject를 닫아줌
  void dispose() {
    _currentIndex.close();
  }
}
