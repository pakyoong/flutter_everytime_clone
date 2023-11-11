import 'dart:math';

import '../model/Enums.dart';
import '../model/TermGradeManager.dart';
import '../model/TimeTableDataModels.dart';
import 'package:rxdart/subjects.dart';

class EverytimeUserBloc {

  final _name = BehaviorSubject<String>();

  final _univ = BehaviorSubject<String>();

  final _nickName = BehaviorSubject<String>();

  final _id = BehaviorSubject<String>();

  final _year = BehaviorSubject<int>();

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

  final _ScheduleList = BehaviorSubject<List<Schedule>>.seeded([]);

  final _selectedSchedule = BehaviorSubject<Schedule?>.seeded(null);

  Stream<List<Schedule>> get scheduleList => _ScheduleList.stream;
  Stream<Schedule?> get selectedSchedule => _selectedSchedule.stream;

  Function(List<Schedule>) get _updateSchedule => _ScheduleList.sink.add;
  Function(Schedule?) get updateSelectedSchedule =>
      _selectedSchedule.sink.add;

  List<Schedule> get currentScheduleList => _ScheduleList.value;
  Schedule? get currentSelectedSchedule => _selectedSchedule.value;

  Schedule? findScheduleAtSpecificTerm(String term) {
    List<Schedule> scheduleList = currentScheduleList;
    Schedule? secondSchedule;

    for (Schedule schedule in scheduleList) {
      if (schedule.term == term) {
        if (schedule.isPrimarySchedule) {
          return schedule;
        }

        if (secondSchedule == null) {
          secondSchedule = schedule;
          secondSchedule.updateIsPrimary(true);

          break;
        }
      }
    }

    return secondSchedule;
  }

  void removeScheduleDataAt(
      int currentIndex,
      List<ClassSchedule> classSchedule,
      ) {
    int tempWeekdayIndex = defaultDayOfWeekListLast;
    int tempStartHour = defaultTimeListFirst;
    int tempEndHour = defaultTimeListLast;

    int removeDayOfWeekIndex = defaultDayOfWeekListLast;
    int removeStartHour = defaultTimeListFirst;
    int removeEndHour = defaultTimeListLast;

    for (int i = 0; i < classSchedule.length; i++) {
      for (ClassTimeAndLocation times in classSchedule[i].times) {
        if (i == currentIndex) {
          if (removeDayOfWeekIndex <
              Weekday.indexOfWeekday(times.weekday)) {
            removeDayOfWeekIndex = Weekday.indexOfWeekday(times.weekday);
          }

          if (removeStartHour > times.startHour) {
            removeStartHour = times.startHour;
          }

          if (removeEndHour < times.endHour) {
            removeEndHour = times.endHour;
          }
        } else {
          if (tempWeekdayIndex < Weekday.indexOfWeekday(times.weekday)) {
            tempWeekdayIndex = Weekday.indexOfWeekday(times.weekday);
          }

          if (tempStartHour > times.startHour) {
            tempStartHour = times.startHour;
          }

          if (tempEndHour < times.endHour) {
            tempEndHour = times.endHour;
          }
        }
      }
    }

    currentSelectedSchedule!.removeClass(currentIndex);

    removeDayOfWeek(
      removeDayOfWeekIndex,
      [
        ClassTimeAndLocation(
          weekday: Weekday.weekdayAtIndex(tempWeekdayIndex),
          startHour: tempStartHour,
          endHour: tempEndHour,
        ),
      ],
    );
    removeTimeList(
      removeStartHour,
      removeEndHour,
      [
        ClassTimeAndLocation(
          weekday: Weekday.weekdayAtIndex(tempWeekdayIndex),
          startHour: tempStartHour,
          endHour: tempEndHour,
        ),
      ],
    );
  }
  String? checkTimeTableCrash(ClassSchedule data) {
    String? result;

    // 입력한 값들과 비교
    for (int oldIndex = 0; oldIndex < data.times.length; oldIndex++) {
      ClassTimeAndLocation oldData = data.times[oldIndex];
      for (int newIndex = 0; newIndex < data.times.length; newIndex++) {
        if (oldIndex == newIndex) {
          continue;
        }

        ClassTimeAndLocation newData = data.times[newIndex];

        if (oldData.weekday == newData.weekday) {
          DateTime newStartTime =
          DateTime(1970, 1, 1, newData.startHour, newData.startMinute);
          DateTime newEndTime =
          DateTime(1970, 1, 1, newData.endHour, newData.endMinute);
          DateTime oldStartTime =
          DateTime(1970, 1, 1, oldData.startHour, oldData.startMinute);
          DateTime oldEndTime =
          DateTime(1970, 1, 1, oldData.endHour, oldData.endMinute);

          int oldPlayTime = oldEndTime.difference(oldStartTime).inMinutes;

          if (newStartTime.difference(oldStartTime).inMinutes >= oldPlayTime) {
            /* do nothing */
          } else if (oldEndTime.difference(newEndTime).inMinutes >=
              oldPlayTime) {
            /* do nothing */
          } else {
            result = '입력 받은';
            break;
          }
        }
      }
    }

    if (result != null) {
      return result;
    }

    // 전체 시간표와 비교
    for (ClassSchedule timeTableData
    in currentSelectedSchedule!.currentScheduleData) {
      for (ClassTimeAndLocation oldData in timeTableData.times) {
        for (ClassTimeAndLocation newData in data.times) {
          if (oldData.weekday == newData.weekday) {
            DateTime newStartTime =
            DateTime(1970, 1, 1, newData.startHour, newData.startMinute);
            DateTime newEndTime =
            DateTime(1970, 1, 1, newData.endHour, newData.endMinute);
            DateTime oldStartTime =
            DateTime(1970, 1, 1, oldData.startHour, oldData.startMinute);
            DateTime oldEndTime =
            DateTime(1970, 1, 1, oldData.endHour, oldData.endMinute);

            int oldPlayTime = oldEndTime.difference(oldStartTime).inMinutes;

            if (newStartTime.difference(oldStartTime).inMinutes >=
                oldPlayTime) {
              /* do nothing */
            } else if (oldEndTime.difference(newEndTime).inMinutes >=
                oldPlayTime) {
              /* do nothing */
            } else {
              result = timeTableData.className;
              break;
            }
          }
        }
      }

      if (result != null) {
        break;
      }
    }

    return result;
  }

