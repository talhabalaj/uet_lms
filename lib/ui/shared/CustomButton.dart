import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uet_lms/ui/ui_constants.dart';

class SimpleWideButton extends StatefulWidget {
  const SimpleWideButton({
    Key key,
    this.onPressed,
    this.color,
    this.text,
    this.textColor,
    this.loading = false,
  }) : super(key: key);

  final Function() onPressed;
  final Color color;
  final String text;
  final Color textColor;
  final bool loading;

  @override
  _SimpleWideButtonState createState() => _SimpleWideButtonState();
}

class _SimpleWideButtonState extends State<SimpleWideButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: widget.loading
          ? SpinKitThreeBounce(color: Colors.white, size: 20,)
          : Text(
              widget.text ?? 'Button',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: widget.textColor ?? Colors.white),
            ),
      height: 57,
      minWidth: double.infinity,
      disabledColor: (widget.color ?? kPrimaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      color: widget.color ?? kPrimaryColor,
      onPressed: widget.onPressed,
    );
  }
}
