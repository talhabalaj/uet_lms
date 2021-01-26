import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:uet_lms/ui/views/splash_view/spash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  static final id = "/";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, _) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: !model.internet
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              SizedBox(height: 30),
              if (!model.internet) ...[
                Text(
                  "sad, i can't connect to internet",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30),
              ],
              Flexible(
                child: Lottie.asset(
                  "assets/lottie/${model.internet ? "loading" : "no-internet"}.json",
                  fit: BoxFit.scaleDown,
                ),
              ),
              if (model.internet)
                Shimmer(
                  child: Text(
                    "dOwnLoaDing nuCLEAr COdes",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
            ],
          ),
        );
      },
      onModelReady: (model) async {
        await model.initialise();
      },
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}