import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/home_view/home_viewmodel.dart';
import 'package:uet_lms/ui/views/login_view/login_viewmodel.dart';

class HomeView extends StatelessWidget {
  static final id = "/home";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<HomeViewModel>.reactive(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MouseRegion(
                        child: GestureDetector(
                          child: SvgPicture.asset("assets/svg/menu.svg"),
                          onTap: () {
                            model.scaffold.openDrawer();
                          },
                        ),
                        cursor: SystemMouseCursors.click,
                      ),
                      Image.asset("assets/images/Logo.png"),
                      CircleAvatar(
                        radius: 17,
                        backgroundImage: NetworkImage(
                          model.user.getChangeableProfilePicUrl(),
                          headers: model.user.cookieHeader,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  HeadingWithSubtitle(
                    heading: "Welcome Talha",
                    subtitle:
                        "How’s your day goin’? Here’s some stats about your University life",
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildContainer(
                          height: 125,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("FALL 2020",
                                  style: Theme.of(context).textTheme.headline3),
                              Text("CURRENT SEMESTER",
                                  style: Theme.of(context).textTheme.subtitle1),
                              SizedBox(
                                height: 10,
                              ),
                              Text("18",
                                  style: Theme.of(context).textTheme.headline3),
                              Text("CREDIT HRS",
                                  style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      _buildContainer(
                        height: 125,
                        width: 125,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("3.7",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(fontSize: 50)),
                            Text("CGPA",
                                style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: _buildContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("CURRENT COURSES",
                              style: Theme.of(context).textTheme.subtitle1),
                          ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Text("CS-213 Programmin Languages", style: Theme.of(context).textTheme.headline4),
                            itemCount: 40,
                          ),
                        ],
                      ),
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

  Container _buildContainer({double height, double width, Widget child}) {
    return Container(
      height: height,
      width: width ?? double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: child,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [kFavBoxShadow],
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }

  Container _buildNav(BuildContext context, HomeViewModel model) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).scaffoldBackgroundColor,
      width: 300,
      child: Padding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              child: GestureDetector(
                child: SvgPicture.asset(
                  "assets/svg/cross.svg",
                  width: 25,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              cursor: SystemMouseCursors.click,
            ),
            Spacer(),
            SimpleWideButton(
              text: "Sign Out",
              onPressed: () {
                model.logout();
              },
            ),
          ],
        ),
        padding:
            EdgeInsets.symmetric(horizontal: kHorizontalSpacing, vertical: 34),
      ),
    );
  }
}

class HeadingWithSubtitle extends StatelessWidget {
  HeadingWithSubtitle(
      {Key key, @required this.heading, @required this.subtitle})
      : super(key: key);

  final String heading;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            heading,
            style: Theme.of(context).textTheme.headline1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          subtitle,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.grey[400]),
        ),
      ],
    );
  }
}
