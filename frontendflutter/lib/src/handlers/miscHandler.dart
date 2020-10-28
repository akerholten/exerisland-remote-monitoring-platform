import 'package:frontendflutter/src/components/alerts.dart';
import 'package:frontendflutter/src/constants/constants.dart';
import 'package:frontendflutter/src/model_classes/addPatientForm.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';
import 'dart:convert'; // For jsonEncode, jsonDecode
import 'package:http/http.dart' as http;

import 'dart:async';

import 'package:frontendflutter/src/model_classes/metric.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';

class MiscHandler {
  static Future<List<Minigame>> getListOfMinigames() async {
    final http.Response response = await http.get(
      Constants.backendURL + "/getMinigames",
    );

    print("Trying to fetch minigames available ... ");

    if (response.statusCode == 200 || response.statusCode == 202) {
      List<Minigame> tempList = new List<Minigame>();

      var jsonData = jsonDecode(response.body) as List;

      jsonData.forEach((element) {
        tempList.add(Minigame.fromJson(element));
      });

      return tempList;
    } else {
      Alerts.showWarning("Could not retrieve list of minigames");
      return null;
    }
  }
}
