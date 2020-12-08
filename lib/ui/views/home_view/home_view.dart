import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/shared/DefaultShimmer.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/SvgButton.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/home_view/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  static final id = "/home";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<HomeViewModel>.reactive(
        onModelReady: (model) async {
          await model.init();
        },
        builder: (context, model, _) {
          return Scaffold(
            key: model.scaffoldKey,
            drawerScrimColor: Colors.black26,
            drawerDragStartBehavior: DragStartBehavior.start,
            drawer: _buildNav(context, model),
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: kHorizontalSpacing, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopAppBar(model, context),
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
                    child: _buildCard(
                      padding: EdgeInsets.zero,
                      child: _buildRegisteredSubjectsScrollView(context, model),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => HomeViewModel(),
      ),
    );
  }

  Widget _buildTopAppBar(HomeViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgButton(
            asset: "assets/svg/menu.svg",
            onTap: () {
              model.scaffold.openDrawer();
            },
          ),
          Image.asset("assets/images/Logo.png"),
          CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(
              model.user.getChangeableProfilePicUrl(),
              headers: model.user.cookieHeader,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildStatCard(HomeViewModel model, BuildContext context) {
    return _buildCard(
      height: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (model.busy(model.lastSemester))
            ..._cardShimmers(context)
          else ...[
            Text(model.lastSemester.name.toUpperCase(),
                style: Theme.of(context).textTheme.headline3),
            Text("CURRENT SEMESTER",
                style: Theme.of(context).textTheme.subtitle1),
          ],
          SizedBox(
            height: 10,
          ),
          if (model.busy(model.lastSemester))
            ..._cardShimmers(context)
          else ...[
            Text(model.lastSemester.registeredCreditHours.toInt().toString(),
                style: Theme.of(context).textTheme.headline3),
            Text("CREDIT HRS", style: Theme.of(context).textTheme.subtitle1),
          ]
        ],
      ),
    );
  }

  Container _buildGPACard(HomeViewModel model, BuildContext context) {
    final cardSize = 125.0;
    final gpaCardShimmers = [
      ..._cardShimmers(context),
      SizedBox(
        height: 10,
      ),
      ..._cardShimmers(context),
    ];

    final gpaDetails = () => <Widget>[
          Text(
            model.lastGradeBookDetail.cgpa.toStringAsFixed(1),
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 50),
          ),
          Text(
            "CGPA",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ];

    return _buildCard(
      height: cardSize,
      width: cardSize,
      child: Column(
          mainAxisAlignment: model.busy(model.lastGradeBookDetail)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: model.busy(model.lastGradeBookDetail)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: model.busy(model.lastGradeBookDetail)
              ? gpaCardShimmers
              : gpaDetails()),
    );
  }

  Widget _buildRegisteredSubjectsScrollView(
      BuildContext context, HomeViewModel model) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, idx) => Padding(
                    padding: idx == 0
                        ? const EdgeInsets.only(top: 40.0)
                        : const EdgeInsets.only(top: 15.0),
                    child: model.busy(model.registerdSubjects)
                        ? Opacity(
                            opacity: (1 - (idx + 1) / 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _cardShimmers(context),
                            ),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.registerdSubjects[idx].subjectName,
                                      style:
                                          Theme.of(context).textTheme.headline4,
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          TextSpan(
                                            text: model.registerdSubjects[idx]
                                                .teacherName
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
                              IconButton(
                                  icon: Icon(Icons.chevron_right),
                                  onPressed: () {})
                            ],
                          ),
                  ),
                  childCount: model.busy(model.registerdSubjects)
                      ? 5
                      : model.registerdSubjects.length,
                ),
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(200),
          ),
          width: double.infinity,
          child: ClipRect(
            child: Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 10, left: 15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Text(
                  "CURRENT COURSES",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _cardShimmers(BuildContext context) {
    return [
      _buildFlexibleShimmers(
        context,
        shimmerFlex: 5,
        spacerFlex: 5,
        height: Theme.of(context).textTheme.headline3.fontSize - 5,
      ),
      _buildFlexibleShimmers(context,
          shimmerFlex: 7,
          spacerFlex: 3,
          height: Theme.of(context).textTheme.subtitle1.fontSize),
    ];
  }

  Widget _buildFlexibleShimmers(BuildContext context,
      {@required int shimmerFlex,
      @required int spacerFlex,
      @required double height}) {
    return Row(
      children: [
        Flexible(
          child: DefaultShimmer(
            margin: null,
            height: height,
          ),
          flex: shimmerFlex,
        ),
        Spacer(
          flex: spacerFlex,
        )
      ],
    );
  }

  Widget _buildCard(
      {double height, double width, Widget child, EdgeInsets padding}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      child: Padding(
        padding: padding ?? EdgeInsets.all(15.0),
        child: child,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [kFavBoxShadow],
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Widget _buildNav(BuildContext context, HomeViewModel model) {
    List<Map<String, dynamic>> navLinks = [
      {
        "name": "",
        "children": [
          {
            "name": "Dashboard",
            "screen": HomeView.id,
            "description":
                "See at a glance what’s up with your University, Current semester, CGPA, etc"
          },
        ],
      },
      {
        "name": "ACADEMIC",
        "children": [
          {
            "name": "Register subjects",
            "description":
                "Register subjects you want to study in this semester"
          },
          {
            "name": "DMC",
            "description":
                "Check your grades and stuff. you can the usual, best of luck tho"
          },
        ],
      },
      {
        "name": "DUES",
        "children": [
          {
            "name": "Fee Challans",
            "description":
                "Check if your fees is paid or new challan form is available",
          },
        ],
      },
      {
        "name": "INFORMATION",
        "children": [
          {
            "name": "Student Profile",
            "description": "Check the information, University has on you."
          },
        ],
      },
      {
        "name": "SETTINGS",
        "children": [
          {
            "name": "App Settings",
            "description": "The usual thing to have in an app"
          },
          {
            "name": "LMS Settings",
            "description":
                "Change you profile picture, password and other stuff"
          },
        ],
      },
    ];

    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      width: 300,
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 90),
              Expanded(
                child: ListView(
                  children: [
                    for (final navLink in navLinks) ...[
                      if (navLink["name"] != "")
                        Padding(
                          padding: EdgeInsets.only(
                              left: kHorizontalSpacing, bottom: 5),
                          child: Text(navLink["name"],
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                      for (int i = 0; i < navLink["children"].length; i++) ...[
                        if (i != 0) SizedBox(height: 7),
                        NavButton(
                          onTap: () {
                            print("Test");
                          },
                          title: navLink["children"][i]["name"],
                          isActive: navLink["children"][i]["screen"] != null &&
                              navLink["children"][i]["screen"] ==
                                  ModalRoute.of(context).settings.name,
                          subtitle: navLink["children"][i]["description"],
                        ),
                      ],
                      SizedBox(
                          height:
                              navLink["children"].last["description"].length >=
                                      45
                                  ? 10
                                  : 20),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
          ClipRect(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: kHorizontalSpacing, vertical: 34),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      SvgButton(
                        asset: "assets/svg/cross.svg",
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kHorizontalSpacing, vertical: 34),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                  child: SimpleWideButton(
                    text: "Sign Out",
                    onPressed: () {
                      model.logout();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  const NavButton({
    Key key,
    this.onTap,
    this.title,
    this.subtitle,
    this.isActive = false,
  }) : super(key: key);

  final Function onTap;
  final String title;
  final String subtitle;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: onTap,
      child: Container(
        height: subtitle.length <= 45 ? 50 : 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 5,
              color: isActive
                  ? kPrimaryColor
                  : Theme.of(context).scaffoldBackgroundColor,
            ),
            SizedBox(
              width: kHorizontalSpacing - 5,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: kHorizontalSpacing),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                      color: isActive ? kPrimaryColor : Color(0xff6b6b6b)),
                  child: Builder(
                      builder: (context) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                this.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2
                                    .copyWith(
                                        color: DefaultTextStyle.of(context)
                                            .style
                                            .color),
                              ),
                              Text(
                                this.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 11,
                                      color: DefaultTextStyle.of(context)
                                          .style
                                          .color,
                                    ),
                              )
                            ],
                          )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
