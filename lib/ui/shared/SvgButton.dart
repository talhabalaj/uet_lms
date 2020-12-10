import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgButton extends StatelessWidget {
  const SvgButton({
    @required this.asset,
    this.onTap,
    Key key,
    this.height,
  }) : super(key: key);

  final String asset;
  final void Function() onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
      
      color: Colors.grey[200].withAlpha(200), 
      
      padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          asset,
          height: height ?? 20,
          alignment: Alignment.centerLeft,
        ),
      ),
    );
  }
}
