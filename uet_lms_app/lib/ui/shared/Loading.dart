import 'package:flutter/material.dart';

import 'CustomCard.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key key,
    this.count = 4,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < count; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: CustomCard(
              builder: null,
              loading: true,
            ),
          ),
      ],
    );
  }
}
