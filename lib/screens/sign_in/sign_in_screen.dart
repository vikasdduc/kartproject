import 'package:flutter/material.dart';
import 'package:kartforyou/screens/forget_password/components/body.dart';
import 'package:kartforyou/size_config.dart';

class SignInScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
    appBar: AppBar(),
    body: Body(),
    );
  }
}