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

  static void _logoutUser(BuildContext context) async {
    bool loggedOut = await LoginHandler.logout();

    if (loggedOut) {
      Alerts.showInfo("Logged out successfully");
      Navigator.of(context).pushReplacementNamed(Routes.Login);
    }
  }

  static void promptUserLogout(BuildContext context) {
    Alerts.showConfirmationDialog(
        context, "Logout", "Are you sure you want to logout?", () {
      _logoutUser(context);
    });
  }
}
