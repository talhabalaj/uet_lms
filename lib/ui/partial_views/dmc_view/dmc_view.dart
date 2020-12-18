import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/dmc_view/dmc_view_model.dart';
import 'package:uet_lms/ui/shared/CustomDropDown.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/RefreshIndicatorWithoutListView.dart';
import 'package:uet_lms/ui/shared/SplitScreen.dart';
import 'package:uet_lms/ui/ui_constants.dart';

class DMCView extends StatelessWidget {
  String id = "/dmc";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DMCViewModel>.reactive(
      onModelReady: (model) => model.loadData(),
      builder: (context, model, _) => SplitScreen(
        leftView: RefreshIndicatorWithoutListView(
          onRefresh: () {
            return model.loadData();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
            child: Column(
              children: [
                SizedBox(height: kAppBarHeight),
                HeadingWithSubtitle(
                  heading: "DMC",
                  subtitle:
                      "Check your grades and stuff. you can the usual, best of luck tho",
                ),
                SizedBox(height: 30,),
                CustomDropdown()
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => DMCViewModel(),
    );
  }
}
