import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/model_classes/addPatientForm.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'dart:convert'; // For jsonEncode, jsonDecode
import 'package:http/http.dart' as http;

import 'dart:async';

class PatientHandler {
  // These functions could potentially return bools (success/failure) or ints (HTTP error codes)

  static Future<Patient> getPersonalInfo() async {
    final http.Response response = await http.get(
      Constants.backendURL + "/getPersonalInfo",
    );

    print("Trying to fetch a users specific data ... ");
    if (response.statusCode == 200 || response.statusCode == 202) {
      Patient patient = new Patient();

      var jsonData = jsonDecode(response.body);

      patient = Patient.fromJson(jsonData);

      return patient;
    } else {
      Alerts.showWarning("Could not retrieve user");
      return null;
    }
  }
}
