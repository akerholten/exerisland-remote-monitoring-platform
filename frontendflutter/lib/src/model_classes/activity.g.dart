// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'minigameId', 'createdAt']);
  return Activity(
    id: json['id'] as String,
    minigameId: json['minigameId'] as String,
    createdAt: json['createdAt'] as String,
    metrics: (json['metrics'] as List)
        ?.map((e) =>
            e == null ? null : Metric.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'minigameId': instance.minigameId,
      'createdAt': instance.createdAt,
      'metrics': instance.metrics?.map((e) => e?.toJson())?.toList(),
    };
