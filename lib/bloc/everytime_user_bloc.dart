import 'dart:math';

import 'package:everytime/model/enums.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/bar_chart_data.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/grade_of_term.dart';
import 'package:everytime/model/time_table_page/grade_calculator_page/point_chart_data.dart';
import 'package:everytime/model/time_table_page/time_n_place_data.dart';
import 'package:everytime/model/time_table_page/time_table.dart';
import 'package:everytime/model/time_table_page/time_table_data.dart';
import 'package:rxdart/subjects.dart';

class EverytimeUserBloc {
  // 유저 관련 정보를 관리하는 클래스

  // 유저의 기본 정보를 BehaviorSubject로 관리하는 부분
  final _name = BehaviorSubject<String>(); // 유저 이름
  final _univ = BehaviorSubject<String>(); // 유저 학교
  final _nickName = BehaviorSubject<String>(); // 유저 닉네임
  final _id = BehaviorSubject<String>(); // 유저 아이디
  final _year = BehaviorSubject<int>(); // 유저가 입학한 년도

  // 유저 정보에 대한 스트림과 업데이트 함수들
  Stream<String> get name => _name.stream;
  Stream<String> get univ => _univ.stream;
  Stream<String> get nickName => _nickName.stream;
  Stream<String> get id => _id.stream;
  Stream<int> get year => _year.stream;

  Function(String) get updateName => _name.sink.add;
  Function(String) get updateUniv => _univ.sink.add;
  Function(String) get updateNickName => _nickName.sink.add;
  Function(String) get updateId => _id.sink.add;
  Function(int) get updateYear => _year.sink.add;

  // 시간표 관련 데이터를 관리하는 부분

  // 시간표 리스트를 BehaviorSubject로 관리
  final _timeTableList = BehaviorSubject<List<TimeTable>>.seeded([]);
  // 현재 선택된 시간표를 관리
  final _selectedTimeTable = BehaviorSubject<TimeTable?>.seeded(null);

  // 시간표 리스트와 선택된 시간표에 대한 스트림과 업데이트 함수들
  Stream<List<TimeTable>> get timeTableList => _timeTableList.stream;
  Stream<TimeTable?> get selectedTimeTable => _selectedTimeTable.stream;

  Function(List<TimeTable>) get _updateTimeTableList => _timeTableList.sink.add;
  Function(TimeTable?) get updateSelectedTimeTable => _selectedTimeTable.sink.add;

  // 현재 시간표 리스트와 선택된 시간표에 대한 getter
  List<TimeTable> get currentTimeTableList => _timeTableList.value;
  TimeTable? get currentSelectedTimeTable => _selectedTimeTable.value;

  // 특정 학기에 해당하는 시간표를 찾는 함수
  TimeTable? findTimeTableAtSpecificTerm(String termString) {
    List<TimeTable> timeTableList = currentTimeTableList;
    TimeTable? secondTimeTable;
    // 특정 학기의 시간표를 찾는 함수
    for (TimeTable timeTable in timeTableList) {
      if (timeTable.termString == termString) {
        if (timeTable.currentIsDefault) {
          return timeTable; // 기본 시간표가 맞으면 해당 시간표 반환
        }

        if (secondTimeTable == null) {
          secondTimeTable = timeTable; // 기본 시간표가 아니면 임시 저장
          secondTimeTable.updateIsDefault(true); // 기본 시간표로 설정

          break;
        }
      }
    }

    return secondTimeTable; // 찾은 시간표 반환
  }

