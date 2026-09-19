import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class AppScreenScale {
  const AppScreenScale._(this.scale);

  final double scale;

  factory AppScreenScale.fromConstraints(
    BoxConstraints constraints, {
    double designWidth = 360,
    double designHeight = 780,
    double minScale = 0.82,
    double maxScale = 1.5,
  }) {
    final widthScale = constraints.maxWidth / designWidth;
    final heightScale = constraints.maxHeight / designHeight;
    final scale = math.min(widthScale, heightScale).clamp(minScale, maxScale);

    return AppScreenScale._(scale);
  }

  bool get isCompact => scale < 0.92;

  double v(double value) => value * scale;
}
