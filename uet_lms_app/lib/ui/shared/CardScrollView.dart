import 'dart:ui';

import 'package:flutter/material.dart';
import 'CustomCard.dart';
import 'RepeatedShimmer.dart';

class CardScrollView extends StatefulWidget {
  CardScrollView(
      {Key key,
      this.loading = false,
      @required this.childCount,
      @required this.builder,
      this.verticalSpacing = 15,
      this.horizontalSpacing = 17,
      this.height,
      this.boxShadow,
      this.constraints,
      this.title})
      : super(key: key);

  final bool loading;
  final int childCount;
  final double height;
  final String title;
  final double verticalSpacing;
  final double horizontalSpacing;
  final Widget Function(BuildContext, int) builder;
  final List<BoxShadow> boxShadow;
  final BoxConstraints constraints;

  @override
  _CardScrollViewState createState() => _CardScrollViewState();
}

class _CardScrollViewState extends State<CardScrollView>
    with TickerProviderStateMixin {
  bool hasBlur = false;
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: widget.height,
      constraints: widget.constraints,
      boxShadow: widget.boxShadow,
      padding: EdgeInsets.zero,
      builder: (context) => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalSpacing),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0) {
                  if (notification.metrics.pixels < 10 && hasBlur) {
                    hasBlur = false;
                    _controller.reverse();
                  } else if (notification.metrics.pixels >= 10 && !hasBlur) {
                    hasBlur = true;
                    _controller.forward();
                  }
                  return true;
                }

                return false;
              },
              child: _buildListView(),
            ),
          ),
          if (widget.title != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
              ),
              width: double.infinity,
              child: ClipRect(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.verticalSpacing,
                      bottom: 10,
                      left: widget.horizontalSpacing,
                      right: widget.horizontalSpacing),
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, widget) {
                      double val = _controller.value * 7;
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: val, sigmaY: val),
                        child: widget,
                      );
                    },
                    child: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, idx) => Padding(
        padding: idx == 0
            ? EdgeInsets.only(top: widget.title != null ? 35.0 : 0)
            : EdgeInsets.only(
                top: widget.verticalSpacing,
              ),
        child: widget.loading
            ? Opacity(
                opacity: 1 - (idx / 7),
                child: RepeatedShimmer(
                  repeated: 1,
                ),
              )
            : widget.builder(context, idx),
      ),
      itemCount: widget.loading ? 7 : widget.childCount,
    );
  }
}
