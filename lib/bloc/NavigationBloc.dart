import 'package:rxdart/subjects.dart';

class NavigationBloc {
  final _currentIndex = BehaviorSubject<int>.seeded(0);

  Stream<int> get currentIndexStream => _currentIndex.stream;
  Function(int) get changeIndex => _currentIndex.sink.add;

  void onNavigationIconTapped(int index) {
    changeIndex(index);
  }

  void dispose() {
    _currentIndex.close();
  }
}