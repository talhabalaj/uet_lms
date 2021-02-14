import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/ThemeService.dart';

Color getPerColor(double per) {
  Color cur = I<ThemeService>().theme.accentColor;
  if (per >= 55 && per < 75) {
    return lighten(cur, .1);
  } else if (per <= 55) {
    return lighten(cur, .2);
  }
  return cur;
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}


Color withStaticAlpha(Color color, Color background) {
  double alpha = color.alpha / 255;
  double oneminusalpha = 1 - alpha;

  int newR = ((color.red * alpha) + (oneminusalpha * background.red)).toInt();
  int newG = ((color.green * alpha) + (oneminusalpha * background.green)).toInt();
  int newB = ((color.blue * alpha) + (oneminusalpha * background.blue)).toInt();

  return Color.fromARGB(255, newR, newB, newG);
}