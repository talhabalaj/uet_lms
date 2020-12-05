import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/views/home_view/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ViewModelBuilder<HomeViewModel>.reactive(
        builder: (context, model, _) {
          return Scaffold(
            body: Column(
              children: [
                Text(model.lmsService.user.email),
                SimpleWideButton(text: "logout", onPressed: () async {
                  await model.lmsService.logout();
                },),
              ],
            ),
          );
        },
        viewModelBuilder: () => HomeViewModel(),
      ),
    );
  }
}