  void removeTimeTableList(String termString, String name) {
    Map<String, dynamic> result = findTimeTable(termString, name);

    if (result['timeTable'] == null || result['index'] == null) return;

    List<Schedule> tempTimeTableList = currentScheduleList;
    tempTimeTableList.removeAt(result['index']);
    _updateSchedule(tempTimeTableList);
  }

  void addTimeTableList(Schedule newTimeTable) {
    List<Schedule> tempList = currentScheduleList;
    tempList.add(newTimeTable);
    _ScheduleList.add(tempList);
  }

  void updateTimeTableList(
      String termString,
      String name, {
        String? newName,
        List<ClassSchedule>? timeTableData,
        bool? isDefault,
      }) {
    Map<String, dynamic> result = findTimeTable(termString, name);

    if (result['timeTable'] == null || result['index'] == null) return;

    if (newName != null) result['timeTable'].updateName(newName);
    if (timeTableData != null) {
      result['timeTable'].updateTimeTableData(timeTableData);
    }
    if (isDefault != null) result['timeTable'].updateIsDefault(isDefault);

    if (newName != null ||
        timeTableData != null ||
        isDefault != null) {
      List<Schedule> tempTimeTableList = currentScheduleList;
      tempTimeTableList.replaceRange(
        result['index'],
        result['index'] + 1,
        [result['timeTable']],
      );
      _updateSchedule(tempTimeTableList);
    }
  }

  Map<String, dynamic> findTimeTable(String term, String name) {
    Schedule? tempTimeTable;
    int? tempIndex;
    for (int i = 0; i < currentScheduleList.length; i++) {
      if (currentScheduleList[i].currentTitle == name &&
          currentScheduleList[i].term == term) {
        tempTimeTable = currentScheduleList[i];
        tempIndex = i;
      }
    }

    return {'timeTable': tempTimeTable, 'index': tempIndex};
  }

  // ignore: constant_identifier_names
  static const DEFAULT_TIME_LIST_LENGTH = 7;
  int get defaultTimeListLength => DEFAULT_TIME_LIST_LENGTH;

  // ignore: constant_identifier_names
  static const DEFAULT_TIME_LIST_FIRST = 9;
  int get defaultTimeListFirst => DEFAULT_TIME_LIST_FIRST;

  // ignore: constant_identifier_names
  static const DEFAULT_TIME_LIST_LAST = 15;
  int get defaultTimeListLast => DEFAULT_TIME_LIST_LAST;

