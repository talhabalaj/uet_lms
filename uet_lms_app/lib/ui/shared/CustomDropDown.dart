import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/shared/CardScrollView.dart';
import 'CustomCard.dart';
import 'package:uet_lms/core/string_extension.dart';

class CustomDropdown extends StatefulWidget {
  CustomDropdown(
      {Key key,
      @required this.values,
      @required this.currentValue,
      @required this.onSelectionChange,
      this.color})
      : super(key: key);

  final List<String> values;
  final String currentValue;
  final Function(String) onSelectionChange;
  final Color color;

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with TickerProviderStateMixin {
  final TextStyle style = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  GlobalKey buttonKey = LabeledGlobalKey("dropdownBox");
  Size buttonSize;
  bool isMenuOpen = false;
  Offset buttonPosition;
  OverlayEntry overlayEntry;
  AnimationController _animationController;
  double _containerHeight;
  double _offset;
  Animation<double> _opacity;
  Animation<double> scale;
  bool isOnTheTop = false;

  findButton() {
    if (buttonKey.currentContext == null) return;
    RenderBox renderBox = buttonKey.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
    _offset = buttonPosition.dy + buttonSize.height + 5;

    double end = _offset + _containerHeight;
    if (end > MediaQuery.of(context).size.height) {
      _offset = buttonPosition.dy - 5 - _containerHeight;
      isOnTheTop = true;
    } else {
      isOnTheTop = false;
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      value: 0,
      duration: Duration(milliseconds: 400),
    );
    _containerHeight =
        (isMobile ? 55.0 : 50.0) * (min(5, widget.values?.length ?? 1));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    scale = _opacity = Tween<double>(begin: .8, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutSine,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
        findButton();
      });
    });

    super.initState();
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        final boxShadow = [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 19,
            color: Theme.of(context).primaryColor.withAlpha(25),
            spreadRadius: 0,
          ),
        ];

        return Stack(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  closeMenu();
                },
                child: Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Positioned(
              top: _offset,
              left: buttonPosition.dx,
              width: buttonSize.width,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) => Opacity(child: child, opacity: _opacity.value,),
                child: ScaleTransition(
                  scale: scale,
                  alignment:
                      isOnTheTop ? Alignment.bottomCenter : Alignment.topCenter,
                  child: CardScrollView(
                      constraints: BoxConstraints(maxHeight: _containerHeight),
                      childCount: widget.values.length,
                      boxShadow: boxShadow,
                      verticalSpacing: 0,
                      listViewPadding: EdgeInsets.zero,
                      horizontalSpacing: 0,
                      color: widget.color,
                      builder: (context, idx) => MaterialButton(
                            child: Text(
                              widget.values[idx].toLowerCase().capitalize(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(
                                vertical: isMobile ? 17 : 20),
                            elevation: 0,
                            shape: idx == 0 ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7),
                                    ),
                                  ) :  idx + 1 == widget.values.length
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(7),
                                      bottomRight: Radius.circular(7),
                                    ),
                                  )
                                : null,
                            hoverElevation: 0,
                            onPressed: () {
                              if (widget.values[idx] != widget.currentValue)
                                widget.onSelectionChange(widget.values[idx]);
                              closeMenu();
                            },
                          ) //code for the drop-down menu...,
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  closeMenu() async {
    overlayEntry?.remove();
    this.setState(() {
      isMenuOpen = !isMenuOpen;
    });
    await _animationController.reverse();
  }

  openMenu() async {
    findButton();
    this.setState(() {
      isMenuOpen = !isMenuOpen;
    });
    overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(overlayEntry);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    assert(
        widget.values.indexOf(widget.currentValue) != -1 ||
            widget.currentValue == null,
        "Value should be in the list");

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: CustomCard(
          color: widget.color,
          key: buttonKey,
          boxShadow: [],
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          builder: (context) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.currentValue?.toLowerCase()?.capitalize() ?? "Select",
                style: style,
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateZ(isMenuOpen ? pi : 0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        onTap: () async {
          if (!isMenuOpen) {
            openMenu();
          } else {
            closeMenu();
          }
        },
      ),
    );
  }
}
