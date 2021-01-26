import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  const SvgButton({
    @required this.asset,
    this.onTap,
    Key key,
    this.height,
    this.color,
  }) : super(key: key);

  final String asset;
  final void Function() onTap;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Theme.of(context).accentColor.withAlpha(20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          child: SvgPicture.asset(
            asset,
            height: height ?? 20,
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
