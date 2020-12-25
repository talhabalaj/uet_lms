import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:uet_lms/ui/partial_views/home_view/home_viewmodel.dart';
import 'package:uet_lms/ui/shared/CardScrollView.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/RefreshIndicatorWithoutListView.dart';
import 'package:uet_lms/ui/shared/SplitScreen.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/ui_utils.dart';

class DashBoardView extends StatelessWidget {
  final id = "/dashboard";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<HomeViewModel>.reactive(
        onModelReady: (model) async {
          await model.loadData();
        },
        builder: (context, model, _) {
          return SplitScreen(
            //rightView: Container(),
            leftView: RefreshIndicatorWithoutListView(
              onRefresh: () => model.loadData(refresh: true),
              child: Padding(
                padding: EdgeInsets.only(
                  left: kHorizontalSpacing,
                  right: kHorizontalSpacing,
                  bottom: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: kAppBarHeight,
                    ),
                    if (model.busy(model.studentProfile))
                      HeadingWithSubtitle()
                    else
                      HeadingWithSubtitle(
                        heading: "Welcome, ${model.userFirstName}",
                        subtitle:
                            "How’s your day goin’? Here’s some stats about your University life",
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(model, context),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        _buildGPACard(model, context),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Expanded(
                      child: _buildRegisteredSubjectsScrollView(context, model),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => HomeViewModel(),
      ),
    );
  }

  Widget _buildStatCard(HomeViewModel model, BuildContext context) {
    return CustomCard(
      height: 130,
      builder: (context) => LineChart(
        LineChartData(
          borderData: FlBorderData(
            show: false,
          ),
          axisTitleData: FlAxisTitleData(
            topTitle: AxisTitle(
              titleText: "GPA • GRAPH",
              showTitle: true,
              reservedSize: 30,
              margin: 5,
              textStyle: TextStyle(
                fontSize: 15,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Colors.grey[400],
              ),
            ),
          ),
          titlesData: FlTitlesData(
            show: false,
            leftTitles: SideTitles(
              showTitles: false,
            ),
            bottomTitles: SideTitles(
              getTitles: (idx) {
                final semesterNameParts =
                    model.semesters[idx.toInt() - 1].name.split(" ");
                return "${semesterNameParts.first[0]}${semesterNameParts[1].substring(2)}";
              },
              showTitles: true,
              reservedSize: 25,
              margin: -25,
              getTextStyles: (value) => TextStyle(
                color: Colors.green,
              ),
            ),
          ),
          gridData: FlGridData(
            show: false,
          ),
          maxY: 4,
          minY: 2,
          lineBarsData: [
            LineChartBarData(
              preventCurveOverShooting: true,
              spots: model.gradeBookDetails
                  .map(
                    (e) => FlSpot(
                      model.semesters
                              .indexWhere((element) =>
                                  element.name.compareTo(e.semester) == 0)
                              .toDouble() +
                          1,
                      e.gpa,
                    ),
                  )
                  .toList(),
              isCurved: true,
              colors: model.gradeBookDetails
                  .map((e) => getPerColor(e.gpa / 4 * 100))
                  .toList(),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.green]
                    .map((color) => color.withOpacity(0.4))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGPACard(HomeViewModel model, BuildContext context) {
    final cardSize = 130.0;

    return CustomCard(
      height: cardSize,
      width: cardSize,
      loading: model.busy(model.gradeBookDetails),
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            model.gradeBookDetails?.last?.cgpa?.toStringAsFixed(1),
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 50),
          ),
          Text(
            "CGPA",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisteredSubjectsScrollView(
      BuildContext context, HomeViewModel model) {
    return CardScrollView(
      title: "CURRENT COURSES • ATTENDANCE",
      childCount: model.registerdSubjects?.length,
      loading: model.busy(model.registerdSubjects),
      builder: (context, idx) {
        double attendance = model.busy(model.attendance)
            ? 0
            : model.attendance[model.registerdSubjects[idx]] * 100;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.registerdSubjects[idx].subjectName
                        .split(' ')
                        .sublist(1)
                        .join(' '),
                    style: Theme.of(context).textTheme.headline4,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    model.registerdSubjects[idx].subjectName.split(' ')[0],
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 40,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    startAngle: 90,
                    endAngle: 90,
                    maximum: 100,
                    showLabels: false,
                    showTicks: false,
                    axisLineStyle: AxisLineStyle(
                      thickness: .3,
                      color: Colors.grey.shade200,
                      thicknessUnit: GaugeSizeUnit.factor,
                    ),
                    pointers: <GaugePointer>[
                      RangePointer(
                        value: attendance,
                        width: .3,
                        cornerStyle: CornerStyle.bothCurve,
                        sizeUnit: GaugeSizeUnit.factor,
                        enableAnimation: true,
                        color: getPerColor(attendance),
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        positionFactor: 0.14,
                        widget: Text(
                          model.busy(model.attendance)
                              ? "◌"
                              : attendance.toStringAsFixed(0),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
