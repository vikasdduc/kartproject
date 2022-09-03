import 'package:flutter/material.dart';
import 'package:kartforyou/components/async_progress_dialog.dart';
import 'package:kartforyou/components/custom_suffix_icon.dart';
import 'package:kartforyou/components/default_button.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:kartforyou/exceptions/firebaseauth/messaged_firebaseAuth_exception.dart';
import 'package:kartforyou/services/authentication/authentication_service.dart';
import 'package:kartforyou/size_config.dart';
import 'package:logger/logger.dart';
import 'package:kartforyou/components/no_account_text.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class ForGotPasswordForm extends StatefulWidget{
  @override
  _ForGotPasswordFormState createState() => _ForGotPasswordFormState();
}

class _ForGotPasswordFormState extends State<ForGotPasswordForm>{
  final _formKey= GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();

  @override
  void dispose(){
    emailFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            SizedBox(height: SizeConfig.screenHeight! * 0.1),
            DefaultButton(
              text: "Send Verification Email",
              press:sendVerificationEmailButtonCallback,
            ),
            SizedBox(height: SizeConfig.screenHeight!*0.1),

          ],
        ),
    );
  }

  TextFormField buildEmailFormField(){
    return TextFormField(
      controller: emailFieldController,
      keyboardType: TextInputType.emailAddress,
      decoration:const InputDecoration(
        hintText: "Enter your mail",
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
      validator: (value){
        if(value.isEmpty){
          return kEmailNullError;
        } else if (!emailValidationRegExp.hasMatch(value!)){
          return kInvalidEmailError;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Future<void> sendVerificationEmailButtonCallback()async{
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      final String emailInput = emailFieldController.text.trim();
      bool resultStatus;
      String snackbarMessage;
      try{
        final resultFuture =
            AuthenticationService().resetPasswordForEmail(emailInput);
        resultFuture.then((value) => resultStatus = value);
        resultStatus = await showDialog(
            context: context,
            builder: (context){
              return AsyncProgressDialog(
                  resultFuture,
                  decoration: const BoxDecoration(),
                  progress: const CircularProgressIndicator(),
                  message: const Text("Sending Verification Email"),
                  onError: (print),
              );
            }
            );
        if (resultStatus == true){
          snackbarMessage = "Password Reset Link sent to your email";
        } else {
          throw FirebaseCredentialActionAuthUnknownReasonFailureException(
            message: "Sorry, could not process your request now, try again later"
          );

        }
      } on MessagedFirebaseAuthException catch(e){
        snackbarMessage = e.message;
      } catch(e){
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

}