  // 특정 인덱스의 시간표 데이터를 제거하는 함수
  void removeTimeTableDataAt(
      int currentIndex,
      List<TimeTableData> timeTableData,
      ) {
    int tempDayOfWeekIndex = defaultDayOfWeekListLast; // 기본 요일 인덱스
    int tempStartHour = defaultTimeListFirst; // 기본 시작 시간
    int tempEndHour = defaultTimeListLast; // 기본 종료 시간

    int removeDayOfWeekIndex = defaultDayOfWeekListLast; // 제거할 요일 인덱스
    int removeStartHour = defaultTimeListFirst; // 제거할 시작 시간
    int removeEndHour = defaultTimeListLast; // 제거할 종료 시간

    for (int i = 0; i < timeTableData.length; i++) {
      for (TimeNPlaceData dates in timeTableData[i].dates) {
        if (i == currentIndex) {
          // 현재 인덱스의 데이터를 체크하여 제거할 값 설정
          if (removeDayOfWeekIndex < DayOfWeek.getByDayOfWeek(dates.dayOfWeek)) {
            removeDayOfWeekIndex = DayOfWeek.getByDayOfWeek(dates.dayOfWeek);
          }

          if (removeStartHour > dates.startHour) {
            removeStartHour = dates.startHour;
          }

          if (removeEndHour < dates.endHour) {
            removeEndHour = dates.endHour;
          }
        } else {
          // 다른 인덱스의 데이터를 체크하여 기존 값 유지
          if (tempDayOfWeekIndex < DayOfWeek.getByDayOfWeek(dates.dayOfWeek)) {
            tempDayOfWeekIndex = DayOfWeek.getByDayOfWeek(dates.dayOfWeek);
          }

          if (tempStartHour > dates.startHour) {
            tempStartHour = dates.startHour;
          }

          if (tempEndHour < dates.endHour) {
            tempEndHour = dates.endHour;
          }
        }
      }
    }

    currentSelectedTimeTable!.removeTimeTableData(currentIndex); // 시간표 데이터 제거

    // 제거할 요일과 시간 범위를 사용하여 요일과 시간 리스트에서 해당 요일 및 시간을 제거
    removeDayOfWeek(
      removeDayOfWeekIndex,
      [
        TimeNPlaceData(
          dayOfWeek: DayOfWeek.getByIndex(tempDayOfWeekIndex),
          startHour: tempStartHour,
          endHour: tempEndHour,
        ),
      ],
    );
    removeTimeList(
      removeStartHour,
      removeEndHour,
      [
        TimeNPlaceData(
          dayOfWeek: DayOfWeek.getByIndex(tempDayOfWeekIndex),
          startHour: tempStartHour,
          endHour: tempEndHour,
        ),
      ],
    );
  }