  // ignore: constant_identifier_names
  static const DEFAULT_DAY_OF_WEEK_LIST_LAST = 4;
  int get defaultDayOfWeekListLast => DEFAULT_DAY_OF_WEEK_LIST_LAST;

  final _timeList =
  BehaviorSubject<List<int>>.seeded([9, 10, 11, 12, 13, 14, 15]);

  /// 시간표의 요일 부분을 저장할 변수
  final _dayOfWeekList = BehaviorSubject<List<Weekday>>.seeded([
    Weekday.Monday,
    Weekday.Tuesday,
    Weekday.Wednesday,
    Weekday.Thursday,
    Weekday.Friday,
  ]);

  Stream<List<int>> get timeList => _timeList.stream;
  Stream<List<Weekday>> get dayOfWeek => _dayOfWeekList.stream;

  Function(List<int>) get updateTimeList => _timeList.sink.add;
  Function(List<Weekday>) get updateDayOfWeekList => _dayOfWeekList.sink.add;

  List<int> get currentTimeList => _timeList.value;
  List<Weekday> get currentDayOfWeek => _dayOfWeekList.value;

  void removeTimeList(
      int startHour, int endHour, List<ClassTimeAndLocation> classTimeAndLocation) {
    int minHour = min(startHour, endHour);
    int maxHour = max(startHour, endHour);
    bool minCheck = false;
    bool maxCheck = false;

    if (minHour >= DEFAULT_TIME_LIST_FIRST) {
      minCheck = true;
    }
    if (maxHour <= DEFAULT_TIME_LIST_LAST) {
      maxCheck = true;
    }
    if (minCheck && maxCheck) return;

    bool isSmallExist = false;
    bool isLargeExist = false;
    int largestHour = DEFAULT_TIME_LIST_LAST;
    int smallestHour = DEFAULT_TIME_LIST_FIRST;

    for (int i = 0; i < classTimeAndLocation.length; i++) {
      if (min(classTimeAndLocation[i].startHour, classTimeAndLocation[i].endHour) <=
          minHour) {
        isSmallExist = true;
      } else {
        if (smallestHour >=
            min(classTimeAndLocation[i].startHour, classTimeAndLocation[i].endHour)) {
          smallestHour =
              min(classTimeAndLocation[i].startHour, classTimeAndLocation[i].endHour);
        }
      }

      if (max(classTimeAndLocation[i].startHour, classTimeAndLocation[i].endHour) >=
          maxHour) {
        isLargeExist = true;
      } else {
        if (largestHour <=
            max(classTimeAndLocation[i].startHour, classTimeAndLocation[i].endHour)) {
          largestHour =
              max(classTimeAndLocation[i].startHour, classTimeAndLocation[i].endHour);
        }
      }
    }

    List<int> currentList = currentTimeList;
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

    updateTimeList(currentList);
  }

  void addTimeList(int startHour, int endHour) {
    int maxHour = max(startHour, endHour);
    int minHour = min(startHour, endHour);
    List<int> currentList = currentTimeList;

    if (minHour < currentTimeList.first) {
      int currentFirst = currentList.first;

      for (int i = 1; i <= currentFirst - minHour; i++) {
        currentList.insert(0, currentList.first - 1);
      }
    }

    if (maxHour > currentList.last) {
      int currentLast = currentList.last;

      for (int i = 1; i <= maxHour - currentLast; i++) {
        currentList.add(currentList.last + 1);
      }
    }

    updateTimeList(currentList);
  }

  void removeDayOfWeek(
      int dayOfWeekIndex, List<ClassTimeAndLocation> classTimeAndLocation) {
    if (dayOfWeekIndex <= DEFAULT_DAY_OF_WEEK_LIST_LAST) {
      return;
    }

    bool isExist = false;
    int largestIndex = DEFAULT_DAY_OF_WEEK_LIST_LAST;

    for (int i = 0; i < classTimeAndLocation.length; i++) {
      if (classTimeAndLocation[i].weekday.index >=
          Weekday.weekdayAtIndex(dayOfWeekIndex).index) {
        isExist = true;
      } else {
        largestIndex = Weekday.indexOfWeekday(classTimeAndLocation[i].weekday);
      }
    }

    List<Weekday> currentList = currentDayOfWeek;
    if (!isExist) {
      largestIndex = (largestIndex <= DEFAULT_DAY_OF_WEEK_LIST_LAST)
          ? DEFAULT_DAY_OF_WEEK_LIST_LAST
          : largestIndex;

      for (int i = (dayOfWeekIndex - largestIndex); i >= 1; i--) {
        currentList.removeLast();
      }
    }
    updateDayOfWeekList(currentList);
  }

