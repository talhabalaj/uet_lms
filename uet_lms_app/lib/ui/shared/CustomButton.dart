import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uet_lms/ui/ui_utils.dart';

class SimpleWideButton extends StatefulWidget {
  const SimpleWideButton({
    Key key,
    this.onPressed,
    this.color,
    this.text,
    this.textColor,
    this.height,
    this.loading = false,
  }) : super(key: key);

  final Function() onPressed;
  final Color color;
  final String text;
  final Color textColor;
  final bool loading;
  final double height;

  @override
  _SimpleWideButtonState createState() => _SimpleWideButtonState();
}

class _SimpleWideButtonState extends State<SimpleWideButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: widget.loading
          ? SpinKitThreeBounce(
              color: widget.textColor ?? Theme.of(context).backgroundColor,
              size: 20,
            )
          : Text(
              widget.text ?? 'Button',
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: widget.textColor ?? Theme.of(context).backgroundColor),
            ),
      height: widget.height ?? 57,
      minWidth: double.infinity,
      disabledColor:
          (widget.color ?? darken(Theme.of(context).accentColor, .1)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      color: darken(widget.color ?? Theme.of(context).accentColor,
          widget.loading ? .05 : 0),
      onPressed: widget.onPressed,
    );
  }
}
