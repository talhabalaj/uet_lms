import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DefaultShimmer extends StatelessWidget {
  DefaultShimmer(
      {Key key, this.height, this.width, this.borderRadius, this.margin})
      : super(key: key);

  final double height;
  final double width;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200],
      highlightColor: Colors.grey[100],
      child: Container(
        height: height ?? 16,
        margin: margin == null ? EdgeInsets.only(bottom: 5) : margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.white,
        ),
        width: width,
      ),
    );
  }
}
