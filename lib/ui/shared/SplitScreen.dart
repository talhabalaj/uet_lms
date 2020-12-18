import 'package:flutter/material.dart';

class SplitScreen extends StatelessWidget {
  const SplitScreen({
    Key key,
    @required this.leftView,
    this.rightView,
  }) : super(key: key);

  final Widget leftView;
  final Widget rightView;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          flex: 5,
          child: Container(
            constraints:
                rightView != null ? null : BoxConstraints(maxWidth: 500),
            child: leftView,
          ),
        ),
        if (rightView != null && MediaQuery.of(context).size.width > 675) ...[
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 7,
            child: rightView,
          )
        ]
      ],
    );
  }
}
