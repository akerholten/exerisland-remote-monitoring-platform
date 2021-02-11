import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Alerts {
  // ----- ALERT TOASTS -----
  static void _showAlertToast(String title, String color, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.orange[500],
      textColor: Colors.white,
      webBgColor: color,
      webShowClose: true,
    );
  }

  static void showInfo(String message) {
    _showAlertToast(
        "Info", "linear-gradient(to right, #2AABFF, #53BAFD)", message);
  }

  static void showWarning(String message) {
    _showAlertToast(
        "Warning", "linear-gradient(to right, #FF8920, #FF9D46)", message);
  }

  static void showError(String message) {
    _showAlertToast(
        "Error", "linear-gradient(to right, #FF2A2A, #FF4A4A)", message);
  }

  // ----- ALERT DIALOGS / CONFIRMATION WINDOWS -----
  static void showConfirmationDialog(
      BuildContext context, String title, String text, VoidCallback function) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () => Navigator.maybeOf(context).pop(),
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.maybeOf(context).pop();
        function();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
