import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lms_app/ui/ui_constants.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    Key key,
    this.isPassword = false,
    this.errorText,
    this.labelText,
    this.suffixText,
    this.enabled = true,
    this.hintText,
    this.regex,
    this.onSaved,
    TextStyle style,
    this.onChanged,
  })  : this.style = style ?? TextStyle(fontSize: 18),
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

  bool passwordShown = false;

  @override
  Widget build(BuildContext context) {
    assert(!(isPassword && suffixText != null),
        "Password field can't have suffix");

    return StatefulBuilder(
      builder: (context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText, style: style),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[kFavBoxShadow],
            ),
            child: Stack(
              children: [
                TextFormField(
                  enabled: enabled,
                  onSaved: onSaved,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: Colors.grey[600],
                  onChanged: onChanged,
                  validator: regex == null
                      ? null
                      : (string) => regex.hasMatch(string)
                          ? null
                          : errorText ?? "That's not valid :(",
                  style: style,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: isPassword && !passwordShown,
                  decoration: InputDecoration(
                    suffixText: isPassword ? null : suffixText,
                    suffixStyle: style.copyWith(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: hintText,
                    errorStyle: style.copyWith(fontSize: 14, color: Colors.red),
                    hintStyle: style.copyWith(
                      color: Color(0xffAEAEAE),
                    ),
                  ),
                ),
                if (isPassword)
                  Positioned(
                      right: 16,
                      top: 13.5,
                      child: MouseRegion(
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
                      )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
