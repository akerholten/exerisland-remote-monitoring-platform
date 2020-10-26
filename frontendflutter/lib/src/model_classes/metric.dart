import 'package:json_annotation/json_annotation.dart';

part 'metric.g.dart';

@JsonSerializable(explicitToJson: true)
class Metric {
  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  String value;

  @JsonKey(required: true)
  String unit;

  Metric({this.name, this.value, this.unit});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$MetricFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Metric.fromJson(Map<String, dynamic> json) => _$MetricFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$MetricToJson`.
  Map<String, dynamic> toJson() => _$MetricToJson(this);

  String nameAndUnit() {
    return name + " (" + unit + ")";
  }
}
