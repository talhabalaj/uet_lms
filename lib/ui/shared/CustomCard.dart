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
  }) : super(key: key);

  final double height;
  final double width;
  final Widget Function(BuildContext) builder;
  final EdgeInsets padding;
  final bool loading;
  final int shimmerCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      child: Padding(
        padding: padding ?? EdgeInsets.all(15.0),
        child: loading ? RepeatedShimmer(repeated: shimmerCount ?? 2,) : builder(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [kFavBoxShadow],
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}
