import 'package:flutter/material.dart';
import 'package:lms_app/ui/shared/CustomButton.dart';
import 'package:lms_app/ui/ui_constants.dart';
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
    _containerHeight = Tween<double>(begin: 0, end: 280).animate(
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
    return Column(
      children: [
        Spacer(),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) => Container(
            height: _containerHeight.value,
            width: double.infinity,
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
                        SizedBox(height: 20,),
                        if (widget.request.description != null)
                          Text(
                            widget.request.description,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                      ],
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: SimpleWideButton(
                              text: widget.request.mainButtonTitle ?? "Okay",
                              onPressed: () async {
                                await _animationController.reverse();
                                widget.completer(
                                  DialogResponse(
                                    confirmed: true,
                                  ),
                                );
                              },
                            ),
                          ),
                          if (widget.request.secondaryButtonTitle != null) ...[
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SimpleWideButton(
                                color: Colors.white,
                                textColor: kPrimaryColor,
                                text: widget.request.secondaryButtonTitle,
                                onPressed: () async {
                                  await _animationController.reverse();
                                  widget.completer(
                                    DialogResponse(
                                      confirmed: false,
                                    ),
                                  );
                                },
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
              color: Theme.of(context).backgroundColor,
            ),
          ),
        )
      ],
    );
  }
}
