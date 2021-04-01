import 'package:flutter/material.dart';
import '../constants/route_names.dart';
import '../components/alerts.dart';
import 'loginHandler.dart';
import 'package:intl/intl.dart' as intl;

import 'dart:html';

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
    try {
      return (DateTime.now().difference(DateTime.parse(birthDate)).inDays ~/
              365)
          .toInt();
    } on FormatException catch (e) {
      print("error caught on birthDateToAge: $e");
      return 0;
    }
  }

  static void resetLoginVariables() {
    window.localStorage['userType'] = '';
  }

  static String durationAgoString(Duration duration) {
    String rtrString = "";

    if (duration.inDays >= 1) {
      return duration.inDays.toString() + " days ago";
    }
    if (duration.inHours >= 1) {
      return duration.inHours.toString() + " hours ago";
    }
    if (duration.inMinutes >= 1) {
      return duration.inMinutes.toString() + " minutes ago";
    }
    return duration.inSeconds.toString() + " seconds ago";
  }

  static String listOfStringsToString(List<String> strings) {
    String rtrString = "";

    strings.forEach((string) {
      if (rtrString != "") {
        rtrString += ", ";
      }
      rtrString += string;
    });

    return rtrString;
  }

  static String secondsToHHMMSS(int seconds) {
    String rtrString = "";

    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;

    if (h < 10) {
      rtrString += "0";
    }
    rtrString += h.toString() + ":";

    if (m < 10) {
      rtrString += "0";
    }
    rtrString += m.toString() + ":";

    if (s < 10) {
      rtrString += "0";
    }
    rtrString += s.toString();

    return rtrString;
  }

  static String metersToStringLength(int meters) {
    String rtrString = "";

    if (meters > 2000) {
      rtrString = (meters / 1000).toString() + " kilometers";
    } else {
      rtrString = meters.toString() + " meters";
    }
    return rtrString;
  }

  static void swap<T>(T one, T two) {
    var temp = one;
    one = two;
    two = temp;
  }

  static bool isFromSameWeek(DateTime first, DateTime second) {
    int firstDayOfWeek = DateTime.monday;
    // sort dates
    if (first.difference(second) > Duration.zero) {
      var temp = first;
      first = second;
      second = temp;
    }

    var daysDiff = second.difference(first).inDays;
    if (daysDiff >= 7) {
      return false;
    }

    const int totalDaysInWeek = 7;
    var adjustedDayOfWeekFirst =
        first.weekday + (first.weekday < firstDayOfWeek ? totalDaysInWeek : 0);
    var adjustedDayOfWeekSecond = second.weekday +
        (second.weekday < firstDayOfWeek ? totalDaysInWeek : 0);

    return adjustedDayOfWeekSecond >= adjustedDayOfWeekFirst;
  }

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(intl.DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  static int weekNumber(DateTime date) {
    int dayOfYear = int.parse(intl.DateFormat("D").format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeks(date.year - 1);
    } else if (woy > numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }
}
