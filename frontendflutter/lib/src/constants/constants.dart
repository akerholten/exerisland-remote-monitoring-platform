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
  int age, recommendations, recommendationsCompleted;
  DateTime dateOfBirth;
}
