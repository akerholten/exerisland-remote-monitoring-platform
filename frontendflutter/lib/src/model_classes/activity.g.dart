// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['minigameID']);
  return Activity(
    minigameID: json['minigameID'] as String,
    metrics: (json['metrics'] as List)
        ?.map((e) =>
            e == null ? null : Metric.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'minigameID': instance.minigameID,
      'metrics': instance.metrics?.map((e) => e?.toJson())?.toList(),
    };
