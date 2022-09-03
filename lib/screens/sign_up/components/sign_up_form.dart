import 'package:flutter/material.dart';
import 'package:kartforyou/components/async_progress_dialog.dart';
import 'package:kartforyou/components/custom_suffix_icon.dart';
import 'package:kartforyou/components/default_button.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/exceptions/firebaseauth/messaged_firebaseauth_exception.dart';
import 'package:kartforyou/exceptions/firebaseauth/signup_exceptions.dart';
import 'package:kartforyou/services/authentication/authentication_service.dart';
import 'package:kartforyou/size_config.dart';
import 'package:logger/logger.dart';

class SignUpForm extends StatefulWidget{
  @override
  _SignUpFormState createState() => _SignUpFormState();

}

class _SignUpFormState extends State<SignUpForm>{

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController confirmPasswordFieldController =
  TextEditingController();

  @override
  void dispose(){
    emailFieldController.dispose();
    passwordFieldController.dispose();
    confirmPasswordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(screenPadding)
        ),
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30),),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(30),),
            buildConfirmPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(40),),
            DefaultButton(
              text: "Sign Up",
              press: signUpButtonCallBack,
            ),
          ],
        ),
      ),
    );
  }
    Widget buildConfirmPasswordFormField(){
    return TextFormField(
      controller: confirmPasswordFieldController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Re-enter your password",
        labelText: "Confirm Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon:  "assets/icons/Lock.svg",
        ),
      ),

      validator: (value){
        if (confirmPasswordFieldController.text.isEmpty){
          return kPassNullError;
        } else if (confirmPasswordFieldController.text!=
        passwordFieldController.text){
          return kMatchPassError;
        } else if (confirmPasswordFieldController.text.length<8){
          return kShortPassError;
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
        } else if (!emailValidationRegExp.hasMatch(emailFieldController.text)) {
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: "Enter your password",
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
      validator: (value) {
        if (passwordFieldController.text.isEmpty) {
          return kPassNullError;
        } else if (passwordFieldController.text.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
  Future<void> signUpButtonCallBack() async{
    if(_formKey.currentState!.validate()) {
      final AuthenticationService authService = AuthenticationService();
      bool signUpStatus = false;
      dynamic snackbarMessage; // string datatype was
      try {
        final signUpfuture = authService.signUp(
          email: emailFieldController.text,
          password: passwordFieldController.text,
        );
        signUpfuture.then((value) => signUpStatus = value);
        signUpStatus = await showDialog(
          context: context,
          builder: (context) {
            return AsyncProgressDialog(
              signUpfuture,
              message: const Text("Creating new account"),
              decoration: const BoxDecoration(),
              onError: (print),
              progress:  const CircularProgressIndicator(),
            );
          },
        );
        if (signUpStatus == true) {
          snackbarMessage =
          "Registered successfully, please verify your email id";
        } else {
          throw FirebaseSignUpAuthUnknownReasonFailureException();
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
        if (signUpStatus == true) {
          Navigator.pop(context);
        }
      }
    }
  }
}