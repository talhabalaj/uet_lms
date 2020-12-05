import 'package:flutter/material.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/shared/CutsomTextField.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/login_view/login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, _) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Image.asset("assets/images/Login_TopImage.png"),
              _buildBody(context, model)
            ],
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }

  Widget _buildBody(BuildContext context, LoginViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 20, horizontal: kHorizontalSpacing),
          child: _buildHeader(context),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 40, horizontal: kHorizontalSpacing),
              child: _buildForm(context, model),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kHorizontalSpacing, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shield, color: Colors.green[400]),
              SizedBox(
                width: 5,
              ),
              Flexible(
                child: Text(
                  'Your password is securely stored on-device',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/Logo.png",
                  height: 48,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    "UNIVERSITY OF ENGINEERING AND TECHNOLOGY, LAHORE",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Let's Sign you In",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 9,
            ),
            Text(
              "You have to sign in use LMS services, This should just take a second",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        );
  }

  Widget _buildForm(BuildContext context, LoginViewModel model) {
    return Form(
      key: model.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            labelText: "Registration #",
            suffixText: "@student.uet.edu.pk",
            hintText: "U know it, right?",
            enabled: !model.isBusy,
            onSaved: (value) => model.regNo = value.trim(),
            style: Theme.of(context).textTheme.bodyText1,
            errorText: "That's not valid, try similar to this 2018cs653",
            regex: RegExp("20[0-9]{2}[A-Za-z]{2,5}[0-9]{2,3}"),
          ),
          SizedBox(
            height: 22,
          ),
          CustomTextField(
            labelText: "Password",
            style: Theme.of(context).textTheme.bodyText1,
            enabled: !model.isBusy,
            onSaved: (value) => model.password = value.trim(),
            hintText: "the secret passphrase",
            isPassword: true,
          ),
          SizedBox(
            height: 30,
          ),
          SimpleWideButton(
            text: "Sign In",
            loading: model.isBusy,
            onPressed: model.isBusy
                ? null
                : () async {
                    await model.login();
                  },
          ),
        ],
      ),
    );
  }
}
