import 'package:flutter/material.dart';

class Alerts {
  static void _showAlertSnackbar(GlobalKey<ScaffoldState> scaffoldKey,
      String title, Color color, String message) {
    // Widget okButton = FlatButton(
    //   child: Text("OK"),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // );

    SnackBar snackBar = SnackBar(
      backgroundColor: color,
      content: SelectableText(title + ": " + message),
      // actions: [
      //   okButton,
      // ],
    );

    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  static void showInfo(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, String message) {
    _showAlertSnackbar(
        scaffoldKey, "Info", Theme.of(context).primaryColor, message);
  }

  static void showWarning(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, String message) {
    _showAlertSnackbar(scaffoldKey, "Warning", Colors.orange[500], message);
  }

  static void showError(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, String message) {
    _showAlertSnackbar(
        scaffoldKey, "Error", Theme.of(context).errorColor, message);
  }
}
