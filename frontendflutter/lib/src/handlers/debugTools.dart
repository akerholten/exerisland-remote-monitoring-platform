import 'package:frontendflutter/src/model_classes/metric.dart';
import 'package:frontendflutter/src/model_classes/minigame.dart';

class DebugTools {
  static List<Minigame> getListOfMinigames() {
    List<Minigame> minigames = new List<Minigame>();

    for (int i = 0; i <= 10; i++) {
      Minigame newMinigame = new Minigame();
      newMinigame.id = i.toString();
      newMinigame.name = "Minigame Name " + i.toString();
      newMinigame.description = "Minigame description " +
          newMinigame.id.toString() +
          ", well thats nice and a really long text to add and see how it goes";
      newMinigame.tags = ["Physical", "Reactions", "Cognitive"];

      newMinigame.availableMetrics = new List<Metric>();
      for (int j = i; j <= 10; j++) {
        Metric newMetric = new Metric();
        newMetric.id = j.toString();
        newMetric.name = "Metric " + j.toString();
        newMetric.unit = "meters";
        newMetric.value = 0;
        newMinigame.availableMetrics.add(newMetric);
      }

      minigames.add(newMinigame);
    }

    return minigames;
  }
}
