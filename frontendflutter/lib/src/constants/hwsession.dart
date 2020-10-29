import 'package:frontendflutter/src/handlers/miscHandler.dart';
import 'package:frontendflutter/src/handlers/observerHandler.dart';
import 'package:frontendflutter/src/handlers/patientHandler.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';
import 'package:frontendflutter/src/model_classes/patient.dart';

// TODO: Potentially move more of the data that is used several places into here?
// Patient data etc, such that it is cached more actively and not need to collect it as often?
// List of patients, specific patient, etc

class HWSession {
  static final HWSession _singleton = HWSession._internal();

  factory HWSession() {
    return _singleton;
  }

  HWSession._internal();

  List<Minigame> _minigames;

  Future<List<Minigame>> getMinigames() async {
    if (_minigames == null) {
      _minigames = await MiscHandler.getListOfMinigames();
    }

    return _minigames;
  }

  Patient _currentPatient;
  Future<Patient> getPatient(String shortId) async {
    if (_currentPatient == null || _currentPatient.shortID != shortId) {
      _currentPatient = await ObserverHandler.getPatient(shortId);
    }

    return _currentPatient;
  }

  Future<Patient> getPersonalInfo() async {
    if (_currentPatient == null) {
      _currentPatient = await PatientHandler.getPersonalInfo();
    }

    return _currentPatient;
  }
}
