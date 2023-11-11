import 'package:flutter/material.dart';

/// 과목 타입
enum SubjectType {
  LiberalArtsSelect,    // 교양 선택
  LiberalArtsEssential, // 교양 필수
  MajorSelect,          // 전공 선택
  MajorEssential        // 전공 필수
}

/// 요일
enum Weekday {
  Undefined('?'),
  Monday('월'),
  Tuesday('화'),
  Wednesday('수'),
  Thursday('목'),
  Friday('금'),
  Saturday('토'),
  Sunday('일');

  const Weekday(this.label);

  final String label;

  static List<Weekday> get weekdays => Weekday.values;

  static Weekday byIndex(int index) => Weekday.values[index];
}

/// 성적 종류
enum Grade {
  AP('A+', 4.5),
  A('A0', 4.0),
  BP('B+', 3.5),
  B('B0', 3.0),
  CP('C+', 2.5),
  C('C0', 2.0),
  DP('D+', 1.5),
  D('D0', 1.0),
  F('F', 0.0),
  P('P', 0.0),
  NP('NP', 0.0),
  Undefined('undefined', 0.0);

  const Grade(this.label, this.point);

  final String label;
  final double point;

  static List<Grade> get allGrades => Grade.values;

  static Grade byIndex(int index) => Grade.values[index];
}
