import 'package:flutter/material.dart';
import 'package:lms_api/models/obe.core.register.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/constants.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';
import 'package:uet_lms/ui/shared/CustomDropDown.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/Loading.dart';
import 'package:uet_lms/ui/shared/NestedNavigation.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/ui_utils.dart';

import 'gpa_estimator_viewmodel.dart';

class GPAEstimatorView extends StatelessWidget {
  final String id = "/gpa_estimator";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GPAEstimatorViewModel>.reactive(
      builder: (context, model, _) {
        return NestedNavigation(
          onRefresh: () async {
            model.loadData(refresh: true);
          },
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
              child: HeadingWithSubtitle(
                heading: "GPA Estimator",
                subtitle:
                    "Estimate your GPA and CGPA by plotting your expected result",
              ),
            ),
            SizedBox(
              height: kTitleGutter,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
              child: Row(
                children: [
                  _buildGPACard(
                    gpa: model.gpa.toStringAsFixed(3),
                    subtitle: "ESTIMATED GPA",
                    loading: model.isBusy,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  _buildGPACard(
                      gpa: model.cgpa.toStringAsFixed(3),
                      subtitle: "ESTIMATED CGPA",
                      loading: model.isBusy),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            if (model.isBusy)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
                child: Loading(),
              )
            else if (model.hasError)
              Text(model.modelError.toString())
            else
              for (Register each in model?.subjects)
                Padding(
                    padding: EdgeInsets.only(
                      left: kHorizontalSpacing,
                      right: kHorizontalSpacing,
                      bottom: 15,
                    ),
                    child: CustomCard(
                      builder: (context) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            each.subjectName.split(' ').sublist(1).join(' '),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            each.subjectName.split(' ')[0],
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      each.subjectCreditHour,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "TOTAL",
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      kGradeGPAMap[model.subjectGradeMap[each]]
                                              ?.toStringAsFixed(1) ??
                                          '0.0',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "ESTIMATED",
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomDropdown(
                                  currentValue: model.subjectGradeMap[each],
                                  onSelectionChange: (v) {
                                    model.subjectGradeMap[each] = v;
                                    model.calculateResult();
                                    model.notifyListeners();
                                  },
                                  values: kGradeGPAMap.keys.toList(),
                                  color: withStaticAlpha(
                                    Theme.of(context)
                                        .primaryColor
                                        .withAlpha(10),
                                    Theme.of(context).cardColor,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ))
          ],
        );
      },
      viewModelBuilder: () => GPAEstimatorViewModel(),
      onModelReady: (model) async {
        model.loadData();
      },
    );
  }

  Flexible _buildGPACard({String subtitle, String gpa, bool loading = false}) {
    return Flexible(
      child: CustomCard(
        loading: loading,
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(
                gpa,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 45),
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        height: 130,
      ),
    );
  }
}
