import 'package:flutter/material.dart';
import 'package:lms_app/ui/views/splash_view/spash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, _) {
        if (model.initialised) {
          
        }

        return Center(child: CircularProgressIndicator());
      },
      onModelReady: (model) async {
        await model.initialise();
      },
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
