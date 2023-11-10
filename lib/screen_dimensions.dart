import 'dart:ui';


// 디바이스의 픽셀 밀도
final double devicePixelRatio = window.devicePixelRatio;

// 디바이스의 물리적 화면 크기
final Size physicalSize = window.physicalSize;

// 화면 여백
final screenPadding = window.padding;
final topPadding = window.padding.top / devicePixelRatio;
final bottomPadding = window.padding.bottom / devicePixelRatio;

// 실제 사용 가능한 화면 높이와 너비
final double usableScreenHeight = physicalSize.height / devicePixelRatio;
final double usableScreenWidth = physicalSize.width / devicePixelRatio;

// 애플리케이션에서 사용 가능한 화면 높이 (상단 여백 제외)
final double availableHeight = usableScreenHeight - topPadding;

// 애플리케이션에서 사용 가능한 화면 너비
final double availableWidth = usableScreenWidth;
