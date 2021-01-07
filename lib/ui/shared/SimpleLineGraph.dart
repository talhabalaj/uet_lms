import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SimpleLineGraph extends StatefulWidget {
  SimpleLineGraph({
    Key key,
    this.loading = false,
    TextStyle baseTextStyle,
    this.maxY,
    this.minY,
    @required this.spots,
    @required this.colors,
    this.loadingColor = Colors.yellow,
  })  : this.baseTextStyle = baseTextStyle ??
            TextStyle(
              fontSize: 15,
              fontFamily: "Inter",
              color: Colors.grey[400],
            ),
        loadingSpots = [
          List.generate(
              MAX_Y.toInt(), (index) => FlSpot(index.toDouble(), sin(index))),
          List.generate(MAX_Y.toInt(),
              (index) => FlSpot(index.toDouble(), sin(index) + 1)),
          List.generate(MAX_Y.toInt(),
              (index) => FlSpot(index.toDouble(), sin(index) + 2)),
        ],
        super(key: key);

  final bool loading;
  final TextStyle baseTextStyle;
  final double maxY;
  final double minY;
  final List<FlSpot> spots;
  final List<Color> colors;
  final Color loadingColor;

  final List<List<FlSpot>> loadingSpots;

  static const double MAX_Y = 4;

  @override
  _SimpleLineGraphState createState() => _SimpleLineGraphState();
}

class _SimpleLineGraphState extends State<SimpleLineGraph> {
  int index = 0;
  Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 750), (timer) {
      this.setState(() {
        index = (index + 1) % widget.loadingSpots.length;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loadingColors = List.generate(4, (index) => widget.loadingColor);
    final colors =
        widget.loading ? loadingColors : (widget.colors) ?? loadingColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          borderData: FlBorderData(
            show: false,
          ),
          axisTitleData: FlAxisTitleData(
            topTitle: AxisTitle(
              titleText: "GPA • GRAPH",
              showTitle: true,
              reservedSize: 30,
              margin: 5,
              textStyle: widget.baseTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          titlesData: FlTitlesData(
            show: false,
          ),
          gridData: FlGridData(
            show: false,
          ),
          maxY: widget.maxY,
          minY: widget.minY,
          lineBarsData: [
            LineChartBarData(
              spots:
                  !widget.loading ? widget.spots : widget.loadingSpots[index],
              isCurved: true,
              colors: colors,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: colors.map((color) => color.withOpacity(0.5)).toList(),
              ),
            ),
          ],
        ),
        swapAnimationDuration: Duration(milliseconds: 750),
      ),
    );
  }
}
