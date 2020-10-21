import 'package:json_annotation/json_annotation.dart';
import 'patient.dart';

part 'patients.g.dart';

@JsonSerializable(explicitToJson: true)
class Patients {
  @JsonKey(required: true)
  List<Patient> list;

  Patients({this.list});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$PatientsFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Patients.fromJson(List<dynamic> json) {
    List<Patient> patients = new List<Patient>();
    patients = json.map((i) => Patient.fromJson(i)).toList();

    return new Patients(list: patients);
  }
  // _$PatientsFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PatientsToJson`.
  Map<String, dynamic> toJson() => _$PatientsToJson(this);
}
