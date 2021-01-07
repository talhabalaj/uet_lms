import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DefaultShimmer extends StatelessWidget {
  DefaultShimmer({Key key, this.height, this.width, this.borderRadius, this.color})
      : super(key: key);

  final double height;
  final Color color;
  final double width;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Shimmer(
        color: color ?? Colors.grey[200],
        child: Container(
          height: height ?? 16,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(7),
            color: color ?? Colors.grey[200],
          ),
          width: width,
        ),
      ),
    );
  }
}
