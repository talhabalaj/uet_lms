import 'package:flutter/material.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/dmc_view/dmc_view_model.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';
import 'package:uet_lms/ui/shared/CustomDropDown.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/SplitScreen.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/ui_utils.dart';

class DMCView extends StatelessWidget {
  final String id = "/dmc";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DMCViewModel>.reactive(
      onModelReady: (model) => model.loadData(),
      builder: (context, model, _) {
        return SplitScreen(
          leftView: RefreshIndicator(
            onRefresh: () {
              return model.loadData(refresh: true);
            },
            child: ListView(
              children: [
                SizedBox(height: kAppBarHeight),
                HeadingWithSubtitle(
                  heading: "DMC",
                  subtitle:
                      "Check your grades and stuff. you can the usual, best of luck tho",
                ),
                SizedBox(
                  height: 30,
                ),
                if (!model.isBusy) ...[
                  CustomDropdown(
                    values:
                        model.registeredSemesters.map((e) => e.name).toList(),
                    currentValue: model.selectedSemester,
                    selected: (value) => model.selectedSemester = value,
                  ),
                  for (Result result in model.result) ...[
                    SizedBox(height: 15),
                    CustomCard(
                      builder: (context) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.subject.name
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
                                  result.subject.name.split(' ')[0],
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${result.weightage.toInt()} / 100",
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
                            result.grade,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              color: model.getGradeColor(result),
                            ),
                          )
                        ],
                      ),
                    )
                  ]
                ] else
                  loading(),
                SizedBox(height: 15),
              ]
                  .map((e) => Padding(
                        child: e,
                        padding: EdgeInsets.symmetric(
                            horizontal: kHorizontalSpacing),
                      ))
                  .toList(),
            ),
          ),
        );
      },
      viewModelBuilder: () => DMCViewModel(),
    );
  }
}
