class Constants {
  static const String applicationName = "VR Health and Wellness Monitoring";
  static const String backendURL = "http://localhost:8080";
  static const String dateFormat = "dd/MM/yyyy";
}

class PatientDashboardArguments {
  final String id;

  PatientDashboardArguments(this.id);
}

// TODO: Change into model class with ToJson and FromJson functions
// class Patient {
//   String firstName,
//       lastName,
//       email,
//       issue,
//       recentActivity; // TODO: change recent activity to be date
//   int id; // TODO: Possibly string (hash or something for ID)
//   int age, recommendationsCount, recommendationsCompleted;
//   List<Session> sessions;
//   List<Recommendation> recommendations;
//   DateTime birthDate;

//   int getTotalTaskCompleted() {
//     int count = 0;
//     recommendations.forEach((rec) {
//       if (rec.completedAt != null) {
//         count++;
//       }
//     });

//     return count;
//   }
// }

// class Session {
//   int id; // TODO: Possibly string (hash or something for ID)
//   Duration duration;
//   DateTime createdAt;
//   List<Activity> activities;
// }

// class Activity {
//   int id; // TODO: Possibly string (hash or something for ID)
//   int minigameId; // TODO: Possibly string (hash or something for ID)
//   DateTime createdAt;
//   List<Metric> metrics;
// }

// class Metric {
//   int id; // TODO: Possibly string (hash or something for ID)
//   String name;
//   int value;
//   String unit;

//   String nameAndUnit() {
//     return name + " (" + unit + ")";
//   }
// }

// class Recommendation {
//   int id; // TODO: Possibly string (hash or something for ID)
//   int observerId;
//   int minigameId;
//   List<Metric> goals;
//   List<Metric> results;
//   DateTime completedAt;
//   DateTime deadline;
// }

// class Minigames {
//   int id; // TODO: Possibly string (hash or something for ID)
//   List<Minigame> minigames;
// }

// class Minigame {
//   int id; // TODO: Possibly string (hash or something for ID)
//   String name, description;
//   List<String> tags;
//   List<Metric> availableMetrics;

//   String getTagsAsStringList() {
//     String rtrString = "";

//     for (int i = 0; i < tags.length; i++) {
//       rtrString += tags[i];
//       if (i != tags.length - 1) {
//         rtrString += ", ";
//       }
//     }

//     return rtrString;
//   }
// }
