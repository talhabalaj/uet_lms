import 'package:flutter/material.dart';

import '../ui_constants.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    Key key,
    this.onTap,
    this.title,
    this.subtitle,
    this.disabled = false,
    this.newTag = false,
    this.isActive = false,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final String subtitle;
  final bool isActive;
  final bool disabled;
  final bool newTag;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      enableFeedback: true,
      onPressed: disabled ? null : onTap,
      padding: EdgeInsets.zero,
      child: Container(
        height: subtitle.length <= 45 ? 65 : 75,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              color:
                  isActive ? Theme.of(context).accentColor : Colors.transparent,
            ),
            SizedBox(
              width: kHorizontalSpacing - 5,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: kHorizontalSpacing,
                  top: 10,
                  bottom: 10,
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: disabled
                        ? Theme.of(context).primaryColor.withAlpha(100)
                        : (isActive
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor.withAlpha(200)),
                  ),
                  child: Builder(
                    builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
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
                            if (newTag)
                              Container(
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  "NEW",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              )
                          ],
                        ),
                        Text(
                          this.subtitle,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                fontSize: 11,
                                color: DefaultTextStyle.of(context).style.color,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
