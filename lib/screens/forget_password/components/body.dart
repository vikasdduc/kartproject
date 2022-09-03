import 'package:flutter/material.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/screens/forget_password/components/forgot_password_form.dart';
import 'package:kartforyou/size_config.dart';

class Body extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                  Text("Forget Password",
                    style: headingStyle,),
                  const Text("Please enter your email and we will send \n"
                      "you a link to return to your account ",
                  textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight!*0.1),
                  ForGotPasswordForm(),
                ],
              ),        ),
          ),
          
        ));
  }
}