import 'package:flutter/material.dart';

import '../ui_constants.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    Key key,
    this.onTap,
    this.title,
    this.subtitle,
    this.disabled = false,
    this.isActive = false,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final String subtitle;
  final bool isActive;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      enableFeedback: true,
      onPressed: disabled ? null : onTap,
      padding: EdgeInsets.zero,
      child: Container(
        height: subtitle.length <= 45 ? 55 : 65,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              color: isActive ? kPrimaryColor : Colors.transparent,
            ),
            SizedBox(
              width: kHorizontalSpacing - 5,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: kHorizontalSpacing, top: 5, bottom: 5),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: disabled
                        ? Colors.grey[500]
                        : (isActive
                            ? kPrimaryColor
                            : Color(
                                0xff6b6b6b,
                              )),
                  ),
                  child: Builder(
                      builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                this.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        color: DefaultTextStyle.of(context)
                                            .style
                                            .color),
                              ),
                              Text(
                                this.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 11,
                                      color: DefaultTextStyle.of(context)
                                          .style
                                          .color,
                                    ),
                              )
                            ],
                          )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