  // 시간표의 충돌 여부를 확인하는 함수
  String? checkTimeTableCrash(TimeTableData data) {
    String? result; // 결과를 저장할 변수

    // 입력된 데이터와 기존 데이터를 비교하여 시간 충돌 여부 확인
    for (int oldIndex = 0; oldIndex < data.dates.length; oldIndex++) {
      TimeNPlaceData oldData = data.dates[oldIndex];
      for (int newIndex = 0; newIndex < data.dates.length; newIndex++) {
        if (oldIndex == newIndex) {
          continue; // 같은 인덱스는 비교하지 않음
        }

        TimeNPlaceData newData = data.dates[newIndex];

        if (oldData.dayOfWeek == newData.dayOfWeek) {
          // 요일이 같은 경우 시간 충돌 검사
          DateTime newStartTime = DateTime(1970, 1, 1, newData.startHour, newData.startMinute);
          DateTime newEndTime = DateTime(1970, 1, 1, newData.endHour, newData.endMinute);
          DateTime oldStartTime = DateTime(1970, 1, 1, oldData.startHour, oldData.startMinute);
          DateTime oldEndTime = DateTime(1970, 1, 1, oldData.endHour, oldData.endMinute);

          int oldPlayTime = oldEndTime.difference(oldStartTime).inMinutes;

          if (newStartTime.difference(oldStartTime).inMinutes >= oldPlayTime) {
            // 새로운 시작 시간이 기존 시간보다 뒤면 충돌 없음
          } else if (oldEndTime.difference(newEndTime).inMinutes >= oldPlayTime) {
            // 새로운 종료 시간이 기존 시간보다 앞이면 충돌 없음
          } else {
            result = '입력 받은'; // 충돌 발생 시
            break;
          }
        }
      }
    }

    if (result != null) {
      return result; // 충돌 발생한 경우 결과 반환
    }

    // 선택된 시간표와 전체 시간표를 비교하여 충돌 검사
    for (TimeTableData timeTableData in currentSelectedTimeTable!.currentTimeTableData) {
      for (TimeNPlaceData oldData in timeTableData.dates) {
        for (TimeNPlaceData newData in data.dates) {
          if (oldData.dayOfWeek == newData.dayOfWeek) {
            // 요일이 같은 경우 시간 충돌 검사
            DateTime newStartTime = DateTime(1970, 1, 1, newData.startHour, newData.startMinute);
            DateTime newEndTime = DateTime(1970, 1, 1, newData.endHour, newData.endMinute);
            DateTime oldStartTime = DateTime(1970, 1, 1, oldData.startHour, oldData.startMinute);
            DateTime oldEndTime = DateTime(1970, 1, 1, oldData.endHour, oldData.endMinute);

            int oldPlayTime = oldEndTime.difference(oldStartTime).inMinutes;

            if (newStartTime.difference(oldStartTime).inMinutes >= oldPlayTime) {
              // 새로운 시작 시간이 기존 시간보다 뒤면 충돌 없음
            } else if (oldEndTime.difference(newEndTime).inMinutes >= oldPlayTime) {
              // 새로운 종료 시간이 기존 시간보다 앞이면 충돌 없음
            } else {
              result = timeTableData.subjectName; // 충돌 발생 시 과목명 반환
              break;
            }
          }
        }
      }


      if (result != null) {
        break; // 충돌 발생한 경우 반복문 종료
      }
    }

    return result; // 최종 결과 반환
  }
// 입력받은 학기 이름과 시간표 이름을 가진 시간표를 삭제하는 함수
  void removeTimeTableList(String termString, String name) {
    Map<String, dynamic> result = findTimeTable(termString, name); // 해당 시간표 찾기

    if (result['timeTable'] == null || result['index'] == null) return; // 시간표가 없으면 종료

    List<TimeTable> tempTimeTableList = currentTimeTableList; // 현재 시간표 리스트 복사
    tempTimeTableList.removeAt(result['index']); // 찾은 시간표 삭제
    _updateTimeTableList(tempTimeTableList); // 업데이트된 시간표 리스트 반영
  }

  // 새로운 시간표를 시간표 리스트에 추가하는 함수
  void addTimeTableList(TimeTable newTimeTable) {
    List<TimeTable> tempList = currentTimeTableList; // 현재 시간표 리스트 복사
    tempList.add(newTimeTable); // 새 시간표 추가
    _timeTableList.add(tempList); // 업데이트된 시간표 리스트 반영
  }

  // 주어진 학기 이름과 시간표 이름으로 시간표를 찾아서 데이터를 갱신하는 함수
  void updateTimeTableList(
      String termString,
      String name, {
        String? newName,
        List<TimeTableData>? timeTableData,
        bool? isDefault,
      }) {
    Map<String, dynamic> result = findTimeTable(termString, name); // 해당 시간표 찾기

    if (result['timeTable'] == null || result['index'] == null) return; // 시간표가 없으면 종료

    if (newName != null) result['timeTable'].updateName(newName); // 새 이름으로 업데이트
    if (timeTableData != null) {
      result['timeTable'].updateTimeTableData(timeTableData); // 새 시간표 데이터로 업데이트
    }
    if (isDefault != null) result['timeTable'].updateIsDefault(isDefault); // 기본 시간표 여부 업데이트

    if (newName != null || timeTableData != null || isDefault != null) {
      List<TimeTable> tempTimeTableList = currentTimeTableList; // 현재 시간표 리스트 복사
      tempTimeTableList.replaceRange(
        result['index'],
        result['index'] + 1,
        [result['timeTable']],
      ); // 업데이트된 시간표로 교체
      _updateTimeTableList(tempTimeTableList); // 업데이트된 시간표 리스트 반영
    }
  }

