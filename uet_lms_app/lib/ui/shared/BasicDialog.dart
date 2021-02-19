import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'CustomButton.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:stacked_services/stacked_services.dart';

class BasicDialog extends StatefulWidget {
  BasicDialog({Key key, @required this.request, this.completer})
      : super(key: key);

  final DialogRequest request;
  final Function(DialogResponse) completer;

  @override
  _BasicDialogState createState() => _BasicDialogState();
}

class _BasicDialogState extends State<BasicDialog>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _containerHeight;
  Animation<double> _opacity;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
      duration: Duration(milliseconds: 500),
    );
    _containerHeight = Tween<double>(begin: 0, end: 250).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.5,
            1,
            curve: Curves.easeInOutSine,
          )),
    );

    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyBoardShortcuts(
      onKeysPressed: () {
        _completeDialog(false);
      },
      keysToPress: [LogicalKeyboardKey.escape].toSet(),
      child: Column(
        children: [
          Spacer(),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) => Container(
              constraints: BoxConstraints(
                  maxWidth: 500, maxHeight: _containerHeight.value),
              child: Opacity(
                opacity: _opacity.value,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: kHorizontalSpacing, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.request.title != null)
                            Text(
                              widget.request.title,
                              style: Theme.of(context).textTheme.headline2,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          if (widget.request.description != null)
                            Container(
                              height: _containerHeight.value - 200,
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.request.description,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Expanded(
                              child: SimpleWideButton(
                                text: widget.request.mainButtonTitle ?? "Okay",
                                onPressed: () => _completeDialog(true),
                              ),
                            ),
                            if (widget.request.secondaryButtonTitle !=
                                null) ...[
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SimpleWideButton(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withAlpha(15),
                                  textColor: Theme.of(context).accentColor,
                                  text: widget.request.secondaryButtonTitle,
                                  onPressed: () => _completeDialog(false),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
                color: Theme.of(context).cardColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  _completeDialog(bool confirmed) async {
    await _animationController.reverse();
    widget.completer(
      DialogResponse(
        confirmed: confirmed,
      ),
    );
  }
}
