class Constants {
  static const String applicationName = "VR Health and Wellness Monitoring";
  static const String backendURL = "http://localhost:8080";
  static const String dateFormat = "dd/MM/yyyy";

  static const double pageMaxWidth = 1600;
  static const double pageMaxHeight = 900;
}

class PatientDashboardArguments {
  final String id;

  PatientDashboardArguments(this.id);
}
