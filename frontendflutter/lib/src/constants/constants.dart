class Constants {
  static const String applicationName = "VR Health and Wellness Monitoring";
  static const String backendURL = "http://localhost:8080";
}

class Patient {
  String firstName,
      lastName,
      email,
      issue,
      recentActivity; // TODO: change recent activity to be date
  int id; // TODO: Possibly string (hash or something for ID)
  int age, recommendationsCount, recommendationsCompleted;
  List<Session> sessions;
  List<Recommendation> recommendations;
  DateTime dateOfBirth;
}

class Session {
  int id; // TODO: Possibly string (hash or something for ID)
  int duration;
  DateTime createdAt;
  List<Activity> activities;
}

class Activity {
  int id; // TODO: Possibly string (hash or something for ID)
  int minigameId; // TODO: Possibly string (hash or something for ID)
  DateTime createdAt;
  List<Metric> metrics;
}

class Metric {
  int id; // TODO: Possibly string (hash or something for ID)
  String name;
  int value;
  String unit;
}

class Recommendation {
  int id; // TODO: Possibly string (hash or something for ID)
  int observerId;
  int minigameId;
  List<Metric> goals;
  List<Metric> results;
  DateTime completedAt;
  DateTime deadline;
}

class Minigames {
  int id; // TODO: Possibly string (hash or something for ID)
  List<Minigame> minigames;
}

class Minigame {
  int id; // TODO: Possibly string (hash or something for ID)
  String name, description;
  List<String> tags;
  List<Metric> availableMetrics;
}
