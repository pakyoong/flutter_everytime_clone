import 'package:rxdart/subjects.dart';

// NavigationBloc: 앱 내에서 네비게이션 탭 변경을 관리하는 클래스
class NavigationBloc {
  // 애플리케이션의 메인 화면에서 현재 페이지 인덱스를 관리하는 BehaviorSubject
  final _currentIndex = BehaviorSubject<int>.seeded(0);

  // 현재 인덱스의 스트림에 대한 getter. 외부에서 현재 인덱스의 변경을 관찰할 수 있도록 함
  Stream<int> get currentIndexStream => _currentIndex.stream;

  // 현재 인덱스를 변경하는 함수에 대한 getter. 외부에서 인덱스를 변경할 수 있도록 함
  Function(int) get changeIndex => _currentIndex.sink.add;

  // 네비게이션 아이콘 탭 시 호출되는 함수, 페이지 인덱스 업데이트
  onNavigationIconTapped(index) {
    changeIndex(index); // 선택된 인덱스로 페이지 업데이트
  }

  // MainBloc 클래스의 리소스를 해제하는 함수
  dispose() {
    _currentIndex.close(); // BehaviorSubject 리소스 해제
  }
}
