import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/home_view/home_viewmodel.dart';
import 'package:uet_lms/ui/shared/CardScrollView.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/RefreshIndicatorWithoutListView.dart';
import 'package:uet_lms/ui/shared/SplitScreen.dart';
import 'package:uet_lms/ui/ui_constants.dart';

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
              onRefresh: () => model.loadData(),
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
      loading: model.busy(model.lastSemester),
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(model.lastSemester.name.toUpperCase(),
              style: Theme.of(context).textTheme.headline3),
          Text("CURRENT SEMESTER",
              style: Theme.of(context).textTheme.subtitle1),
          SizedBox(
            height: 10,
          ),
          Text(
            model.lastSemester.registeredCreditHours.toInt().toString(),
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            "CREDIT HRS",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _buildGPACard(HomeViewModel model, BuildContext context) {
    final cardSize = 130.0;

    return CustomCard(
      height: cardSize,
      width: cardSize,
      loading: model.busy(model.lastGradeBookDetail),
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            model.lastGradeBookDetail?.cgpa?.toStringAsFixed(1),
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
      title: "CURRENT COURSES",
      childCount: model.registerdSubjects?.length,
      loading: model.busy(model.registerdSubjects),
      builder: (context, idx) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.registerdSubjects[idx].subjectName,
                  style: Theme.of(context).textTheme.headline4,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 3,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "BEGIN TAUGHT BY ",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      TextSpan(
                        text: model.registerdSubjects[idx].teacherName
                            .toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(color: kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.chevron_right), onPressed: () {})
        ],
      ),
    );
  }
}
