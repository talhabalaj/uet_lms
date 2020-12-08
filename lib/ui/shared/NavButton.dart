
import 'package:flutter/material.dart';

import '../ui_constants.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    Key key,
    this.onTap,
    this.title,
    this.subtitle,
    this.isActive = false,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final String subtitle;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: onTap,
      child: Container(
        height: subtitle.length <= 45 ? 50 : 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              color: isActive
                  ? kPrimaryColor
                  : Theme.of(context).scaffoldBackgroundColor,
            ),
            SizedBox(
              width: kHorizontalSpacing - 5,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: kHorizontalSpacing),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                      color: isActive ? kPrimaryColor : Color(0xff6b6b6b)),
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
