import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/shared/CutsomTextField.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/login_view/login_viewmodel.dart';
import 'package:stacked/stacked.dart';


class LoginView extends StatelessWidget {
  static final id = "/login";

  @override
  Widget build(BuildContext context) {
    bool large = MediaQuery.of(context).size.width > 1000;

    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, _) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Theme.of(context).backgroundColor.withAlpha(100), BlendMode.overlay, ),
                child: Image.asset(
                  "assets/images/Login_TopImage${large ? "_Desktop" : ""}.png",
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ),
            _buildBody(context, model, large: large),
          ],
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }

  Widget _buildBody(BuildContext context, LoginViewModel model,
      {bool large = false}) {
    return Container(
      constraints: large ? BoxConstraints(maxWidth: 412) : null,
      padding: MediaQuery.of(context).padding,
      color: large ? Theme.of(context).backgroundColor : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          large ? _buildLargerHeader(context) : _buildSmallHeader(context),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                top: large ? 0 : 40,
                left: kHorizontalSpacing,
                right: kHorizontalSpacing,
              ),
              decoration: large
                  ? null
                  : BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(36),
                    ),
              child: _buildForm(context, model),
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
      ),
    );
  }

  Widget _buildLargerHeader(BuildContext context) {
    return Flexible(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: kHorizontalSpacing, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/images/Logo.png",
              height: 70,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "UNIVERSITY OF ENGINEERING AND TECHNOLOGY, LAHORE",
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSmallHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: kHorizontalSpacing,
      ),
      child: Column(
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
      ),
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
