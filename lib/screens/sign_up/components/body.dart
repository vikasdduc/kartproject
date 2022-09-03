import 'package:flutter/material.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/screens/sign_up/components/sign_up_form.dart';
import 'package:kartforyou/size_config.dart';

class Body extends StatelessWidget{
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: SingleChildScrollView(
         physics: BouncingScrollPhysics(),
         child: SizedBox(
           width: double.infinity,
           child: Column(
             children: [
               SizedBox(height: SizeConfig.screenHeight! * 0.02),
               Text("Register Account",
               style: headingStyle,
               ),
               const Text(
                 "Complete your Details or continue \n with social media",
                 textAlign: TextAlign.center,
               ),
               SizedBox(height: SizeConfig.screenHeight! * 0.07),
               SignUpForm(),
               SizedBox(height: getProportionateScreenHeight(20)),
               const Text(
                 "By Continuing your confirm that you agree \nwith our Terms and Conditions ",
                 textAlign: TextAlign.center,
               ),
               SizedBox(height: getProportionateScreenHeight(20)),
             ],
           ),
         ),
        ));
  }
}