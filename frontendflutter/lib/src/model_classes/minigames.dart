import 'package:json_annotation/json_annotation.dart';
import 'minigame.dart';

part 'minigames.g.dart';

@JsonSerializable(explicitToJson: true)
class Minigames {
  @JsonKey(required: true)
  String id;

  @JsonKey(required: true)
  List<Minigame> minigames;

  Minigames({this.id, this.minigames});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$MinigamesFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Minigames.fromJson(Map<String, dynamic> json) =>
      _$MinigamesFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$MinigamesToJson`.
  Map<String, dynamic> toJson() => _$MinigamesToJson(this);
}
