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
      @required this.selected})
      : super(key: key);

  final List<String> values;
  final String currentValue;
  final Function(String) selected;

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
  Animation<double> _opacity;

  findButton() {
    if (buttonKey.currentContext == null) return;
    RenderBox renderBox = buttonKey.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
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
    _containerHeight = 50.0 * (min(3, widget.values?.length ?? 1));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
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
            offset: Offset(0, 1),
            blurRadius: 19,
            color: Colors.black.withAlpha(20),
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
              top: buttonPosition.dy + buttonSize.height + 5,
              left: buttonPosition.dx,
              width: buttonSize.width,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) => CardScrollView(
                        constraints:
                            BoxConstraints(maxHeight: _containerHeight),
                        childCount: widget.values.length,
                        boxShadow: boxShadow,
                        verticalSpacing: 10,
                        horizontalSpacing: 10,
                        builder: (context, idx) => Opacity(
                          opacity: _opacity.value,
                          child: MaterialButton(
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
                                vertical: isMobile() ? 15 : 20),
                            elevation: 0,
                            hoverElevation: 0,
                            onPressed: () {
                              widget.selected(widget.values[idx]);
                              closeMenu();
                            },
                          ),
                        ),
                      ) //code for the drop-down menu...,
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
    assert(widget.values.indexOf(widget.currentValue) != -1,
        "Value should be in the list");

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: CustomCard(
          key: buttonKey,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          builder: (context) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.currentValue.toLowerCase().capitalize(),
                style: style,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                transformAlignment: Alignment.center,
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
