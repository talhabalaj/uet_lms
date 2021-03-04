import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/views/splash_view/spash_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  static final id = "/";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
      builder: (context, model, _) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
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
                  // Flexible(
                  //   child: Lottie.asset(
                  //     "assets/lottie/${model.internet ? "loading" : "no-internet"}.json",
                  //     fit: BoxFit.scaleDown,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      'App is removed, as per request of UET\'s IT Deparment. Purana LMS use karo ab. 😉',
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
              if (!model.internet)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90,
                    padding: const EdgeInsets.all(20.0),
                    child: SimpleWideButton(
                      text: 'Retry',
                      loading: model.isBusy,
                      onPressed: () {
                        model.initialise();
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      onModelReady: (model) async {
        //await model.initialise();
      },
      viewModelBuilder: () => SplashViewModel(),
    );
  }
}
