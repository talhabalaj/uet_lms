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
  Color cur = locator<ThemeService>().theme.accentColor;
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
