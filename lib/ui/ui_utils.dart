import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/ThemeService.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';

Widget loading({int count = 4}) {
  return Column(
    children: [
      for (int i = 0; i < 4; i++)
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: CustomCard(
            loading: true,
          ),
        ),
    ],
  );
}

Color getPerColor(double per) {
  if (per >= 55 && per < 75) {
    return Colors.orange;
  } else if (per <= 55) {
    return Colors.red;
  }
  return locator<ThemeService>().theme.accentColor;
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