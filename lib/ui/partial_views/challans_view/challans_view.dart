import 'package:flutter/material.dart';
import 'package:lms_api/models/obe.dues.students.challan.dart';
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
      onModelReady: (model) => model.initialize(),
      builder: (context, model, _) {
        return SplitScreen(
          leftView: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
                child: HeadingWithSubtitle(
                heading: "Fee Challans",
                subtitle:
                    "Check if your fees is paid or new challan form is available",
              ),
              ),
              
              SizedBox(height: 30,),
              if (model.isBusy)
                _buildChallan(context, null)
              else for (Challan challan in model.challans)  
                _buildChallan(context, challan)
            ],
          ),
        );
      },
      viewModelBuilder: () => ChallansViewModel(),
    );
  }

  Widget _buildChallan(BuildContext context, Challan challan) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0, left: kHorizontalSpacing, right: kHorizontalSpacing),
      child: Container(
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
                            text: challan.challanCode,
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
                        challan.name),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTextColumn(context, "DUE DATE", challan.dueDate),
                        _buildTextColumn(context, "PAID DATE", challan.isPaid ? challan.paidDate : "-"),
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
                            Icon(  challan.isPaid ? Icons.check_circle_rounded : Icons.cancel,
                                color:  challan.isPaid ? Colors.green : Colors.red),
                            SizedBox(width: 5),
                            Text(
                              "${challan.isPaid ? "" : "UN"}PAID",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: challan.isPaid ? Colors.green : Colors.red),
                            ),
                          ],
                        ),
                        Text("Rs. ${challan.total.toInt()}",
                            style: Theme.of(context).textTheme.headline2)
                      ],
                    ),
                  ],
                ),
              ),
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
