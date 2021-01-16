import 'package:flutter/material.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/ui_constants.dart';

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
      color: Theme.of(context).primaryColor,
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
