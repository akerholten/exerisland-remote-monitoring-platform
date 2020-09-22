import '../constants/constants.dart';

class DebugTools {
  static List<Minigame> getListOfMinigames() {
    List<Minigame> minigames = new List<Minigame>();

    for (int i = 0; i <= 10; i++) {
      Minigame newMinigame = new Minigame();
      newMinigame.id = i;
      newMinigame.name = "Minigame Name " + i.toString();
      newMinigame.tags = ["Physical", "Reactions", "Cognitive"];
      minigames.add(newMinigame);
    }

    return minigames;
  }
}
