import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_shortcuts/keyboard_shortcuts.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/shared/MainScaffold.dart';
import 'package:uet_lms/ui/views/main_view/main_view_model.dart';

class MainView extends StatelessWidget {
  static String id = "/main";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      builder: (context, model, _) {
        return KeyBoardShortcuts(
          globalShortcuts: true,
          onKeysPressed: () { if (Navigator.of(context).canPop()) Navigator.of(context).pop(); },
          keysToPress: [LogicalKeyboardKey.escape].toSet(),
          child: MainScaffold(
            views: model.views,
          ),
        );
      },
      viewModelBuilder: () => MainViewModel(),
    );
  }
}
