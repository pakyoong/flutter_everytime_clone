import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // 생성자에서 다양한 매개변수를 받아 커스텀 텍스트 필드를 설정
  const CustomTextField({
    super.key,
    this.controller, // 텍스트 필드의 컨트롤러
    this.maxLines, // 최대 줄 수
    this.autofocus = false, // 자동 포커스 여부
    this.scrollPadding = const EdgeInsets.all(20), // 스크롤 패딩
    this.textInputAction = TextInputAction.done, // 키보드 액션
    this.hintText, // 힌트 텍스트
    this.isDense, // 밀집 여부
    this.isHintBold = false, // 힌트 텍스트의 볼드 여부
    this.onTap, // 탭 이벤트 핸들러
    this.onChanged, // 텍스트 변경 이벤트 핸들러
    this.onSubmitted, // 제출 이벤트 핸들러
  });

  final TextEditingController? controller;
  final int? maxLines;
  final bool autofocus;
  final EdgeInsets scrollPadding;
  final TextInputAction textInputAction;
  final String? hintText;
  final bool? isDense;
  final bool isHintBold;
  final Function? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      scrollPadding: scrollPadding,
      textInputAction: textInputAction,
      autofocus: autofocus,
      decoration: InputDecoration(
        isDense: isDense,
        border: InputBorder.none, // 테두리 없음
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 21,
          fontWeight: isHintBold ? FontWeight.bold : FontWeight.normal, // 힌트 텍스트 스타일
        ),
      ),
      style: const TextStyle(
        fontSize: 21, // 기본 텍스트 스타일
      ),
      cursorColor: Theme.of(context).focusColor, // 커서 색상
      onChanged: (value) {
        onChanged?.call(value); // 텍스트 변경 시 이벤트 처리
      },
      onTap: () {
        onTap?.call(); // 탭 시 이벤트 처리
      },
      onSubmitted: (value) {
        onSubmitted?.call(value); // 제출 시 이벤트 처리
      },
    );
  }
}