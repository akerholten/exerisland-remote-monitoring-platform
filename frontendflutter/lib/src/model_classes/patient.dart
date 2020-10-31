import 'package:json_annotation/json_annotation.dart';

import 'recommendation.dart';
import 'session.dart';

part 'patient.g.dart';

@JsonSerializable(explicitToJson: true)
class Patient {
  @JsonKey(required: true)
  String firstName;

  @JsonKey(required: true)
  String lastName;

  @JsonKey(required: true)
  String email;

  @JsonKey(required: true)
  String birthDate;

  @JsonKey(required: false)
  String recentActivityDate;

  @JsonKey(required: false)
  String note;

  @JsonKey(required: false)
  String shortID;

  // maybe obsolete, consider it (TODO: remove)
  @JsonKey(required: false, defaultValue: 0)
  int age;

  // maybe obsolete, consider it
  @JsonKey(required: false, defaultValue: 0)
  int recommendationsCount;

  // maybe obsolete, consider it
  @JsonKey(required: false, defaultValue: 0)
  int recommendationsCompleted;

  @JsonKey(required: false, nullable: true)
  List<Session> sessions;

  // @JsonKey(required: false, defaultValue: {[]})
  @JsonKey(required: false, nullable: true)
  List<Recommendation> recommendations;

  Patient(
      {this.firstName,
      this.lastName,
      this.email,
      this.birthDate,
      this.recentActivityDate,
      this.note,
      this.recommendations,
      this.sessions});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$PatientFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Patient.fromJson(Map<String, dynamic> json) {
    Patient patient = _$PatientFromJson(json);

    if (patient.sessions == null) {
      patient.sessions = new List<Session>();
    }
    if (patient.recommendations == null) {
      patient.recommendations = new List<Recommendation>();
    }

    return patient;
  }

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PatientToJson`.
  Map<String, dynamic> toJson() => _$PatientToJson(this);

  int getTotalTaskCompleted() {
    int count = 0;
    recommendations.forEach((rec) {
      if (rec.completedAt != null) {
        count++;
      }
    });

    return count;
  }

  double getTasksCompletedPercentage() {
    if (recommendations.length == 0) {
      return 0.0;
    } else {
      return getTotalTaskCompleted() / recommendations.length;
    }
  }
}
