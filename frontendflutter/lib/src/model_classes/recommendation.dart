import 'package:json_annotation/json_annotation.dart';

import 'metric.dart';

part 'recommendation.g.dart';

@JsonSerializable(explicitToJson: true)
class Recommendation {
  @JsonKey(required: true)
  String id;

  @JsonKey(required: true)
  String observerId;

  @JsonKey(required: true)
  String minigameId;

  @JsonKey(required: true)
  List<Metric> goals;

  @JsonKey(required: false)
  List<Metric> results;

  @JsonKey(required: true)
  String deadline;

  @JsonKey(required: false)
  String completedAt;

  Recommendation(
      {this.id,
      this.observerId,
      this.minigameId,
      this.goals,
      this.results,
      this.deadline,
      this.completedAt});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$RecommendationFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$RecommendationToJson`.
  Map<String, dynamic> toJson() => _$RecommendationToJson(this);
}