  // 입력받은 학기 이름과 시간표 이름으로 시간표를 찾아서 반환하는 함수
  Map<String, dynamic> findTimeTable(String termString, String name) {
    TimeTable? tempTimeTable; // 임시 저장할 시간표 변수
    int? tempIndex; // 찾은 시간표의 인덱스

    // 시간표 리스트를 순회하면서 일치하는 시간표 찾기
    for (int i = 0; i < currentTimeTableList.length; i++) {
      if (currentTimeTableList[i].currentName == name && currentTimeTableList[i].termString == termString) {
        tempTimeTable = currentTimeTableList[i]; // 일치하는 시간표 저장
        tempIndex = i; // 일치하는 시간표의 인덱스 저장
      }
    }

    return {'timeTable': tempTimeTable, 'index': tempIndex}; // 찾은 시간표와 인덱스 반환
  }

  // [_timeList]와 [_dayOfWeekList]에 대한 기본값과 관련 함수들

  // 시간표의 시간 목록의 기본 길이 값
  static const DEFAULT_TIME_LIST_LENGTH = 7;
  int get defaultTimeListLength => DEFAULT_TIME_LIST_LENGTH;

  // 시간표의 시간 목록에서 첫 번째 시간의 기본 값
  static const DEFAULT_TIME_LIST_FIRST = 9;
  int get defaultTimeListFirst => DEFAULT_TIME_LIST_FIRST;

  // 시간표의 시간 목록에서 마지막 시간의 기본 값
  static const DEFAULT_TIME_LIST_LAST = 15;
  int get defaultTimeListLast => DEFAULT_TIME_LIST_LAST;

  // 시간표의 요일 목록에서 마지막 요일의 기본 값
  static const DEFAULT_DAY_OF_WEEK_LIST_LAST = 4;
  int get defaultDayOfWeekListLast => DEFAULT_DAY_OF_WEEK_LIST_LAST;

  // 시간표의 시간을 저장하는 BehaviorSubject
  final _timeList = BehaviorSubject<List<int>>.seeded([9, 10, 11, 12, 13, 14, 15]);

  // 시간표의 요일을 저장하는 BehaviorSubject
  final _dayOfWeekList = BehaviorSubject<List<DayOfWeek>>.seeded([
    DayOfWeek.mon,
    DayOfWeek.tue,
    DayOfWeek.wed,
    DayOfWeek.thu,
    DayOfWeek.fri
  ]);

  // 시간표의 시간과 요일 목록에 대한 스트림과 업데이트 함수
  Stream<List<int>> get timeList => _timeList.stream;
  Stream<List<DayOfWeek>> get dayOfWeek => _dayOfWeekList.stream;

  Function(List<int>) get updateTimeList => _timeList.sink.add;
  Function(List<DayOfWeek>) get updateDayOfWeekList => _dayOfWeekList.sink.add;

  // 현재 시간표의 시간과 요일 목록을 가져오는 getter
  List<int> get currentTimeList => _timeList.value;
  List<DayOfWeek> get currentDayOfWeek => _dayOfWeekList.value;

  // 시간표에서 특정 시간 범위를 제거하는 함수
  void removeTimeList(int startHour, int endHour, List<TimeNPlaceData> timeNPlaceData) {
    int minHour = min(startHour, endHour); // 최소 시간
    int maxHour = max(startHour, endHour); // 최대 시간
    bool minCheck = false; // 최소 시간이 기본값 내에 있는지 확인
    bool maxCheck = false; // 최대 시간이 기본값 내에 있는지 확인

    // 최소 시간과 최대 시간이 기본값 내에 있는지 검사
    if (minHour >= DEFAULT_TIME_LIST_FIRST) {
      minCheck = true;
    }
    if (maxHour <= DEFAULT_TIME_LIST_LAST) {
      maxCheck = true;
    }
    if (minCheck && maxCheck) return; // 모두 기본값 내에 있으면 함수 종료

    bool isSmallExist = false; // 최소 시간보다 작은 시간이 있는지
    bool isLargeExist = false; // 최대 시간보다 큰 시간이 있는지
    int largestHour = DEFAULT_TIME_LIST_LAST; // 기존 데이터 중 가장 큰 시간
    int smallestHour = DEFAULT_TIME_LIST_FIRST; // 기존 데이터 중 가장 작은 시간
    // 기존 시간 데이터를 검사하여 최소/최대 시간 결정
    for (int i = 0; i < timeNPlaceData.length; i++) {
      if (min(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour) <=
          minHour) {
        isSmallExist = true;
      } else {
        if (smallestHour >=
            min(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour)) {
          smallestHour =
              min(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour);
        }
      }

      if (max(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour) >=
          maxHour) {
        isLargeExist = true;
      } else {
        if (largestHour <=
            max(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour)) {
          largestHour =
              max(timeNPlaceData[i].startHour, timeNPlaceData[i].endHour);
        }
      }
    }

    List<int> currentList = currentTimeList;  // 현재 시간 리스트 복사
    if (!isSmallExist) {
      smallestHour = (smallestHour >= DEFAULT_TIME_LIST_FIRST)
          ? DEFAULT_TIME_LIST_FIRST
          : smallestHour;

      for (int i = (smallestHour - minHour); i >= 1; i--) {
        currentList.removeAt(0);
      }
    }

    if (!isLargeExist) {
      largestHour = (largestHour <= DEFAULT_TIME_LIST_LAST)
          ? DEFAULT_TIME_LIST_LAST
          : largestHour;

      for (int i = (maxHour - largestHour); i >= 1; i--) {
        currentList.removeLast();
      }
    }

    updateTimeList(currentList);// 업데이트된 시간 리스트 반영
  }

