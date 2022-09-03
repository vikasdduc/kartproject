import 'package:flutter/material.dart';

class SizeConfig{

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData?.size.height;
    screenWidth = _mediaQueryData?.size.width;
    orientation = _mediaQueryData?.orientation;
  }

  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;


}

double getProportionateScreenHeight(double inputHeight){
  double? screenHeight = SizeConfig.screenHeight;

  return (inputHeight/812.0)*screenHeight!;
}

double getProportionateScreenWidth(double inputWidth){
  double? screenWidth = SizeConfig.screenWidth;

  return (inputWidth/812.0)*screenWidth!;
}


