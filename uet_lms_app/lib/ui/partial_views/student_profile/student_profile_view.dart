import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/DataService.dart';
import 'package:uet_lms/ui/partial_views/student_profile/student_profile_viewmodel.dart';
import 'package:uet_lms/ui/shared/CustomCard.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/Loading.dart';
import 'package:uet_lms/ui/shared/NestedNavigation.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import '../../../core/string_extension.dart';

class StudentProfileView extends StatelessWidget {
  final id = "/student_profile";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StudentProfileViewModel>.reactive(
      onModelReady: (model) {
        model.loadData();
      },
      viewModelBuilder: () => StudentProfileViewModel(),
      builder: (context, model, _) => NestedNavigation(
        onRefresh: () async {
          await model.loadData(refresh: true);
        },
        children: [
          if (model.hasError)
            Center(
              child: Text(model.modelError.toString()),
            )
          else if (model.isBusy)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
              child: Column(
                children: [
                  HeadingWithSubtitle(),
                  SizedBox(
                    height: kTitleGutter,
                  ),
                  Loading(),
                ],
              ),
            )
          else ...[
            CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).accentColor.withAlpha(40),
              child: ClipOval(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    I<DataService>().user.getProfilePictureURL(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    model.profile.name.capitalize(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model.profile.rollNo,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor.withAlpha(180),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      model.profile.admissionCategory?.name,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PERSONAL DETAILS',
                      style: Theme.of(context).textTheme.headline5),
                  SizedBox(
                    height: 10,
                  ),
                  CustomCard(
                    builder: (context) {
                      return CustomScrollView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverGrid.count(
                            crossAxisCount: 2,
                            childAspectRatio: 16 / 5,
                            crossAxisSpacing: 8,
                            children: [
                              _buildinfoColumn(
                                context,
                                "FATHER NAME",
                                model.profile.fatherName.capitalize(),
                              ),
                              _buildinfoColumn(
                                context,
                                "CNIC",
                                model.profile.cnic,
                              ),
                              _buildinfoColumn(
                                context,
                                "GENDER",
                                model.profile.gender,
                              ),
                              _buildinfoColumn(
                                context,
                                "IS HOSTILIZED",
                                model.profile.isHostelise ? "Yes" : "No",
                              ),
                              _buildinfoColumn(
                                context,
                                "DATE OF BIRTHDAY",
                                model.profile.dateOfBirth,
                              ),
                              _buildinfoColumn(
                                context,
                                "DISTRICT",
                                model.profile.district?.name,
                              ),
                              _buildinfoColumn(
                                context,
                                "CONTACT #1",
                                model.profile.contactNumber1,
                              ),
                              _buildinfoColumn(
                                context,
                                "CONTACT #2",
                                model.profile.contactNumber2,
                              ),
                            ],
                          ),
                          SliverToBoxAdapter(
                            child: _buildinfoColumn(
                              context,
                              "SESSION",
                              model.profile.session?.name,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 15,
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: _buildinfoColumn(
                              context,
                              "CAMPUS",
                              model.profile.campus?.name,
                            ),
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (model.profile.isHostelise)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HOSTEL DETAILS',
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(
                      height: 10,
                    ),
                    CustomCard(
                      builder: (context) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: 16 / 3,
                              children: [
                                _buildinfoColumn(
                                  context,
                                  "HALL NAME",
                                  model.profile.hostel?.name,
                                ),
                                _buildinfoColumn(
                                  context,
                                  "ROOM #",
                                  model.profile.room?.name,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'ROOMMATES (ON LMS)',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withAlpha(150),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            for (final each in model.hostelAllocationDetail)
                              Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Theme.of(context)
                                          .accentColor
                                          .withAlpha(40),
                                      child: ClipOval(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            I<DataService>()
                                                .user
                                                .getProfilePictureURL(
                                                    stdid: each.studentId.id),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      each.name.capitalize(),
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
          ],
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildinfoColumn(BuildContext context, String heading, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Theme.of(context).primaryColor.withAlpha(150),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
