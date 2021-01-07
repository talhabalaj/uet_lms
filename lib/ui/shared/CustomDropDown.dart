import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uet_lms/ui/shared/CardScrollView.dart';
import 'package:uet_lms/ui/ui_constants.dart';
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
  Animation<double> _containerHeight;
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
    _containerHeight = Tween<double>(begin: 0, end: 150).animate(
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
                        height: _containerHeight.value,
                        childCount: widget.values.length,
                        boxShadow: boxShadow,
                        verticalSpacing: 10,
                        horizontalSpacing: 10,
                        builder: (context, idx) => Opacity(
                          opacity: _opacity.value,
                          child: MaterialButton(
                            child: Text(
                              widget.values[idx].toLowerCase().capitalize(),
                              style: TextStyle(fontSize: 15),
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.symmetric(vertical: 20),
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
    await _animationController.reverse();
    overlayEntry.remove();
    isMenuOpen = !isMenuOpen;
  }

  openMenu() async {
    findButton();
    overlayEntry = _overlayEntryBuilder();
    _animationController.forward();
    Overlay.of(context).insert(overlayEntry);
    isMenuOpen = !isMenuOpen;
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
              Icon(Icons.keyboard_arrow_down),
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