  void addDayOfWeek(int dayOfWeekIndex) {
    if (dayOfWeekIndex > currentDayOfWeek.length - 1) {
      List<Weekday> currentList = currentDayOfWeek;
      int currentLength = currentList.length;

      for (int i = 1; i <= dayOfWeekIndex - (currentLength - 1); i++) {
        currentList.add(Weekday.weekdayAtIndex(currentLength - 1 + i));
      }

      updateDayOfWeekList(currentList);
    }
  }

  final _totalGradeAve = BehaviorSubject<double>.seeded(0.0);

  final _majorGradeAve = BehaviorSubject<double>.seeded(0.0);

  final _maxAve = BehaviorSubject<double>.seeded(4.5);

  final _currentCredit = BehaviorSubject<int>.seeded(0);

  final _targetCredit = BehaviorSubject<int>.seeded(0);

  final _aveData = BehaviorSubject<List<TermGradePointData>>.seeded([]);

  /// 바 그래프 데이터
  final _percentData = BehaviorSubject<List<GradeDistributionData>>.seeded([]);

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

  /// 학기의 성적 정보
  final List<TermGrades> _gradeOfTerms = [
    TermGrades(
      termName: '1학년 1학기',
    ),
    TermGrades(
      termName: '1학년 2학기',
    ),
    TermGrades(
      termName: '2학년 1학기',
    ),
    TermGrades(
      termName: '2학년 2학기',
    ),
    TermGrades(
      termName: '3학년 1학기',
    ),
    TermGrades(
      termName: '3학년 2학기',
    ),
    TermGrades(
      termName: '4학년 1학기',
    ),
    TermGrades(
      termName: '4학년 2학기',
    ),
    TermGrades(
      termName: '5학년 1학기',
    ),
    TermGrades(
      termName: '5학년 2학기',
    ),
    TermGrades(
      termName: '6학년 1학기',
    ),
    TermGrades(
      termName: '6학년 2학기',
    ),
    TermGrades(
      termName: '기타 학기',
    ),
  ];

  // ignore: prefer_for_elements_to_map_fromiterable, prefer_final_fields
  Map<Grade, int> _tempGradesAmount = Map<Grade, int>.fromIterable(
      Grade.allGrades(),
      key: (element) => element,
      value: (element) => 0);

  int get getTermsLength => _gradeOfTerms.length;
  TermGrades getTerm(int index) => _gradeOfTerms[index];
  Stream<double> getTotalGradeAve(int index) =>
      _gradeOfTerms[index].totalGradeAve;
  Stream<double> getMajorGradeAve(int index) =>
      _gradeOfTerms[index].majorGradeAve;
  Stream<int> getCreditAmount(int index) => _gradeOfTerms[index].creditAmount;

  void updateData() {
    double tempTotalGrade = 0.0;
    int tempTotalCredit = 0;
    double tempMajorGrade = 0.0;
    int tempMajorCredit = 0;
    int tempPCredit = 0;
    List<TermGradePointData> tempPointChartDataList = [];
    _tempGradesAmount.forEach(
          (key, value) => _tempGradesAmount[key] = 0,
    );

    for (int i = 0; i < _gradeOfTerms.length; i++) {
      tempTotalGrade += getTerm(i).currentTotalGrade;
      tempTotalCredit += getTerm(i).currentTotalCredit;
      tempMajorGrade += getTerm(i).currentMajorGrade;
      tempMajorCredit += getTerm(i).currentMajorCredit;
      tempPCredit += getTerm(i).currentPCredit;
      for (int j = 0; j < Grade.allGrades().length; j++) {
        _tempGradesAmount.update(Grade.getByIndex(j),
                (value) => value += getTerm(i).currentGradeAmountsElementAt(j));
      }
    }

    _updateTotalGradeAve(double.parse(
        (tempTotalGrade / (tempTotalCredit == 0 ? 1 : tempTotalCredit))
            .toStringAsFixed(2)));
    _updateMajorGradeAve(double.parse(
        (tempMajorGrade / (tempMajorCredit == 0 ? 1 : tempMajorCredit))
            .toStringAsFixed(2)));
    _updateCurrentCredit(tempTotalCredit + tempPCredit);

    for (int i = 0; i < getTermsLength; i++) {
      if (getTerm(i).currentTotalGradeAve == 0.0 &&
          getTerm(i).currentMajorGradeAve == 0.0) {
        continue;
      }
      tempPointChartDataList.add(TermGradePointData(
        term: getTerm(i).termName,
        overallGPA: (getTerm(i).currentTotalGradeAve == 0.0)
            ? null
            : getTerm(i).currentTotalGradeAve,
        majorGPA: (getTerm(i).currentMajorGradeAve == 0.0)
            ? null
            : getTerm(i).currentMajorGradeAve,
      ));
    }
    _updateAveData(tempPointChartDataList);
    _updatePercentData();
  }

