// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class DetialedLineGraph extends StatefulWidget {
//   @override
//   _DetialedLineGraphState createState() => _DetialedLineGraphState();
// }

// class _DetialedLineGraphState extends State<DetialedLineGraph> {
//   @override
//   Widget build(BuildContext context) {
//     return LineChart(
//       LineChartData(
//         borderData: FlBorderData(
//           show: false,
//         ),
//         axisTitleData: FlAxisTitleData(
//           topTitle: AxisTitle(
//             titleText: "GPA • GRAPH",
//             showTitle: true,
//             reservedSize: 20,
//             margin: 10,
//             textStyle: TextStyle(
//               fontSize: 15,
//               fontFamily: "Inter",
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[400],
//             ),
//           ),
//         ),
//         titlesData: FlTitlesData(
//           show: true,
//           leftTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 15,
//             getTitles: (value) {
//               return value.toDouble().toStringAsFixed(1);
//             },
//           ),
//           bottomTitles: SideTitles(
//               showTitles: true,
//               interval: 1,
//               reservedSize: 20,
//               getTitles: (idx) {
//                 final semesterNameParts =
//                     model.semesters[idx.toInt() - 1].name.split(' ');
//                 return '${semesterNameParts[0][0]}${semesterNameParts[1].substring(2)}';
//               }),
//         ),
//         gridData: FlGridData(
//           show: true,
//           drawVerticalLine: true,
//         ),
//         maxY: 4,
//         minY: 0,
//         lineBarsData: [
//           LineChartBarData(
//             spots: !(model.busy(model.gradeBookDetails) ||
//                     model.busy(model.semesters))
//                 ? model.gradeBookDetails
//                     ?.map(
//                       (e) => FlSpot(
//                         (model.semesters
//                                     ?.indexWhere((element) =>
//                                         element.name.compareTo(e.semester) == 0)
//                                     ?.toDouble() ??
//                                 0) +
//                             1,
//                         e.gpa,
//                       ),
//                     )
//                     ?.toList()
//                 : List.generate(model.gradeBookDetails?.length ?? 4,
//                     (index) => FlSpot(index.toDouble() + 1, 1)),
//             isCurved: true,
//             colors: model.gradeBookDetails
//                     ?.map((e) => getPerColor(e.gpa / 4 * 100))
//                     ?.toList() ??
//                 List.generate(4, (index) => Colors.yellow),
//             barWidth: 4,
//             isStrokeCapRound: true,
//             dotData: FlDotData(
//               show: false,
//             ),
//             belowBarData: BarAreaData(
//               show: true,
//               colors: (model.gradeBookDetails
//                           ?.map((e) => getPerColor(e.gpa / 4 * 100)) ??
//                       List.generate(4, (index) => Colors.yellow))
//                   .map((color) => color.withOpacity(0.4))
//                   .toList(),
//             ),
//           ),
//         ],
//       ),
//       swapAnimationDuration: Duration(milliseconds: 750),
//     );
//   }
// }
