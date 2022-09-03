import 'package:flutter/material.dart';
import 'package:kartforyou/components/async_progress_dialog.dart';
import 'package:kartforyou/components/custom_suffix_icon.dart';
import 'package:kartforyou/components/default_button.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/exceptions/firebaseauth/messaged_firebaseAuth_exception.dart';
import 'package:kartforyou/exceptions/firebaseauth/signin_exceptions.dart';
import 'package:kartforyou/services/authentication/authentication_service.dart';
import 'package:kartforyou/size_config.dart';

class SignInForm extends StatefulWidget{
   @override
  State<StatefulWidget> createState() {

    throw _SignInFormState();
  }
}

class _SignInFormState extends State<SignInForm>{
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  @override
  void dispose(){
  emailFieldController.dispose();
  passwordFieldController.dispose();
  super.dispose();
}
@override
  Widget build(BuildContext context){
    return Form(
      key: _formkey,
      child: Column(
        children: [
        buildEmailFormField(),
        SizedBox(height: getProportionateScreenHeight(30)),
        buildPasswordFormField(),
        SizedBox(height: getProportionateScreenHeight(30)),
          buildForgotPasswordWidget(context),
        SizedBox(height: getProportionateScreenHeight(30)),
        DefaultButton(
            text:"Sign In",
            press: signInButtonCallBack,
        ),
      ],
    ),
    );
  }

  Row buildForgotPasswordWidget(BuildContext context){
    return Row(
      children: [
        Spacer(),
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(),
            ));
          },
          child:const  Text(
            "Forgot Password",
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }

  Widget buildPasswordFormField(){
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Enter your Password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value){
        if (passwordFieldController.text.isEmpty){
          return kPassNullError;
        } else if (passwordFieldController.text.length < 8){
          return kShortPassError;
        }
        return null;
     },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildEmailFormField(){
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
  Widget buildEmailFormField() {
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: "Enter your email",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value) {
        if (emailFieldController.text.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> signInButtonCallBack() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      final AuthenticationService authService = AuthenticationService();
      bool signInStatus = false;
      String snackbarMessage;
      try {
        final signInFuture = authService.signIn(
          email: emailFieldController.text.trim(),
          password: passwordFieldController.text.trim(),
        );
        //signInFuture.then((value) => signInStatus = value);
        signInStatus = await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              signInFuture,
              message: const Text("Signing in to account"),
              onError: (e) {
                snackbarMessage = e.toString();
              }, decoration: InputDecoration(), progress: ,
            );
          },
        );
        if (signInStatus == true) {
          snackbarMessage = "Signed In Successfully";
        } else {
          if (snackbarMessage == null) {
            throw FirebaseSignInAuthUnknownReasonFailure();
          } else {
            throw FirebaseSignInAuthUnknownReasonFailure(
                message: snackbarMessage);
          }
        }
      } on MessagedFirebaseAuthException catch (e) {
        snackbarMessage = e.message;
      } catch (e) {
        snackbarMessage = e.toString();
      } finally {
        Logger().i(snackbarMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(snackbarMessage),
          ),
        );
      }
    }
}