  Stream<List<TermGradePointData>> get aveData => _aveData.stream;
  Function(List<TermGradePointData>) get _updateAveData => _aveData.sink.add;

  Stream<List<GradeDistributionData>> get percentData => _percentData.stream;

  void _updatePercentData() {
    Map<Grade, int> sortByValue = Map.fromEntries(
        _tempGradesAmount.entries.toList()
          ..sort((e1, e2) => e2.value.compareTo(e1.value)));

    List<GradeDistributionData> tempList = [];

    for (int i = 0; i < 5; i++) {
      if (sortByValue.values.elementAt(i) == 0) {
        continue;
      }

      tempList.add(
        GradeDistributionData(
          percentage:
          (sortByValue.values.elementAt(i) / _currentCredit.value * 100)
              .round(),
          gradeLabel: (sortByValue.keys.elementAt(i).label),
        ),
      );
    }

    _percentData.sink.add(tempList);
  }
  void initGradeCalTest() {
    updateTargetCredit(140);

    getTerm(0).updateSubject(
      0,
      courseCredits: 9,
      courseGrade: Grade.AP,
    );
    getTerm(0).updateSubject(
      1,
      courseCredits: 5,
      courseGrade: Grade.A,
    );
    getTerm(0).updateSubject(
      2,
      courseCredits: 5,
      courseGrade: Grade.AP,
      isMajorCourse: true,
    );
    getTerm(0).updateSubject(
      3,
      courseCredits: 2,
      courseGrade: Grade.BP,
    );

    getTerm(1).updateSubject(
      0,
      courseCredits: 4,
      courseGrade: Grade.BP,
    );
    getTerm(1).updateSubject(
      1,
      courseCredits: 6,
      courseGrade: Grade.A,
    );
    getTerm(1).updateSubject(
      2,
      courseCredits: 6,
      courseGrade: Grade.AP,
      isMajorCourse: true,
    );
    getTerm(1).updateSubject(
      3,
      courseCredits: 4,
      courseGrade: Grade.B,
    );

    updateData();
  }

  final _isDark = BehaviorSubject<bool>.seeded(false);

  final _isShowingKeyboard = BehaviorSubject<bool>.seeded(false);

  final _termString = BehaviorSubject<String>();

  Stream<bool> get isDark => _isDark.stream;
  Function(bool) get updateIsDark => _isDark.sink.add;

  Stream<bool> get isShowingKeyboard => _isShowingKeyboard.stream;
  Function(bool) get updateIsShowingKeyboard => _isShowingKeyboard.sink.add;

  bool get currentIsShowingKeyboard => _isShowingKeyboard.value;

  Stream<String> get termString => _termString.stream;

  void updateTermString() {
    DateTime now = DateTime.now();
    String term;

    if (now.month >= 3 && now.month <= 6) {
      term = '1학기';
    } else if (now.month >= 7 && now.month <= 8) {
      term = '여름학기';
    } else if (now.month >= 9 && now.month <= 12) {
      term = '2학기';
    } else {
      term = '겨울학기';
    }

    _termString.sink.add("${now.year}년 $term");
  }

  String get currentTermString => _termString.value;


  void dispose() {
    _name.close();
    _univ.close();
    _nickName.close();
    _id.close();
    _year.close();


    for (int i = 0; i < _ScheduleList.value.length; i++) {
      _ScheduleList.value[i].dispose();
    }
    _ScheduleList.close();
    _selectedSchedule.close();

    _timeList.close();
    _dayOfWeekList.close();

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

    _isDark.close();
    _isShowingKeyboard.close();
    _termString.close();
  }
}