  // 시간표에 시간을 추가하는 함수
  void addTimeList(int startHour, int endHour) {
    int maxHour = max(startHour, endHour); // 최대 시간
    int minHour = min(startHour, endHour); // 최소 시간
    List<int> currentList = currentTimeList; // 현재 시간 목록 복사

    // 최소 시간이 현재 목록의 첫 번째 시간보다 작은 경우
    if (minHour < currentTimeList.first) {
      int currentFirst = currentList.first;

      // 최소 시간부터 현재 첫 시간까지 시간 추가
      for (int i = 1; i <= currentFirst - minHour; i++) {
        currentList.insert(0, currentList.first - 1);
      }
    }

    // 최대 시간이 현재 목록의 마지막 시간보다 큰 경우
    if (maxHour > currentList.last) {
      int currentLast = currentList.last;

      // 현재 마지막 시간부터 최대 시간까지 시간 추가
      for (int i = 1; i <= maxHour - currentLast; i++) {
        currentList.add(currentList.last + 1);
      }
    }

    updateTimeList(currentList); // 업데이트된 시간 목록 반영
  }

  // 요일 목록에서 특정 요일을 제거하는 함수
  void removeDayOfWeek(int dayOfWeekIndex, List<TimeNPlaceData> timeNPlaceData) {
    if (dayOfWeekIndex <= DEFAULT_DAY_OF_WEEK_LIST_LAST) {
      return; // 제거할 요일 인덱스가 기본값 이하인 경우 함수 종료
    }

    bool isExist = false; // 제거할 요일이 존재하는지 여부
    int largestIndex = DEFAULT_DAY_OF_WEEK_LIST_LAST; // 가장 큰 요일 인덱스

    // 제거할 요일을 찾고, 존재하는 경우 해당 요일보다 큰 요일 인덱스를 찾음
    for (int i = 0; i < timeNPlaceData.length; i++) {
      if (timeNPlaceData[i].dayOfWeek.index >= DayOfWeek.getByIndex(dayOfWeekIndex).index) {
        isExist = true;
      } else {
        largestIndex = DayOfWeek.getByDayOfWeek(timeNPlaceData[i].dayOfWeek);
      }
    }

    List<DayOfWeek> currentList = currentDayOfWeek;
    if (!isExist) {
      largestIndex = (largestIndex <= DEFAULT_DAY_OF_WEEK_LIST_LAST)
          ? DEFAULT_DAY_OF_WEEK_LIST_LAST
          : largestIndex;

      // 제거할 요일부터 가장 큰 요일까지 제거
      for (int i = (dayOfWeekIndex - largestIndex); i >= 1; i--) {
        currentList.removeLast();
      }
    }
    updateDayOfWeekList(currentList); // 업데이트된 요일 목록 반영
  }

