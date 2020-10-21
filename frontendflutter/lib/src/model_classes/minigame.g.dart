// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minigame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Minigame _$MinigameFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'name', 'availableMetrics']);
  return Minigame(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    availableMetrics: (json['availableMetrics'] as List)
        ?.map((e) =>
            e == null ? null : Metric.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MinigameToJson(Minigame instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'availableMetrics':
          instance.availableMetrics?.map((e) => e?.toJson())?.toList(),
    };
