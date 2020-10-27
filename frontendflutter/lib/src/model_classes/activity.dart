import 'package:json_annotation/json_annotation.dart';

import 'metric.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true)
class Activity {
  // @JsonKey(required: true)
  // String id;

  // @JsonKey(required: true)
  // String createdAt;

  @JsonKey(required: true)
  String minigameID;

  @JsonKey(required: false)
  List<Metric> metrics;

  Activity({this.minigameID, this.metrics});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$ActivityFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ActivityToJson`.
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