  // 요일을 추가하는 함수
  void addDayOfWeek(int dayOfWeekIndex) {
    // 현재 요일 목록의 길이보다 입력받은 인덱스가 큰 경우에만 처리
    if (dayOfWeekIndex > currentDayOfWeek.length - 1) {
      List<DayOfWeek> currentList = currentDayOfWeek; // 현재 요일 목록 복사
      int currentLength = currentList.length; // 현재 요일 목록의 길이

      // 입력받은 인덱스에 해당하는 요일까지 추가
      for (int i = 1; i <= dayOfWeekIndex - (currentLength - 1); i++) {
        currentList.add(DayOfWeek.getByIndex(currentLength - 1 + i));
      }

      updateDayOfWeekList(currentList); // 업데이트된 요일 목록 반영
    }
  }

  // 성적 관련 데이터 관리 부분

  // 전체 평점을 관리하는 BehaviorSubject
  final _totalGradeAve = BehaviorSubject<double>.seeded(0.0);

  // 전공 평점을 관리하는 BehaviorSubject
  final _majorGradeAve = BehaviorSubject<double>.seeded(0.0);

  // 평점의 최대값을 관리하는 BehaviorSubject (예: 4.5)
  final _maxAve = BehaviorSubject<double>.seeded(4.5);

  // 현재 획득한 학점을 관리하는 BehaviorSubject
  final _currentCredit = BehaviorSubject<int>.seeded(0);

  // 목표 학점을 관리하는 BehaviorSubject
  final _targetCredit = BehaviorSubject<int>.seeded(0);

  // 평점에 대한 점 그래프 데이터를 관리하는 BehaviorSubject
  final _aveData = BehaviorSubject<List<PointChartData>>.seeded([]);

  // 평점에 대한 바 그래프 데이터를 관리하는 BehaviorSubject
  final _percentData = BehaviorSubject<List<BarChartData>>.seeded([]);

  // 각 BehaviorSubject에 대한 스트림과 업데이트 함수
  Stream<double> get totalGradeAve => _totalGradeAve.stream;
  Function(double) get _updateTotalGradeAve => _totalGradeAve.sink.add;
  Stream<double> get majorGradeAve => _majorGradeAve.stream;
  Function(double) get _updateMajorGradeAve => _majorGradeAve.sink.add;
  Stream<double> get maxAve => _maxAve.stream;
  Function(double) get _updateMaxAve => _maxAve.sink.add;

  Stream<int> get currentCredit => _currentCredit.stream;
  Function(int) get _updateCurrentCredit => _currentCredit.sink.add;
  Stream<int> get targetCredit => _targetCredit.stream;
  Function(int) get updateTargetCredit => _targetCredit.sink.add;

  // 학기별 성적 정보를 관리하는 부분

  // 각 학기별 성적 정보를 저장하는 리스트
  final List<GradeOfTerm> _gradeOfTerms = [
    // 각 학년, 학기별 성적 정보 초기화
    GradeOfTerm(term: '1학년 1학기'),
    GradeOfTerm(term: '1학년 2학기'),
    GradeOfTerm(term: '2학년 1학기'),
    GradeOfTerm(term: '2학년 2학기'),
    GradeOfTerm(term: '3학년 1학기'),
    GradeOfTerm(term: '3학년 2학기'),
    GradeOfTerm(term: '4학년 1학기'),
    GradeOfTerm(term: '4학년 2학기'),
    GradeOfTerm(term: '5학년 1학기'),
    GradeOfTerm(term: '5학년 2학기'),
    GradeOfTerm(term: '6학년 1학기'),
    GradeOfTerm(term: '6학년 2학기'),
    GradeOfTerm(term: '기타 학기')
  ];

  // 성적 유형별 총합을 임시 저장할 맵
  Map<GradeType, int> _tempGradesAmount = Map<GradeType, int>.fromIterable(
      GradeType.getGrades(),
      key: (element) => element,
      value: (element) => 0
  );

  // 학기 정보의 길이를 반환하는 getter
  int get getTermsLength => _gradeOfTerms.length;

  // 특정 인덱스의 학기 정보를 반환하는 함수
  GradeOfTerm getTerm(int index) => _gradeOfTerms[index];

