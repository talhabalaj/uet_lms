
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(model.internet ? "LOADING YOUR STUFF" : "NO INTERNET, BRO. ", style: TextStyle(fontSize: 20)),
              SizedBox(height: 30),
              Lottie.asset("assets/lottie/${model.internet ? "loading" : "no-internet"}.json", fit: BoxFit.contain),
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
