import 'package:rxdart/subjects.dart';

class CustomAppBarWithTextFieldBloc {
  // 텍스트 필드의 접미사(예: 검색 아이콘)의 표시 여부를 관리하는 변수
  final _visibleSuffix = BehaviorSubject<bool>.seeded(false);

  // 접미사의 표시 여부에 대한 스트림 getter
  Stream<bool> get visibleSuffix => _visibleSuffix.stream;

  // 접미사의 표시 여부를 업데이트하는 함수
  Function(bool) get updateVisibleSuffix => _visibleSuffix.sink.add;

  // Bloc의 리소스를 해제하는 함수
  dispose() {
    _visibleSuffix.close();
  }
}
