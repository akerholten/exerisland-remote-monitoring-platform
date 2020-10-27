import 'package:json_annotation/json_annotation.dart';

import 'activity.dart';

part 'session.g.dart';

@JsonSerializable(explicitToJson: true)
class Session {
  @JsonKey(required: true)
  int id;

  @JsonKey(required: true)
  String duration;

  @JsonKey(required: true)
  String createdAt;

  @JsonKey(required: false)
  List<Activity> activities;

  Session({this.id, this.duration, this.createdAt, this.activities});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$SessionFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PatientToJson`.
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
