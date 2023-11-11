import 'dart:ui';

// 디바이스의 픽셀 밀도를 나타냅니다.
final double devicePixelRatio = window.devicePixelRatio;

// 디바이스의 물리적 화면 크기를 나타냅니다.
final Size physicalSize = window.physicalSize;

// 화면의 여백 정보를 나타냅니다.
final screenPadding = window.padding;
final topPadding = window.padding.top / devicePixelRatio;
final bottomPadding = window.padding.bottom / devicePixelRatio;

// 실제 앱에서 사용 가능한 화면의 높이와 너비를 계산합니다.
// 여기서 devicePixelRatio를 사용하여 물리적 크기를 실제 사용 가능한 크기로 변환합니다.
final double usableScreenHeight = physicalSize.height / devicePixelRatio;
final double usableScreenWidth = physicalSize.width / devicePixelRatio;

// 상단 여백을 제외한 애플리케이션에서 사용 가능한 화면 높이를 계산합니다.
final double availableHeight = usableScreenHeight - topPadding;

// 애플리케이션에서 사용 가능한 화면 너비를 나타냅니다.
final double availableWidth = usableScreenWidth;