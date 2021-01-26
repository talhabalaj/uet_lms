import 'package:flutter/material.dart';
import 'package:uet_lms/core/utils.dart';

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
      color: Theme.of(context).accentColor,
      backgroundColor: Theme.of(context).cardColor,
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: height ??
                (MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    (isMobile() ? 30 : 0)),
          ),
          child: child,
        ),
      ),
    );
  }
}
