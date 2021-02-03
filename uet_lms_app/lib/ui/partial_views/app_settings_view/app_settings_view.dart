import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/services/ThemeService.dart';
import 'package:uet_lms/ui/partial_views/app_settings_view/app_settings_viewmodel.dart';
import 'package:uet_lms/ui/shared/CustomDropDown.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/NestedNavigation.dart';
import 'package:uet_lms/ui/ui_constants.dart';

class AppSettingsView extends StatelessWidget {
  final id = "/app_settings";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppSettingsViewModel>.reactive(
        builder: (context, model, child) {
          final infoTextStyle =
              TextStyle(fontSize: 16, color: Colors.grey[700]);
          final infoBoldTextStyle =
              infoTextStyle.copyWith(fontWeight: FontWeight.bold);
          return NestedNavigation(
            children: [
              HeadingWithSubtitle(
                heading: "App Settings",
                subtitle: "You know, the usuals",
              ),
              SizedBox(height: 20),
              headingText("THEME"),
              CustomDropdown(
                values: ThemeService.themes.keys.toList(),
                currentValue: model.themeService.themeName,
                selected: (v) async {
                  await model.updateTheme(v);
                  Phoenix.rebirth(context);
                },
              ),
              SizedBox(
                height: 20,
              ),
              headingText("INFO"),
              if (!model.isBusy && model.packageInfo != null) ...[
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
        onModelReady: (v) {
          v.loadData();
        },
        viewModelBuilder: () => AppSettingsViewModel());
  }

  Padding headingText(String text) {
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
