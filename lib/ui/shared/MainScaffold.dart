import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/shared/NavButton.dart';
import 'package:uet_lms/ui/shared/SvgButton.dart';
import 'package:uet_lms/ui/ui_constants.dart';

class MainScaffold extends StatefulWidget {
  MainScaffold({Key key, this.children}) : super(key: key);

  final List<Widget> children;

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LMSService lmsService = locator<LMSService>();

  get scaffold => scaffoldKey.currentState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawerScrimColor: Colors.black26,
      drawerDragStartBehavior: DragStartBehavior.start,
      drawer: this._buildNav(),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: kHorizontalSpacing, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildTopAppBar(), ...widget.children],
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgButton(
            asset: "assets/svg/menu.svg",
            onTap: () {
              scaffold.openDrawer();
            },
          ),
          Image.asset("assets/images/Logo.png"),
          CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(
              lmsService.user.getChangeableProfilePicUrl(),
              headers: lmsService.user.cookieHeader,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNav() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      width: 300,
      child: Stack(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 90),
                for (final navLink in kNavLinks) ...[
                  if (navLink["name"] != "")
                    Padding(
                      padding:
                          EdgeInsets.only(left: kHorizontalSpacing, bottom: 5),
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
                          navLink["children"].last["description"].length >= 45
                              ? 10
                              : 20),
                ],
                SizedBox(height: 100),
              ],
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                child: SvgButton(
                  asset: "assets/svg/cross.svg",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
          Align(
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
                      lmsService.logout();
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
