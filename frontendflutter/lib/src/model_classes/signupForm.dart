import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signupForm.g.dart';

@JsonSerializable(explicitToJson: true)
class SignupForm {
  @JsonKey(required: true)
  String email;

  @JsonKey(required: true)
  String firstName;

  @JsonKey(required: true)
  String lastName;

  @JsonKey(required: true)
  String password;

  @JsonKey(defaultValue: "observer")
  String userType;

  String organizationID;

  SignupForm(
      {this.email,
      this.firstName,
      this.lastName,
      this.password,
      this.userType,
      this.organizationID});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$SignupFormFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SignupForm.fromJson(Map<String, dynamic> json) =>
      _$SignupFormFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SignupFormToJson(this);
}
