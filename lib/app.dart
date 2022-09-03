import 'package:flutter/material.dart';
import 'package:kartforyou/wrappers/authentication_wrapper.dart';
import 'constants.dart';
import 'package:kartforyou/theme.dart';


class App extends StatelessWidget{
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: const AuthenticationWrapper(),
    );
  }
}