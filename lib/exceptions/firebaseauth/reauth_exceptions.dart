import 'package:firebase_auth/firebase_auth.dart';
import 'package:kartforyou/exceptions/firebaseauth/messaged_firebaseauth_exception.dart';

class FirebaseReAuthException extends MessagedFirebaseAuthException{
  FirebaseReAuthException(
  {String message = "Instance of FirebaseReAuthException"}
      ): super(message);
}

class FirebaseReAuthUserMismatchException extends FirebaseAuthException{
  FirebaseReAuthUserMismatchException(
  {String message = "User Not Matching Current user"}
      ): super(code: message);
}

class FirebaseReAuthUserNotFoundException extends
    FirebaseReAuthException{
  FirebaseReAuthUserNotFoundException(
  {String message = " No such user exists"}
      ): super(message: message);
}

class FirebaseReAuthInvalidCredentialException extends FirebaseReAuthException {
  FirebaseReAuthInvalidCredentialException(
      {String message = "Invalid Credentials"})
      : super(message: message);
}

class FirebaseReAuthInvalidEmailException extends FirebaseReAuthException {
  FirebaseReAuthInvalidEmailException({String message = "Invalid Email"})
      : super(message: message);
}

class FirebaseReAuthWrongPasswordException extends FirebaseReAuthException {
  FirebaseReAuthWrongPasswordException({String message = "Wrong password"})
      : super(message: message);
}

class FirebaseReAuthInvalidVerificationCodeException
    extends FirebaseReAuthException {
  FirebaseReAuthInvalidVerificationCodeException(
      {String message = "Invalid Verification Code"})
      : super(message: message);
}

class FirebaseReAuthInvalidVerificationIdException
    extends FirebaseReAuthException {
  FirebaseReAuthInvalidVerificationIdException(
      {String message = "Invalid Verification ID"})
      : super(message: message);
}

class FirebaseReAuthUnknownReasonFailureException
    extends FirebaseReAuthException {
  FirebaseReAuthUnknownReasonFailureException(
      {String message = "ReAuthentication Failed due to unknown reason"})
      : super(message: message);
}