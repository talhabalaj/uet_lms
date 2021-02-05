import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:uet_lms/ui/ui_utils.dart';

class CustomCircularProgressBar extends StatefulWidget {
  CustomCircularProgressBar({
    Key key,
    @required this.value,
    this.loading = false,
    this.bgColor,
  }) : super(key: key);

  final double value;
  final bool loading;
  final double angle = 90;
  final Color bgColor;

  @override
  _CustomCircularProgressBarState createState() =>
      _CustomCircularProgressBarState();
}

class _CustomCircularProgressBarState extends State<CustomCircularProgressBar>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _angle;
  Color bgColor;

  @override
  void initState() {
    bgColor = widget.bgColor ?? Colors.grey.shade200;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
    );
    _angle = Tween<double>(
      begin: 90,
      end: 360,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    if (widget.loading) {
      _controller.repeat(reverse: true);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(d) {
    if (widget.loading) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(d);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      child: AnimatedBuilder(
          animation: _angle,
          builder: (context, _) {
            return SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  startAngle: widget.loading ? _angle.value : widget.angle,
                  endAngle: widget.loading ? _angle.value : widget.angle,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: .3,
                    color: bgColor,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    if (widget.loading)
                      RangePointer(
                        value: 30,
                        width: .3,
                        cornerStyle: CornerStyle.bothCurve,
                        sizeUnit: GaugeSizeUnit.factor,
                        enableAnimation: true,
                        color: Theme.of(context).accentColor,
                      )
                    else
                      RangePointer(
                        value: widget.value,
                        width: .3,
                        cornerStyle: widget.value == 100 ? CornerStyle.bothFlat : CornerStyle.bothCurve,
                        sizeUnit: GaugeSizeUnit.factor,
                        enableAnimation: true,
                        color: getPerColor(widget.value),
                      ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      positionFactor: 0.14,
                      widget: Text(
                        widget.loading ? "" : widget.value.toStringAsFixed(0),
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            );
          }),
    );
  }
}
//
