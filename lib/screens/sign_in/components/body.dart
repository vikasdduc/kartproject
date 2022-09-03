import 'package:flutter/material.dart';
import 'package:kartforyou/components/no_account_text.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/size_config.dart';

class Body extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox( height: SizeConfig.screenHeight!*0.04),
                  Text(
                    "Welcome Back",
                  style: headingStyle,
                  ),
                  Text(
                      "Sign in With your Email and Password",
                  textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight!*0.08,)
                  SignInForm(),
                  SizedBox(height: SizeConfig.screenHeight!*0.08,)
                  NoAccountText(),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
          ),
        )
    );
  }
}