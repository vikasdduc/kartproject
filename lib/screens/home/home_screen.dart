import 'package:flutter/material.dart';
import 'package:kartforyou/size_config.dart';
import '';
import '';

class HomeScreen extends StatelessWidget{

  static const String routeName ="/home";
  @override
  Widget build (BuildContext context){
    SizeConfig().init(context);
    return Scaffold(
      //body: Body(),
      //drawer: HomeScreenDrawer(),
    );
  }
}