import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key key,
    this.isPassword = false,
    this.errorText,
    this.labelText,
    this.suffixText,
    this.validator,
    this.enabled = true,
    this.hintText,
    this.regex,
    this.onSaved,
    TextStyle style,
    this.onChanged,
  })  : this.style = style,
        super(key: key);

  final bool isPassword;
  final String suffixText;
  final TextStyle style;
  final String labelText;
  final String hintText;
  final bool enabled;
  final String errorText;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final RegExp regex;
  final String Function(String) validator;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool passwordShown = false;

  @override
  Widget build(BuildContext context) {
    assert(!(widget.isPassword && widget.suffixText != null),
        "Password field can't have suffix");

    assert(!(widget.validator != null && widget.regex != null),
        "Both regex and validator cannot be supplied");

    TextStyle styleToUse =
        widget.style ?? Theme.of(context).textTheme.bodyText1;

    return StatefulBuilder(
      builder: (context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText, style: styleToUse),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            enabled: widget.enabled,
            onSaved: widget.onSaved,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: Colors.grey[600],
            onChanged: widget.onChanged,
            validator: widget.validator ??
                (widget.regex == null
                    ? null
                    : (string) => widget.regex.hasMatch(string)
                        ? null
                        : widget.errorText ?? "That's not valid :("),
            style: styleToUse,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: widget.isPassword && !passwordShown,
            decoration: InputDecoration(
              suffixText: widget.isPassword ? null : widget.suffixText,
              suffixStyle: styleToUse.copyWith(color: Colors.grey[600]),
              suffixIcon: widget.isPassword
                  ? MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordShown = !passwordShown;
                          });
                        },
                        child: Icon(
                          passwordShown
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[300],
                          size: 23,
                        ),
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              fillColor: Theme.of(context).cardColor,
              filled: true,
              hintText: widget.hintText,
              errorMaxLines: 2,
              errorStyle: styleToUse.copyWith(fontSize: 13, color: Colors.red),
              hintStyle: styleToUse.copyWith(
                color: Color(0xffAEAEAE),
              ),
            ),
          )
        ],
      ),
    );
  }
}
