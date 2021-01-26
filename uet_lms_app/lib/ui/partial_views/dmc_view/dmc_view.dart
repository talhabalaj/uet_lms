import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/dmc_view/dmc_view_model.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';
import 'package:uet_lms/ui/shared/CustomDropDown.dart';
import 'package:uet_lms/ui/shared/DetailedLineGraph.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/NestedNavigation.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/ui_utils.dart';

class DMCView extends StatelessWidget {
  final String id = "/dmc";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DMCViewModel>.reactive(
      onModelReady: (model) => model.loadData(),
      builder: (context, model, _) {
        return NestedNavigation(
          onRefresh: () {
            return model.loadData(refresh: true);
          },
          children: [
            HeadingWithSubtitle(
              heading: "DMC",
              subtitle:
                  "Check your grades and stuff. you know the usual, best of luck tho",
            ),
            SizedBox(
              height: 20,
            ),
            if (model.hasError)
              Container(
                alignment: Alignment.center,
                height:
                    MediaQuery.of(context).size.height - kAppBarHeight - 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.modelError.message,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      model.modelError.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    )
                  ],
                ),
              )
            else if (!model.isBusy) ...[
              CustomCard(
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                builder: (context) => DetialedLineGraph(
                  maxX: 7,
                  minX: 0,
                  minY: 0,
                  maxY: 4,
                  getBottomTitles: (idx) {
                    if (idx.toInt() < model.registeredSemesters.length) {
                      final semesterNameParts = model
                          .registeredSemesters.reversed
                          .toList()[idx.toInt()]
                          .name
                          .split(' ');
                      return '${semesterNameParts[0][0]}${semesterNameParts[1].substring(2)}';
                    }
                    return "";
                  },
                  spots: model.gradeBookDetails
                      ?.map(
                        (e) => FlSpot(
                          (model.registeredSemesters.reversed
                              .toList()
                              ?.indexWhere((element) =>
                                  element.name.compareTo(e.semester) == 0)
                              ?.toDouble()),
                          e.gpa,
                        ),
                      )
                      ?.toList(),
                  colors: model.gradeBookDetails
                      ?.map((e) => getPerColor(e.gpa / 4 * 100))
                      ?.toList(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              CustomDropdown(
                values: model.registeredSemesters.map((e) => e.name).toList(),
                currentValue: model.selectedSemester,
                selected: (value) => model.selectedSemester = value,
              ),
              AnimationLimiter(
                key: ValueKey(model.selectedSemester),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: model.result.length,
                  itemBuilder: (BuildContext context, int index) =>
                      AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            CustomCard(
                              builder: (context) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          model.result[index].subject.name
                                              .split(' ')
                                              .sublist(1)
                                              .join(" "),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          model.result[index].subject.name
                                              .split(' ')[0],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${model.result[index].weightage.toInt()} / 100",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.grey[500],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    model.result[index].grade,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      color: model
                                          .getGradeColor(model.result[index]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ] else
              loading(),
            SizedBox(height: 15),
          ]
              .map((e) => Padding(
                    child: e,
                    padding:
                        EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
                  ))
              .toList(),
        );
      },
      viewModelBuilder: () => DMCViewModel(),
    );
  }
}