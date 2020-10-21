// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'id',
    'observerId',
    'minigameId',
    'goals',
    'deadline'
  ]);
  return Recommendation(
    id: json['id'] as String,
    observerId: json['observerId'] as String,
    minigameId: json['minigameId'] as String,
    goals: (json['goals'] as List)
        ?.map((e) =>
            e == null ? null : Metric.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    results: (json['results'] as List)
        ?.map((e) =>
            e == null ? null : Metric.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    deadline: json['deadline'] as String,
    completedAt: json['completedAt'] as String,
  );
}

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'observerId': instance.observerId,
      'minigameId': instance.minigameId,
      'goals': instance.goals?.map((e) => e?.toJson())?.toList(),
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
      'deadline': instance.deadline,
      'completedAt': instance.completedAt,
    };
