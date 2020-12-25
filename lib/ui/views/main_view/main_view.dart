import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/shared/AnimatedIndexedStack.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/shared/NavButton.dart';
import 'package:uet_lms/ui/shared/SvgButton.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/main_view/main_view_model.dart';

class MainView extends StatelessWidget {
  static String id = "/main";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, _) {
        return KeyBoardShortcuts(
          onKeysPressed: () {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          },
          keysToPress: [LogicalKeyboardKey.escape].toSet(),
          child: Scaffold(
            key: model.scaffoldKey,
            drawerScrimColor: Colors.black12,
            drawerDragStartBehavior: DragStartBehavior.start,
            drawer: this._buildNav(context, model),
            body: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification.depth == 0) {
                      if (notification.metrics.pixels == 0 &&
                          !model.isTopBarTransparent) {
                        model.isTopBarTransparent = true;
                      } else if (notification.metrics.pixels > 0 &&
                          model.isTopBarTransparent) {
                        model.isTopBarTransparent = false;
                      }
                      return true;
                    }

                    return false;
                  },
                  child: AnimatedIndexedStack(
                    index: model.index,
                    children: model.currentViews,
                  ),
                ),
                _buildTopAppBar(context, model),
              ],
            ),
          ),
        );
      },
      viewModelBuilder: () => MainViewModel(),
    );
  }

  Widget _buildTopAppBar(BuildContext context, MainViewModel model) {
    return ClipRect(
      child: BackdropFilter(
        filter: model.isTopBarTransparent
            ? ImageFilter.blur()
            : ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: kAppBarHeight,
          decoration: BoxDecoration(
            color: model.isTopBarTransparent
                ? Colors.transparent
                : Colors.grey[100].withAlpha(100),
            boxShadow: model.isTopBarTransparent ? [] : [kFavBoxShadow],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: kHorizontalSpacing,
                  ),
                  child: SvgButton(
                    color: model.isTopBarTransparent ? Colors.grey[200] : Colors.transparent,
                    asset: "assets/svg/menu.svg",
                    onTap: () {
                      model.scaffold.openDrawer();
                    },
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kHorizontalSpacing),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      model.lmsService.user.getChangeableProfilePicUrl(),
                      headers: model.lmsService.user.cookieHeader,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNav(BuildContext context, MainViewModel model) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      width: 300,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: kAppBarHeight),
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
                      int idx = model.views.indexWhere(
                        (dynamic element) {
                          return navLink["children"][i]["screen"] != null &&
                              element.id == navLink["children"][i]["screen"].id;
                        },
                      );
                      if (idx != -1 && idx != model.index) {
                        model.setIndex(idx);
                      }
                    },
                    title: navLink["children"][i]["name"],
                    isActive: model.views.indexWhere(
                          (dynamic element) {
                            return navLink["children"][i]["screen"] != null &&
                                element.id ==
                                    navLink["children"][i]["screen"].id;
                          },
                        ) ==
                        model.index,
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
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                    left: kHorizontalSpacing,
                    top: MediaQuery.of(context).padding.top),
                height: kAppBarHeight,
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
                    horizontal: kHorizontalSpacing, vertical: 20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                  child: SimpleWideButton(
                    text: "Sign Out",
                    onPressed: () {
                      model.lmsService.logout();
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
