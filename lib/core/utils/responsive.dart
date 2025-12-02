import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late final MediaQueryData _mediaQuery;
  late final double _screenWidth;
  late final double _screenHeight;
  late final Orientation _orientation;

  Responsive(this.context) {
    _mediaQuery = MediaQuery.of(context);
    _screenWidth = _mediaQuery.size.width;
    _screenHeight = _mediaQuery.size.height;
    _orientation = _mediaQuery.orientation;
  }

  // Screen dimensions
  double get width => _screenWidth;
  double get height => _screenHeight;
  double get aspectRatio => _screenWidth / _screenHeight;
  Orientation get orientation => _orientation;
  bool get isPortrait => _orientation == Orientation.portrait;
  bool get isLandscape => _orientation == Orientation.landscape;

  // Device type detection
  bool get isMobile => _screenWidth < 600;
  bool get isTablet => _screenWidth >= 600 && _screenWidth < 900;
  bool get isDesktop => _screenWidth >= 900;
  bool get isSmallPhone => _screenWidth < 360;
  bool get isMediumPhone => _screenWidth >= 360 && _screenWidth < 400;
  bool get isLargePhone => _screenWidth >= 400 && _screenWidth < 600;

  // Responsive sizing
  double wp(double percentage) => _screenWidth * percentage / 100;
  double hp(double percentage) => _screenHeight * percentage / 100;

  // Responsive font sizing
  double sp(double size) {
    final baseWidth = 375.0; // iPhone 11 Pro width as base
    final scale = _screenWidth / baseWidth;
    return size * scale.clamp(0.8, 1.3);
  }

  // Responsive spacing
  double spacing(double base) {
    if (isSmallPhone) return base * 0.8;
    if (isTablet) return base * 1.2;
    if (isDesktop) return base * 1.5;
    return base;
  }

  // Responsive padding
  EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsets.only(
      left: spacing(left ?? horizontal ?? all ?? 0),
      top: spacing(top ?? vertical ?? all ?? 0),
      right: spacing(right ?? horizontal ?? all ?? 0),
      bottom: spacing(bottom ?? vertical ?? all ?? 0),
    );
  }

  // Responsive border radius
  double radius(double base) => spacing(base);

  // Safe area insets
  EdgeInsets get safeAreaPadding => _mediaQuery.padding;
  double get topSafeArea => _mediaQuery.padding.top;
  double get bottomSafeArea => _mediaQuery.padding.bottom;

  // Text scale factor
  double get textScaleFactor => _mediaQuery.textScaler.scale(1.0).clamp(0.8, 1.3);

  // Pixel density
  double get pixelRatio => _mediaQuery.devicePixelRatio;

  // Static helper
  static Responsive of(BuildContext context) => Responsive(context);
}

// Extension for easy access
extension ResponsiveExtension on BuildContext {
  Responsive get responsive => Responsive(this);
}
