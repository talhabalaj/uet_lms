import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/SplitScreen.dart';
import 'package:uet_lms/ui/ui_constants.dart';

import 'challans_viewmodel.dart';

class ChallansView extends StatelessWidget {
  final String id = "/challans";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChallansViewModel>.reactive(
      builder: (context, model, _) {
        return SplitScreen(
          leftView: ListView(
            children: [
              HeadingWithSubtitle(
                heading: "Fee Challans",
                subtitle:
                    "Check if your fees is paid or new challan form is available",
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: [kFavBoxShadow],
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "# ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          TextSpan(
                            text: "180136530000982",
                            style:
                                Theme.of(context).textTheme.headline3.copyWith(
                                      color: Colors.grey[500],
                                    ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    _buildTextColumn(context, "CHALLAN TITLE",
                        "B.Sc Session Fall 2018 Semester 2"),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTextColumn(context, "DUE DATE", "09/11/2020"),
                        _buildTextColumn(context, "PAID DATE", "09/11/2020"),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: Colors.green),
                            SizedBox(width: 5),
                            Text(
                              "PAID",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                        Text("Rs. 38000",
                            style: Theme.of(context).textTheme.headline2)
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => ChallansViewModel(),
    );
  }

  Column _buildTextColumn(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: Theme.of(context).textTheme.subtitle1),
        Text(value, style: Theme.of(context).textTheme.headline4)
      ],
    );
  }
}