  // 특정 인덱스의 학기별 전체 평점을 반환하는 스트림
  Stream<double> getTotalGradeAve(int index) => _gradeOfTerms[index].totalGradeAve;

  // 특정 인덱스의 학기별 전공 평점을 반환하는 스트림
  Stream<double> getMajorGradeAve(int index) => _gradeOfTerms[index].majorGradeAve;

  // 특정 인덱스의 학기별 취득 학점을 반환하는 스트림
  Stream<int> getCreditAmount(int index) => _gradeOfTerms[index].creditAmount;


  // 전체적인 성적 데이터를 최신 상태로 업데이트하는 함수
  void updateData() {
    double tempTotalGrade = 0.0; // 임시 전체 평점
    int tempTotalCredit = 0; // 임시 전체 학점
    double tempMajorGrade = 0.0; // 임시 전공 평점
    int tempMajorCredit = 0; // 임시 전공 학점
    int tempPCredit = 0; // 임시 P학점
    List<PointChartData> tempPointChartDataList = []; // 점 그래프 데이터 목록
    _tempGradesAmount.forEach((key, value) => _tempGradesAmount[key] = 0); // 임시 성적 총합 초기화

    // 모든 학기에 대한 성적 계산
    for (int i = 0; i < _gradeOfTerms.length; i++) {
      tempTotalGrade += getTerm(i).currentTotalGrade;
      tempTotalCredit += getTerm(i).currentTotalCredit;
      tempMajorGrade += getTerm(i).currentMajorGrade;
      tempMajorCredit += getTerm(i).currentMajorCredit;
      tempPCredit += getTerm(i).currentPCredit;

      // 성적 유형별 총합 업데이트
      for (int j = 0; j < GradeType.getGrades().length; j++) {
        _tempGradesAmount.update(GradeType.getByIndex(j),
                (value) => value += getTerm(i).currentGradeAmountsElementAt(j));
      }
    }

    // 전체 평점 및 전공 평점 업데이트
    _updateTotalGradeAve(double.parse(
        (tempTotalGrade / (tempTotalCredit == 0 ? 1 : tempTotalCredit)).toStringAsFixed(2)));
    _updateMajorGradeAve(double.parse(
        (tempMajorGrade / (tempMajorCredit == 0 ? 1 : tempMajorCredit)).toStringAsFixed(2)));
    _updateCurrentCredit(tempTotalCredit + tempPCredit);

    // 점 그래프 데이터 생성
    for (int i = 0; i < getTermsLength; i++) {
      if (getTerm(i).currentTotalGradeAve == 0.0 && getTerm(i).currentMajorGradeAve == 0.0) {
        continue; // 평점이 0인 경우 생략
      }
      tempPointChartDataList.add(PointChartData(
        term: getTerm(i).term,
        totalGrade: (getTerm(i).currentTotalGradeAve == 0.0) ? null : getTerm(i).currentTotalGradeAve,
        majorGrade: (getTerm(i).currentMajorGradeAve == 0.0) ? null : getTerm(i).currentMajorGradeAve,
      ));
    }
    _updateAveData(tempPointChartDataList); // 점 그래프 데이터 업데이트
    _updatePercentData(); // 바 그래프 데이터 업데이트
  }


  // 평점에 대한 점 그래프 데이터 스트림
  Stream<List<PointChartData>> get aveData => _aveData.stream;
  Function(List<PointChartData>) get _updateAveData => _aveData.sink.add;

  // 평점에 대한 바 그래프 데이터 스트림
  Stream<List<BarChartData>> get percentData => _percentData.stream;

