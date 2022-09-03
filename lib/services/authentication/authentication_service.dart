import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:kartforyou/exceptions/firebaseauth/credential_actions_exceptions.dart';
import 'package:kartforyou/exceptions/firebaseauth/messaged_firebaseauth_exception.dart';
import 'package:kartforyou/exceptions/firebaseauth/reauth_exceptions.dart';
import 'package:kartforyou/exceptions/firebaseauth/signin_exceptions.dart';
import 'package:kartforyou/exceptions/firebaseauth/signup_exceptions.dart';

import '../database/user_database_helper.dart';

class AuthenticationService{
  static const String USER_NOT_FOUND_EXCEPTION_CODE = "user-not-found";
  static const String WRONG_PASSWORD_EXCEPTION_CODE = "wrong-password";
  static const String TOO_MANY_REQUESTS_EXCEPTION_CODE = 'too-many-requests';
  static const String EMAIL_ALREADY_IN_USE_EXCEPTION_CODE =
      "email-already-in-use";
  static const String OPERATION_NOT_ALLOWED_EXCEPTION_CODE =
      "operation-not-allowed";
  static const String WEAK_PASSWORD_EXCEPTION_CODE = "weak-password";
  static const String USER_MISMATCH_EXCEPTION_CODE = "user-mismatch";
  static const String INVALID_CREDENTIALS_EXCEPTION_CODE = "invalid-credential";
  static const String INVALID_EMAIL_EXCEPTION_CODE = "invalid-email";
  static const String USER_DISABLED_EXCEPTION_CODE = "user-disabled";
  static const String INVALID_VERIFICATION_CODE_EXCEPTION_CODE =
      "invalid-verification-code";
  static const String INVALID_VERIFICATION_ID_EXCEPTION_CODE =
      "invalid-verification-id";
  static const String REQUIRES_RECENT_LOGIN_EXCEPTION_CODE =
      "requires-recent-login";

  FirebaseAuth _firebaseAuth;

  AuthenticationService._privateConstructor();
  static final AuthenticationService _instance =
      AuthenticationService._privateConstructor();

  FirebaseAuth get firebaseAuth{
    if(_firebaseAuth== null){
      _firebaseAuth = FirebaseAuth.instance;
    }
    return _firebaseAuth;
  }
  factory AuthenticationService(){
    return _instance;
  }

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  Stream<User> get userChanges => firebaseAuth.userChanges();

  Future<void> deleteUserAccount() async {
    await currentUser?.delete();
    await signOut();
  }

