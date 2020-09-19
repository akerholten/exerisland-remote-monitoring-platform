import 'package:flutter/material.dart';

class Alerts {
  static void showAlertDialog(
      BuildContext context, String title, String message) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: SelectableText(title),
      content: SelectableText(message),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showInfo(BuildContext context, String message) {
    showAlertDialog(context, "Info", message);
  }

  static void showWarning(BuildContext context, String message) {
    showAlertDialog(context, "Warning", message);
  }

  static void showError(BuildContext context, String message) {
    showAlertDialog(context, "Error", message);
  }
}
