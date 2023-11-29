import 'package:rxdart/subjects.dart';

class MainBloc {
  // 애플리케이션의 메인 화면에서 현재 페이지 인덱스를 관리하는 BehaviorSubject
  final _page = BehaviorSubject<int>.seeded(0);

  // 현재 페이지 인덱스에 대한 스트림
  Stream<int> get page => _page.stream;

  // 페이지 인덱스를 업데이트하는 함수
  Function(int) get updatePage => _page.sink.add;

  // 네비게이션 아이콘 탭 시 호출되는 함수, 페이지 인덱스 업데이트
  onTapNavIcon(index) {
    updatePage(index); // 선택된 인덱스로 페이지 업데이트
  }

  // MainBloc 클래스의 리소스를 해제하는 함수
  dispose() {
    _page.close(); // BehaviorSubject 리소스 해제
  }
}