  Future<bool> reauthCurrentUser(password) async{
    try{
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: currentUser.email!, password: password);
      userCredential = await currentUser
      .reauthenticateWithCredential(userCredential.credential);
    } on FirebaseAuthException catch (e) {
      if(e.code == WRONG_PASSWORD_EXCEPTION_CODE){
        throw FirebaseSignInAuthException(message: e.code);
      }
    } catch(e){
      throw FirebaseReAuthUnknownReasonFailureException(message: e.toString());
    }
    return true;
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user.emailVerified) {
        return true;
      } else {
        await userCredential.user?.sendEmailVerification();
        throw FirebaseSignInAuthUserNotVerifiedException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case INVALID_EMAIL_EXCEPTION_CODE:
          throw FirebaseSignInAuthInvalidEmailException();

        case USER_DISABLED_EXCEPTION_CODE:
          throw FirebaseSignInAuthUserDisabledException();

        case USER_NOT_FOUND_EXCEPTION_CODE:
          throw FirebaseSignInAuthUserNotFoundException();

        case WRONG_PASSWORD_EXCEPTION_CODE:
          throw FirebaseSignInAuthWrongPasswordException();

        case TOO_MANY_REQUESTS_EXCEPTION_CODE:
          throw FirebaseTooManyRequestsException();

        default:
          throw FirebaseSignInAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }
    Future<bool> signUp({required String email, required String password}) async {
      try {
        final UserCredential userCredential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        final String uid = userCredential.user.uid;
        if (userCredential.user?.emailVerified == false) {
          await userCredential.user?.sendEmailVerification();
        }
        await UserDatabaseHelper().createNewUser(uid);
        return true;
      } on MessagedFirebaseAuthException {
        rethrow;
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case EMAIL_ALREADY_IN_USE_EXCEPTION_CODE:
            throw FirebaseSignUpAuthEmailAlreadyInUseException();
          case INVALID_EMAIL_EXCEPTION_CODE:
            throw FirebaseSignUpAuthInvalidEmailException();
          case OPERATION_NOT_ALLOWED_EXCEPTION_CODE:
            throw FirebaseSignUpAuthOperationNotAllowedException();
          case WEAK_PASSWORD_EXCEPTION_CODE:
            throw FirebaseSignUpAuthWeakPasswordException();
          default:
            throw FirebaseSignInAuthException(message: e.code);
        }
      } catch (e) {
        rethrow;
      }
    }
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  bool get currentUserVerified {
    currentUser?.reload();
    return currentUser.emailVerified;
  }
  Future<void> sendVerificationEmailToCurrentUser() async {
    await firebaseAuth.currentUser?.sendEmailVerification();
  }

  User? get currentUser {
    return firebaseAuth.currentUser;
  }

  Future<void> updateCurrentUserDisplayName(String updatedDisplayName) async {
    await currentUser?.updateProfile(displayName: updatedDisplayName);
  }

  Future<bool> resetPasswordForEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == USER_NOT_FOUND_EXCEPTION_CODE) {
        throw FirebaseCredentialActionAuthUserNotFoundException();
      } else {
        throw FirebaseCredentialActionAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
}
  Future<bool> changePasswordForCurrentUser(
      {required String oldPassword, required String newPassword}) async {
    try {
      bool isOldPasswordProvidedCorrect = true;
      if (oldPassword != null) {
        isOldPasswordProvidedCorrect =
        await verifyCurrentUserPassword(oldPassword);
      }
      if (isOldPasswordProvidedCorrect) {
        await firebaseAuth.currentUser?.updatePassword(newPassword);

        return true;
      } else {
        throw FirebaseReAuthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case WEAK_PASSWORD_EXCEPTION_CODE:
          throw FirebaseCredentialActionAuthWeakPasswordException();
        case REQUIRES_RECENT_LOGIN_EXCEPTION_CODE:
          throw FirebaseCredentialActionAuthRequiresRecentLoginException();
        default:
          throw FirebaseCredentialActionAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> changeEmailForCurrentUser(
      {required String password, required String newEmail}) async {
    try {
      bool isPasswordProvidedCorrect = true;
      if (password != null) {
        isPasswordProvidedCorrect = await verifyCurrentUserPassword(password);
      }
      if (isPasswordProvidedCorrect) {
        await currentUser?.verifyBeforeUpdateEmail(newEmail);

        return true;
      } else {
        throw FirebaseReAuthWrongPasswordException();
      }
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw FirebaseCredentialActionAuthException(message: e.code);
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> verifyCurrentUserPassword(String password) async {
    try {
      final AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUser.email,
        password: password,
      );

      final authCredentials =
      await currentUser?.reauthenticateWithCredential(authCredential);
      return authCredentials != null;
    } on MessagedFirebaseAuthException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case USER_MISMATCH_EXCEPTION_CODE:
          throw FirebaseReAuthUserMismatchException();
        case USER_NOT_FOUND_EXCEPTION_CODE:
          throw FirebaseReAuthUserNotFoundException();
        case INVALID_CREDENTIALS_EXCEPTION_CODE:
          throw FirebaseReAuthInvalidCredentialException();
        case INVALID_EMAIL_EXCEPTION_CODE:
          throw FirebaseReAuthInvalidEmailException();
        case WRONG_PASSWORD_EXCEPTION_CODE:
          throw FirebaseReAuthWrongPasswordException();
        case INVALID_VERIFICATION_CODE_EXCEPTION_CODE:
          throw FirebaseReAuthInvalidVerificationCodeException();
        case INVALID_VERIFICATION_ID_EXCEPTION_CODE:
          throw FirebaseReAuthInvalidVerificationIdException();
        default:
          throw FirebaseReAuthException(message: e.code);
      }
    } catch (e) {
      rethrow;
    }
  }
}