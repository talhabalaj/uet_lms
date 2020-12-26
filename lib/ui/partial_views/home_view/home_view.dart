import 'dart:async';
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
import 'package:uet_lms/ui/shared/SimpleLineGraph.dart';
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
      padding: EdgeInsets.zero,
      builder: (context) => SimpleLineGraph(
        loading:
            model.busy(model.gradeBookDetails) || model.busy(model.semesters),
        spots: model.gradeBookDetails
            ?.map(
              (e) => FlSpot(
                (model.semesters
                    ?.indexWhere(
                        (element) => element.name.compareTo(e.semester) == 0)
                    ?.toDouble()),
                e.gpa,
              ),
            )
            ?.toList(),
        colors: model.gradeBookDetails
            ?.map((e) => getPerColor(e.gpa / 4 * 100))
            ?.toList(),
        maxY: 4,
        minY: 0,
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
                    maxLines: 2,
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
            CustomCircularProgressBar(
              value: attendance,
              loading: model.busy(model.attendance),
            ),
          ],
        );
      },
    );
  }
}

class CustomCircularProgressBar extends StatefulWidget {
  const CustomCircularProgressBar({
    Key key,
    @required this.value,
    this.loading = false,
  }) : super(key: key);

  final double value;
  final bool loading;
  final double angle = 90;

  @override
  _CustomCircularProgressBarState createState() =>
      _CustomCircularProgressBarState();
}

class _CustomCircularProgressBarState extends State<CustomCircularProgressBar>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _angle;

  @override
  void initState() {
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
                  endAngle:widget.loading ? _angle.value : widget.angle,
                  maximum: 100,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    thickness: .3,
                    color: Colors.grey.shade200,
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
                        color: Colors.yellow,
                      )
                    else
                      RangePointer(
                        value: widget.value,
                        width: .3,
                        cornerStyle: CornerStyle.bothCurve,
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
