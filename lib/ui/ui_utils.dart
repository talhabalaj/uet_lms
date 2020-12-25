import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  if (per >= 75) {
    return Colors.green;
  } else if (per >= 55) {
    return Colors.orange;
  } else if (per <= 55) {
    return Colors.red;
  }
  return Colors.yellow;
}
