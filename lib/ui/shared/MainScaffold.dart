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
  MainScaffold({Key key, this.views}) : super(key: key);

  final List<Widget> views;

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LMSService lmsService = locator<LMSService>();
  int index = 0;

  get scaffold => scaffoldKey.currentState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawerScrimColor: Colors.black26,
      drawerDragStartBehavior: DragStartBehavior.start,
      drawer: this._buildNav(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopAppBar(),
          Expanded(
            child: IndexedStack(
              index: index,
              children: widget.views,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kHorizontalSpacing,
            ),
            child: SvgButton(
              asset: "assets/svg/menu.svg",
              onTap: () {
                scaffold.openDrawer();
              },
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                lmsService.user.getChangeableProfilePicUrl(),
                headers: lmsService.user.cookieHeader,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNav() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      width: 300,
      child: Stack(
        children: [
          ListView(
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
                      Navigator.of(context).pop();
                      int idx = widget.views.indexWhere(
                        (dynamic element) {
                          return navLink["children"][i]["screen"] != null &&
                              element.id == navLink["children"][i]["screen"].id;
                        },
                      );
                      print(idx);
                      if (idx != -1 && idx != index) {
                        this.setState(() {
                          index = idx;
                        });
                      }
                    },
                    title: navLink["children"][i]["name"],
                    isActive: widget.views.indexWhere(
                          (dynamic element) {
                            return navLink["children"][i]["screen"] != null &&
                                element.id ==
                                    navLink["children"][i]["screen"].id;
                          },
                        ) ==
                        index,
                    subtitle: navLink["children"][i]["description"],
                  ),
                ],
                SizedBox(
                  height: navLink["children"].last["description"].length >= 45
                      ? 10
                      : 20,
                ),
              ],
              SizedBox(height: 120),
            ],
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 34, left: kHorizontalSpacing),
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
