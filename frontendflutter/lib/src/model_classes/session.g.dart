// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'duration', 'createdAt']);
  return Session(
    id: json['id'] as int,
    duration: json['duration'] as String,
    createdAt: json['createdAt'] as String,
    activities: (json['activities'] as List)
        ?.map((e) =>
            e == null ? null : Activity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'duration': instance.duration,
      'createdAt': instance.createdAt,
      'activities': instance.activities?.map((e) => e?.toJson())?.toList(),
    };
