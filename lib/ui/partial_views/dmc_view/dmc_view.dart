import 'package:flutter/material.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/dmc_view/dmc_view_model.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';
import 'package:uet_lms/ui/shared/CustomDropDown.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/RefreshIndicatorWithoutListView.dart';
import 'package:uet_lms/ui/shared/SplitScreen.dart';
import 'package:uet_lms/ui/ui_constants.dart';
class DMCView extends StatelessWidget {
  final String id = "/dmc";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DMCViewModel>.reactive(
      onModelReady: (model) => model.loadData(),
      builder: (context, model, _) {
        final results = model.result;
        return SplitScreen(
        leftView: RefreshIndicator(
          onRefresh: () {
            return model.loadData(refresh: true);
          },
          child: ListView(
            children:  [
                  SizedBox(height: kAppBarHeight),
                  HeadingWithSubtitle(
                    heading: "DMC",
                    subtitle:
                        "Check your grades and stuff. you can the usual, best of luck tho",
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if (!model.isBusy)...[
                    CustomDropdown(
                      values: model.registeredSemesters.map((e) => e.name).toList(),
                      currentValue: model.selectedSemester,
                      selected: (value) => model.selectedSemester = value,
                    ), 

                    for (Result result in results)
                     CustomCard(
                       builder: (context) => Row(children: [
                         Text("${result.grade} ${result.subject.name} ${result.weightage}")
                       ],),
                     )
                    
                    ]
                  else
                    Lottie.asset("assets/lottie/loading.json")
                ],
              ),
        ),
      );
      },
      viewModelBuilder: () => DMCViewModel(),
    );
  }
}
