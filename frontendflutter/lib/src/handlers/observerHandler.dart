import 'package:flutter/material.dart';
import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/model_classes/addPatientForm.dart';
import 'package:frontendflutter/src/model_classes/loginForm.dart';
import 'package:frontendflutter/src/model_classes/signupForm.dart';
import 'dart:convert'; // For jsonEncode, jsonDecode
import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';

import 'dart:io';
import 'dart:async';

// IF ISSUES WITH COOKIES; REMEMBER THIS: https://medium.com/swlh/flutter-web-node-js-cors-and-cookies-f5db8d6de882
// http package has browser_client that has a variable withCredentials that needs to be changed to default to 'true'

class ObserverHandler {
  // These functions could potentially return bools (success/failure) or ints (HTTP error codes)

  static Future<bool> addPatient(AddPatientForm form) async {
    print("Logging in using default library.. ");

    final http.Response response = await http.post(
        Constants.backendURL + "/addPatient",
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(
            form)); // TODO: Change to using loginForm.toJson() somehow...

    if (response.statusCode == 200 || response.statusCode == 202) {
      Alerts.showInfo("Patient was added successfully!");
      return true;
    } else {
      Alerts.showError("Something went wrong when trying to add new patient");
      return false;
    }
  }
}
