import 'package:flutter/material.dart';

Future<Future> showConfirmationDialog(
BuildContext context,
String message,{
  String positiveResponse = "yes",
String negativeResponse = "No",
}) async {
  var result = showDialog(context: context, builder: (context){
    return AlertDialog(
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      actions: [
        ElevatedButton(
         child: Text(
          positiveResponse,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
    onPressed: (){
    Navigator.pop(context, true);
    },
        ),

        ElevatedButton(
          child: Text(
            negativeResponse,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
  );
  result ??= false as Future;
  return result;
}