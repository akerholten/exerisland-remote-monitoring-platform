import 'package:flutter/material.dart';
import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/model_classes/signupForm.dart';
import 'dart:convert'; // For jsonEncode, jsonDecode
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:async';

class SignupHandler {
  static Future<bool> signUp(SignupForm signupForm) async {
    final http.Response response = await http.post(
        Constants.backendURL + "/signup",
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            signupForm)); // TODO: Change to using singupForm.toJson() somehow...

    if (response.statusCode == 200 || response.statusCode == 201) {
      Alerts.showInfo("Sign up was successful!");
      return true;
    } else {
      // Was unsuccessful at signing up ( display some message of sort?, possibly catch more http errors? )
      Alerts.showError("Unable to sign up");
      return false;
    }
  }
}
