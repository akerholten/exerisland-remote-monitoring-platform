import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'addPatientForm.g.dart';

@JsonSerializable(explicitToJson: true)
class AddPatientForm {
  @JsonKey(required: true)
  String firstName;

  @JsonKey(required: true)
  String lastName;

  @JsonKey(required: true)
  String email;

  @JsonKey(required: true)
  String dateOfBirth;

  @JsonKey(required: false)
  String note;

  AddPatientForm(
      {this.firstName, this.lastName, this.email, this.dateOfBirth, this.note});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$AddPatientFormFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AddPatientForm.fromJson(Map<String, dynamic> json) =>
      _$AddPatientFormJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$AddPatientFormToJson`.
  Map<String, dynamic> toJson() => _$AddPatientFormToJson(this);
}
