import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/app_settings_view/app_settings_viewmodel.dart';
import 'package:uet_lms/ui/shared/CustomDropDown.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/NestedNavigation.dart';
import 'package:uet_lms/ui/ui_constants.dart';

class AppSettingsView extends StatelessWidget {
  final id = "/app_settings";

  @override
  Widget build(BuildContext context) {
    final infoTextStyle = TextStyle(fontSize: 16, color: Colors.grey[500]);
    final infoBoldTextStyle =
        infoTextStyle.copyWith(fontWeight: FontWeight.bold);
    return ViewModelBuilder<AppSettingsViewModel>.reactive(
      builder: (context, model, child) {
        return NestedNavigation(
          onRefresh: () async {
            model.loadData();
          },
          children: [
            HeadingWithSubtitle(
              heading: "App Settings",
              subtitle: "You know, the usuals",
            ),
            SizedBox(height: kTitleGutter),
            _buildSmallHeadingText("THEME"),
            CustomDropdown(
              values: ["light", "dark", "system"],
              currentValue: model.themeService.themeName,
              onSelectionChange: (v) async {
                await model.updateTheme(v);
                Phoenix.rebirth(context);
              },
            ),
            SizedBox(
              height: 20,
            ),
            _buildSmallHeadingText("NOTIFICATIONS"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Get notifications when new Grades are published.",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Switch.adaptive(
                  value: model.preferences.notifyGradeUpdate,
                  onChanged: model.setNotifyGradePreference,
                  activeColor: Theme.of(context).accentColor,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (!model.isBusy && model.packageInfo != null) ...[
              _buildSmallHeadingText("INFO"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "App Version",
                    style: infoBoldTextStyle,
                  ),
                  Text(
                    model.packageInfo.version,
                    style: infoTextStyle,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Build Number",
                    style: infoBoldTextStyle,
                  ),
                  Text(
                    model.packageInfo.buildNumber,
                    style: infoTextStyle,
                  )
                ],
              ),
            ],
          ]
              .map((e) => Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kHorizontalSpacing,
                    ),
                    child: e,
                  ))
              .toList(),
        );
      },
      onModelReady: (model) {
        model.loadData();
      },
      viewModelBuilder: () => AppSettingsViewModel(),
    );
  }

  Padding _buildSmallHeadingText(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[500],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
