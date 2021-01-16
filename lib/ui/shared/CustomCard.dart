import 'package:flutter/material.dart';
import 'package:uet_lms/ui/ui_constants.dart';

import 'RepeatedShimmer.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key key,
    this.builder,
    this.height,
    this.padding,
    this.width,
    this.shimmerCount,
    this.loading = false,
    this.boxShadow,
  }) : super(key: key);

  final double height;
  final double width;
  final Widget Function(BuildContext) builder;
  final EdgeInsets padding;
  final bool loading;
  final int shimmerCount;
  final List<BoxShadow> boxShadow;

  @override
  Widget build(BuildContext context) {
    final boxShadow = this.boxShadow ?? [kFavBoxShadow];

    return Container(
      height: height,
      width: width ?? double.infinity,
      child: Padding(
        padding: padding ?? EdgeInsets.all(17.0),
        child: loading
            ? RepeatedShimmer(
                repeated: shimmerCount ?? 2,
              )
            : builder(context),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}
