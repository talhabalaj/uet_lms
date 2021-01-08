import 'package:flutter/material.dart';
import 'package:uet_lms/ui/ui_constants.dart';

class NestedNavigation extends StatelessWidget {
  const NestedNavigation({
    Key key,
    this.children,
    this.onRefresh,
  }) : super(key: key);

  final List<Widget> children;
  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(children: [
        SizedBox(
          height: kAppBarHeight,
        ),
        ...children,
      ]),
    );
  }
}
