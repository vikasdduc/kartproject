import 'package:flutter/material.dart';
import 'package:kartforyou/size_config.dart';
import 'package:kartforyou/constants.dart';

class DefaultButton extends StatelessWidget{
  final String text;
  final Function press;
  final Color color;
  const DefaultButton({
    Key?key, required this.text,
    required this.press,
     this.color = kPrimaryColor,
}) : super (key: key);

  @override
  Widget build (BuildContext context){
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child:ElevatedButton(
        onPressed: press(),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(borderRadius:
          BorderRadius.circular(20),
          ),
        ),
        child:
        Text(text,
          style: TextStyle(color: Colors.white,
            fontSize: getProportionateScreenWidth(18),
              )
          ,)
        , )
    );
  }
}