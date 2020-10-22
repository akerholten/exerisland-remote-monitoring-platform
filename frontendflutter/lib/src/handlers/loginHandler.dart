import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/model_classes/loginForm.dart';
import 'dart:convert'; // For jsonEncode, jsonDecode
import 'package:http/http.dart' as http;

import 'dart:async';

// IF ISSUES WITH COOKIES; REMEMBER THIS: https://medium.com/swlh/flutter-web-node-js-cors-and-cookies-f5db8d6de882
// http package has browser_client that has a variable withCredentials that needs to be changed to default to 'true'

class LoginHandler {
  // These functions could potentially return bools (success/failure) or ints (HTTP error codes)

  // static bool isLoggedInWithCookie() {
  //   // or doCookieVerification / tryCookieLogin
  //   // Check for cookie with doing a post request to back-end
  //   // Back-end will check for the cookie
  //   // If valid cookie, then login
  //   return false;
  // }

  static Future<bool> isLoggedInWithCookie() async {
    final http.Response response = await http.post(
      Constants.backendURL + "/cookieLogin",
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      // Alerts.showInfo("Sign up was successful!");
      return true;
    } else {
      // Was unsuccessful at signing up ( display some message of sort?, possibly catch more http errors? )
      // Alerts.showError("Cookie has expired, log in again to continue");
      return false;
    }
  }

  // static Future<bool> manualLoginTwo(LoginForm loginForm) async {
  //   print("Logging in using response library.. ");
  //   final Response response = await Requests.post(
  //     Constants.backendURL + "/manualLogin",
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //     },
  //     body: loginForm.toJson(),
  //     bodyEncoding: RequestBodyEncoding.JSON,
  //   ); // TODO: Change to using loginForm.toJson() somehow...

  //   response.raiseForStatus();
  //   if (response.statusCode == 200 || response.statusCode == 202) {
  //     response.headers.forEach((key, value) {
  //       print("\nKey is: " + key + "\n Value is: " + value);
  //     });
  //     print(response.toString());
  //     // Cookie.fromSetCookieValue(response.headers["set-cookie"]);
  //     Alerts.showInfo("Login was successful!");
  //     return true;
  //   } else {
  //     // Was unsuccessful at signing up ( display some message of sort?, possibly catch more http errors? )
  //     Alerts.showError("Unable to log in");
  //     return false;
  //   }
  // }

  static Future<bool> manualLogin(LoginForm loginForm) async {
    print("Logging in using default library.. ");

    final http.Response response = await http.post(
        Constants.backendURL + "/manualLogin",
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            loginForm)); // TODO: Change to using loginForm.toJson() somehow...

    if (response.statusCode == 200 || response.statusCode == 202) {
      response.headers.forEach((key, value) {
        print("\nKey is: " + key + "\n Value is: " + value);
      });
      print(response.toString());
      // Cookie.fromSetCookieValue(response.headers["set-cookie"]);
      Alerts.showInfo("Login was successful!");
      return true;
    } else {
      // Was unsuccessful at signing up ( display some message of sort?, possibly catch more http errors? )
      Alerts.showError("Unable to log in");
      return false;
    }
  }

  static Future<bool> logout() async {
    final http.Response response = await http.post(
      Constants.backendURL + "/logout",
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      // Alerts.showInfo("Sign up was successful!");
      return true;
    } else {
      // Was unsuccessful at signing up ( display some message of sort?, possibly catch more http errors? )
      // Alerts.showError("Cookie has expired, log in again to continue");
      return false;
    }
  }
}
