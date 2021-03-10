import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/models/NestedRoute.dart';
import 'package:uet_lms/core/services/ThemeService.dart';
import 'package:uet_lms/ui/shared/AnimatedIndexedStack.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/shared/NavButton.dart';
import 'package:uet_lms/ui/shared/SvgButton.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/main_view/main_view_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class MainView extends StatelessWidget {
  static String id = "/main";

  @override
  Widget build(BuildContext context) {
    I<ThemeService>().theme = Theme.of(context);
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, _) {
        return WillPopScope(
          onWillPop: () async {
            return model.scaffold.isDrawerOpen || !model.back();
          },
          child: KeyBoardShortcuts(
            onKeysPressed: () {
              if (!model.back() && Navigator.of(context).canPop())
                Navigator.of(context).pop();
            },
            keysToPress: [LogicalKeyboardKey.escape].toSet(),
            child: LayoutBuilder(builder: (context, constraints) {
              model.isLarge = MediaQuery.of(context).size.width > 700;

              return Scaffold(
                key: model.scaffoldKey,
                drawerScrimColor: Colors.black12,
                drawerDragStartBehavior: DragStartBehavior.start,
                drawer: model.isLarge ? null : this._buildNav(context, model),
                body: Row(
                  children: [
                    if (model.isLarge) this._buildNav(context, model),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Stack(
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
                              animationReversed: model.isReverse,
                            ),
                          ),
                          _buildTopAppBar(context, model),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
      viewModelBuilder: () => MainViewModel(),
      onModelReady: (model) {
        model.requestReview();
      },
    );
  }

  Widget _buildTopAppBar(BuildContext context, MainViewModel model) {
    String originalUrl = model.lmsService.user?.getChangeableProfilePicUrl();
    String imageUrl;
    if (originalUrl != null) {
      imageUrl = '$originalUrl&v=${model.dpChangeTimes.toString()}';
    }

    return ClipRect(
      child: BackdropFilter(
        filter: model.isTopBarTransparent
            ? ImageFilter.blur()
            : ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: kAppBarHeight + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: model.isTopBarTransparent
                ? Colors.transparent
                : Theme.of(context).backgroundColor.withAlpha(100),
            boxShadow: model.isTopBarTransparent ? [] : [kFavBoxShadow],
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top != 0
                    ? MediaQuery.of(context).padding.top - 5
                    : 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!model.isLarge)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kHorizontalSpacing,
                    ),
                    child: SvgButton(
                      color:
                          model.isTopBarTransparent ? null : Colors.transparent,
                      asset: "assets/svg/menu.svg",
                      onTap: () async {
                        // open the drawer
                        model.scaffold.openDrawer();

                        // close the keyboard if opened
                        FocusScope.of(context).requestFocus(new FocusNode());

                        // scroll to the active link
                        await model.navScrollController.scrollToIndex(
                          model.scrollIdx,
                          duration: Duration(microseconds: 1),
                        );

                        // need to scroll more
                        if (model.scrollIdx > 2) {
                          model.navScrollController.jumpTo(
                            model.navScrollController.offset + 100,
                          );
                        }
                      },
                    ),
                  ),
                Spacer(),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 8,
                      ),
                      child: Text(
                        "BETA",
                        style: TextStyle(color: Colors.red),
                      ),
                      color: Colors.red.withAlpha(50),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(right: kHorizontalSpacing, left: 10),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            Theme.of(context).accentColor.withAlpha(50),
                        backgroundImage: imageUrl == null
                            ? null
                            : NetworkImage(
                                imageUrl,
                                headers: model.lmsService.user?.cookieHeader,
                              ),
                      ),
                    ),
                  ],
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
      color: Theme.of(context).cardColor,
      width: 300,
      child: Stack(
        children: [
          ListView(
            controller: model.navScrollController,
            children: [
              if (!model.isLarge) SizedBox(height: kAppBarHeight),
              for (final each in kMainViewNestedNavLinks.asMap().entries) ...[
                if (each.value.category != "" &&
                    kMainViewNestedNavLinks[each.key - 1].category !=
                        each.value.category)
                  Padding(
                    padding:
                        EdgeInsets.only(left: kHorizontalSpacing, bottom: 5),
                    child: Text(
                      each.value.category,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                Builder(builder: (context) {
                  int idx = each.key;
                  NestedRoute value = each.value;

                  return AutoScrollTag(
                    index: idx,
                    key: ValueKey(idx),
                    controller: model.navScrollController,
                    child: NavButton(
                      newTag: value.newFeature,
                      disabled: value.screenName == null,
                      onTap: () {
                        // close the drawer
                        if (!model.isLarge) Navigator.of(context).pop();

                        // set active
                        model.setActiveScreen(idx, each.value.screenName);
                      },
                      title: value.title,
                      isActive: idx == model.scrollIdx,
                      subtitle: value.description,
                    ),
                  );
                }),
                SizedBox(
                  height: 10,
                ),
              ],
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
          if (!model.isLarge)
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                      left: kHorizontalSpacing,
                      top: MediaQuery.of(context).padding.top != 0
                          ? MediaQuery.of(context).padding.top - 5
                          : 5),
                  height: kAppBarHeight + MediaQuery.of(context).padding.top,
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
        ],
      ),
    );
  }
}
