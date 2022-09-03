import 'package:flutter/material.dart';
import 'package:kartforyou/screens/home/home_screen.dart';
import '';
import '';


class AuthenticationWrapper extends StatelessWidget{
  static const String routeName = "/Authentication_wrapper";

  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return StreamBuilder(
       // stream: AuthenticationService().authStateChanges,
        builder: (context, snapshot){
          if (snapshot.hasData){
            return HomeScreen();
          } else{
            //return SignInScreen();
          }
        },
        );
  }
}