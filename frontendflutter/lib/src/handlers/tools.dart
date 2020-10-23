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

  //https://stackoverflow.com/questions/54852585/how-to-convert-a-duration-like-string-to-a-real-duration-in-flutter
  static Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  static void verifyCookieLogin(BuildContext context) async {
    bool loggedIn = await LoginHandler.isLoggedInWithCookie();

    if (!loggedIn) {
      Alerts.showError("Session no longer available, log in again to continue");
      Navigator.of(context).pushReplacementNamed(Routes.Login);
    }
  }

  static void redirectIfAlreadyLoggedIn(BuildContext context) async {
    bool loggedIn = await LoginHandler.isLoggedInWithCookie();

    if (loggedIn) {
      // TODO: Check if user is observer or patient here? And then push correct accordingly
      Navigator.of(context).pushReplacementNamed(Routes.Dashboard);
    }
  }

  static void _logoutUser(BuildContext context) async {
    bool loggedOut = await LoginHandler.logout();

    if (loggedOut) {
      Navigator.of(context).pushReplacementNamed(Routes.Login);
    }
  }

  static void promptUserLogout(BuildContext context) {
    Alerts.showConfirmationDialog(
        context, "Logout", "Are you sure you want to logout?", () {
      _logoutUser(context);
    });
  }

  static int birthDateToAge(String birthDate) {
    return (DateTime.now().difference(DateTime.parse(birthDate)).inDays ~/ 365)
        .toInt();
  }
}
