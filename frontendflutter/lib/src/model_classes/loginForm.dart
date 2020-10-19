import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loginForm.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginForm {
  @JsonKey(required: true)
  String email;

  @JsonKey(required: true)
  String password;

  LoginForm({this.email, this.password});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$LoginFormFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory LoginForm.fromJson(Map<String, dynamic> json) =>
      _$LoginFormFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$LoginFormToJson`.
  Map<String, dynamic> toJson() => _$LoginFormToJson(this);
}
