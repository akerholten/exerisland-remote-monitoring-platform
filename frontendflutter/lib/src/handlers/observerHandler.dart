import 'package:flutter/material.dart';
import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/model_classes/addPatientForm.dart';
import 'package:frontendflutter/src/model_classes/loginForm.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'package:frontendflutter/src/model_classes/patients.dart';
import 'package:frontendflutter/src/model_classes/signupForm.dart';
import 'dart:convert'; // For jsonEncode, jsonDecode
import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';
import 'dart:convert';

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

  static Future<List<Patient>> getAllPatients() async {
    final http.Response response = await http.get(
      Constants.backendURL + "/getAllPatients",
    );

    print("Trying to fetch list of all patients... ");
    if (response.statusCode == 200 || response.statusCode == 202) {
      // Alerts.showInfo("Sign up was successful!");
      // String decodedData = utf8.decode(response.bodyBytes);
      List<Patient> tempList = new List<Patient>();

      print("response.body is:\n");
      print(response.body);

      var jsonData = jsonDecode(response.body) as List;
      print("jsonData is:\n");
      print(jsonData);

      jsonData.forEach((element) {
        // print("Adding element: " + element);
        print("We are here adding element");
        tempList.add(Patient.fromJson(element));
      });

      print("We got done adding the elements");

      // tempList = jsonData.map((i) => Patient.fromJson(i)).toList();

      // jsonData.forEach((key, value) {
      //   print("key is:" + key);
      //   print("value is:" + value);
      //   tempList.add(Patient.fromJson(value));
      // });

      return tempList;
      //new Patients.fromJson(jsonData);
    } else {
      // Was unsuccessful at signing up ( display some message of sort?, possibly catch more http errors? )
      // Alerts.showError("Cookie has expired, log in again to continue");
      return null;
    }
  }
}
