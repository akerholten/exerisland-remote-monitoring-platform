import 'package:json_annotation/json_annotation.dart';

import 'metric.dart';

part 'minigame.g.dart';

@JsonSerializable(explicitToJson: true)
class Minigame {
  @JsonKey(required: true)
  String id;

  @JsonKey(required: true)
  String name;

  @JsonKey(required: false)
  String description;

  @JsonKey(required: false)
  List<String> tags;

  @JsonKey(required: true)
  List<Metric> availableMetrics;

  Minigame(
      {this.id, this.name, this.description, this.tags, this.availableMetrics});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$MinigameFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Minigame.fromJson(Map<String, dynamic> json) =>
      _$MinigameFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$MinigameToJson`.
  Map<String, dynamic> toJson() => _$MinigameToJson(this);

  String getTagsAsStringList() {
    String rtrString = "";

    for (int i = 0; i < tags.length; i++) {
      rtrString += tags[i];
      if (i != tags.length - 1) {
        rtrString += ", ";
      }
    }

    return rtrString;
  }
}
