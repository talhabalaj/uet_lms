import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimatedIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;
  final bool animationReversed;

  const AnimatedIndexedStack({
    Key key,
    this.index,
    this.children,
    this.animationReversed = false,
    this.duration = const Duration(
      milliseconds: 400,
    ),
  }) : super(key: key);

  @override
  _AnimatedIndexedStackState createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack> {
  @override
  Widget build(BuildContext context) {

    return PageTransitionSwitcher(
      child: IndexedStack(
        index: widget.index,
        key: ValueKey(widget.index),
        children: widget.children,
      ),
      duration: Duration(milliseconds: 750),
      reverse: widget.animationReversed,
      transitionBuilder: (
        Widget child,
        Animation<double> primaryAnimation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          child: child,
          fillColor: Colors.transparent,
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
        );
      },
    );
  }
}
