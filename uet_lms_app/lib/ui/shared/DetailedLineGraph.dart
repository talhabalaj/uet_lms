import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetialedLineGraph extends StatefulWidget {
  DetialedLineGraph(
      {this.spots,
      this.colors,
      Key key,
      this.maxX,
      this.maxY,
      this.minX,
      this.getBottomTitles,
      this.minY})
      : super(key: key);

  final List<FlSpot> spots;
  final List<Color> colors;
  final double maxY;
  final double maxX;
  final double minY;
  final double minX;
  final String Function(double) getBottomTitles;

  @override
  _DetialedLineGraphState createState() => _DetialedLineGraphState();
}

class _DetialedLineGraphState extends State<DetialedLineGraph> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: .5),
        ),
        axisTitleData: FlAxisTitleData(
          topTitle: AxisTitle(
            titleText: "Semester Summary".toUpperCase(),
            showTitle: true,
            reservedSize: 10,
            margin: 15,
            textStyle: TextStyle(
              fontSize: 15,
              fontFamily: "Inter",
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 0,
              getTextStyles: (d) => TextStyle(
                    fontSize: 10,
                    fontFamily: "Inter",
                    color: Colors.grey[500],
                  ),
              getTitles: (idx) {
                if (idx == 0) return '';
                return idx.toStringAsFixed(0);
              }),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 5,
            getTextStyles: (d) => TextStyle(
              fontSize: 10,
              fontFamily: "Inter",
              color: Colors.grey[500],
            ),
            getTitles: widget.getBottomTitles,
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
        ),
        maxY: widget.maxY,
        minY: widget.minY,
        minX: widget.minX,
        maxX: widget.maxX,
        lineBarsData: [
          LineChartBarData(
            spots: widget.spots,
            isCurved: true,
            colors: widget.colors,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
            ),
            belowBarData: BarAreaData(
              show: true,
              colors:
                  widget.colors.map((color) => color.withOpacity(0.5)).toList(),
            ),
          ),
        ],
      ),
      swapAnimationDuration: Duration(milliseconds: 750),
    );
  }
}