  // 바 그래프 데이터를 업데이트하는 함수
  void _updatePercentData() {
    // 성적 유형별 총합을 값에 따라 정렬
    Map<GradeType, int> sortByValue = Map.fromEntries(
        _tempGradesAmount.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value))
    );

    List<BarChartData> tempList = []; // 바 그래프 데이터 목록

    // 상위 5개 성적 유형에 대한 바 그래프 데이터 생성
    for (int i = 0; i < 5; i++) {
      if (sortByValue.values.elementAt(i) == 0) {
        continue; // 성적이 없는 경우 생략
      }

      tempList.add(
        BarChartData(
          percent: (sortByValue.values.elementAt(i) / _currentCredit.value * 100).round(),
          grade: (sortByValue.keys.elementAt(i).data),
        ),
      );
    }

    _percentData.sink.add(tempList); // 업데이트된 바 그래프 데이터 반영
  }

  // 테스트용 성적 데이터를 초기화하는 함수
  void initGradeCalTest() {
    updateTargetCredit(140); // 목표 학점 설정

    // 첫 학기의 각 과목별 성적 정보 설정
    getTerm(0).updateSubject(0, credit: 9, gradeType: GradeType.ap);
    getTerm(0).updateSubject(1, credit: 5, gradeType: GradeType.az);
    getTerm(0).updateSubject(2, credit: 5, gradeType: GradeType.ap, isMajor: true);
    getTerm(0).updateSubject(3, credit: 2, gradeType: GradeType.bp);

    // 두 번째 학기의 각 과목별 성적 정보 설정
    getTerm(1).updateSubject(0, credit: 4, gradeType: GradeType.ap);
    getTerm(1).updateSubject(1, credit: 6, gradeType: GradeType.az);
    getTerm(1).updateSubject(2, credit: 6, gradeType: GradeType.ap, isMajor: true);
    getTerm(1).updateSubject(3, credit: 4, gradeType: GradeType.bz);

    updateData(); // 성적 데이터 업데이트
  }


  // 다크모드 상태를 나타내는 BehaviorSubject
  final _isDark = BehaviorSubject<bool>.seeded(false);

  // 키보드 표시 여부를 나타내는 BehaviorSubject
  final _isShowingKeyboard = BehaviorSubject<bool>.seeded(false);

  // 현재 학기를 나타내는 문자열을 저장하는 BehaviorSubject
  final _termString = BehaviorSubject<String>();

  // 각 BehaviorSubject에 대한 스트림과 업데이트 함수
  Stream<bool> get isDark => _isDark.stream;
  Function(bool) get updateIsDark => _isDark.sink.add;

  Stream<bool> get isShowingKeyboard => _isShowingKeyboard.stream;
  Function(bool) get updateIsShowingKeyboard => _isShowingKeyboard.sink.add;

  // 현재 키보드 표시 상태를 반환하는 getter
  bool get currentIsShowingKeyboard => _isShowingKeyboard.value;

  // 현재 학기 문자열에 대한 스트림
  Stream<String> get termString => _termString.stream;

  // 현재 시간을 기반으로 학기 문자열을 갱신하는 함수
  void updateTermString() {
    DateTime now = DateTime.now();
    String term; // 학기를 나타내는 문자열

    // 월별로 학기 결정
    if (now.month >= 3 && now.month <= 6) {
      term = '1학기';
    } else if (now.month >= 7 && now.month <= 8) {
      term = '여름학기';
    } else if (now.month >= 9 && now.month <= 12) {
      term = '2학기';
    } else {
      term = '겨울학기';
    }

    _termString.sink.add("${now.year}년 $term"); // 업데이트된 학기 문자열 반영
  }

  // 현재 학기 문자열을 반환하는 getter
  String get currentTermString => _termString.value;

  // 클래스의 리소스를 해제하는 함수
  void dispose() {
    // 각 BehaviorSubject의 리소스 해제
    _name.close();
    _univ.close();
    _nickName.close();
    _id.close();
    _year.close();

    // 시간표 관련 리소스 해제
    for (int i = 0; i < _timeTableList.value.length; i++) {
      _timeTableList.value[i].dispose();
    }
    _timeTableList.close();
    _selectedTimeTable.close();
    _timeList.close();
    _dayOfWeekList.close();

    // 성적 관련 리소스 해제
    _totalGradeAve.close();
    _majorGradeAve.close();
    _maxAve.close();
    _currentCredit.close();
    _targetCredit.close();
    for (int i = 0; i < _gradeOfTerms.length; i++) {
      _gradeOfTerms[i].dispose();
    }
    _aveData.close();
    _percentData.close();

    // 시스템 관련 리소스 해제
    _isDark.close();
    _isShowingKeyboard.close();
    _termString.close();
  }
}