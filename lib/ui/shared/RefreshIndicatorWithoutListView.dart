import 'package:flutter/material.dart';


class RefreshIndicatorWithoutListView extends StatelessWidget {
  RefreshIndicatorWithoutListView(
      {Key key, this.onRefresh, this.child, this.height})
      : super(key: key);

  final Function onRefresh;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight:
                  height ?? MediaQuery.of(context).size.height),
          child: child,
        ),
      ),
    );
  }
}
