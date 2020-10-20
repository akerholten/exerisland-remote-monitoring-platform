import 'package:flutter/material.dart';
import '../constants/route_names.dart';
import '../components/alerts.dart';
import 'loginHandler.dart';

class Tools {
  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static void verifyCookieLogin(BuildContext context) async {
    bool loggedIn = await LoginHandler.isLoggedInWithCookie();

    if (!loggedIn) {
      Alerts.showError("Session no longer available, log in again to continue");
      Navigator.of(context).pushReplacementNamed(Routes.Login);
    }
  }
}
