import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/model_classes/addPatientForm.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'dart:convert'; // For jsonEncode, jsonDecode
import 'package:http/http.dart' as http;

import 'dart:async';

class ObserverHandler {
  // These functions could potentially return bools (success/failure) or ints (HTTP error codes)

  static Future<bool> addPatient(AddPatientForm form) async {
    print("Logging in using default library.. ");

    final http.Response response = await http.post(
        Constants.backendURL + "/addPatient",
        headers: <String, String>{'Content-Type': 'application/json'},
        body:
            jsonEncode(form)); // TODO: Change to using form.toJson() somehow...

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
      List<Patient> tempList = new List<Patient>();

      var jsonData = jsonDecode(response.body) as List;

      jsonData.forEach((element) {
        tempList.add(Patient.fromJson(element));
      });

      return tempList;
    } else {
      Alerts.showWarning("Could not retrieve list of patients");
      return null;
    }
  }

  static Future<Patient> getPatient(String shortId) async {
    final http.Response response = await http.get(
      Constants.backendURL + "/getPatient/" + shortId,
    );

    print("Trying to fetch a specific patient... ");
    if (response.statusCode == 200 || response.statusCode == 202) {
      Patient patient = new Patient();

      var jsonData = jsonDecode(response.body);

      patient = Patient.fromJson(jsonData);

      return patient;
    } else {
      Alerts.showWarning("Could not retrieve patient");
      return null;
    }
  }
}
