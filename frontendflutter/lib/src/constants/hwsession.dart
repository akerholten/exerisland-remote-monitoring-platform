import 'package:frontendflutter/src/handlers/miscHandler.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';

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
}
