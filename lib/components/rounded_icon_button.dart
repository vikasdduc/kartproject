import 'package:flutter/material.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/size_config.dart';
import 'package:kartforyou/size_config.dart';

class RoundedIconButton extends StatelessWidget{
  final IconData iconData;
  final GestureTapCallback press;
  const RoundedIconButton({
    Key? key ,
    required this.iconData,
    required this.press,
}): super(key: key);

  @override
  Widget build(BuildContext context){
    return SizedBox(
      height: getProportionateScreenHeight(40),
      width: getProportionateScreenWidth(40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          padding: EdgeInsets.zero,
          primary: Colors.white,
        ),
        onPressed: press,
        child: Icon(
          iconData,
          color: kTextColor,
        ),
      ),
    );
  }
}