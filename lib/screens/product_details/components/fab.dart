import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kartforyou/components/async_progress_dialog.dart';
import 'package:kartforyou/services/authentication/authentication_service.dart';
import 'package:kartforyou/services/database/user_database_helper.dart';
import 'package:kartforyou/utils.dart';
import 'package:logger/logger.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class AddToCartFAB extends StatelessWidget {
  const AddToCartFAB({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final String productId;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        bool allowed = AuthenticationService().currentUserVerified;
        if (!allowed) {
          final reverify = await showConfirmationDialog(context,
              "You haven't verified your email address. This action is only allowed for verified users.",
              positiveResponse: "Resend verification email",
              negativeResponse: "Go back");
          if (reverify == 0) {
            final future =
            AuthenticationService().sendVerificationEmailToCurrentUser();
            await showDialog(
              context: context,
              builder: (context) {
                return AsyncProgressDialog(
                  future,
                  message: Text("Resending verification email"), onError:(err)=>print(err), progress: CircularProgressIndicator(),
                  decoration: BoxDecoration(),
                );
              },
            );
          }
          return;
        }
        bool addedSuccessfully = false;
        String snackBarMessage;
        try {
          addedSuccessfully =
          await UserDatabaseHelper().addProductToCart(productId);
          if (addedSuccessfully == true) {
            snackBarMessage = "Product added successfully";
          } else {
            throw "Coulnd't add product due to unknown reason";
          }
        } on FirebaseException catch (e) {
          Logger().w("Firebase Exception: $e");
          snackBarMessage = "Something went wrong";
        } catch (e) {
          Logger().w("Unknown Exception: $e");
          snackBarMessage = "Something went wrong";
        } finally {
          Logger().i("snackBarMessage");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("snackBarMessage"),
            ),
          );
        }
      },
      label: const Text(
        "Add to Cart",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      icon: const Icon(
        Icons.shopping_cart,
      ),
    );
  }
}