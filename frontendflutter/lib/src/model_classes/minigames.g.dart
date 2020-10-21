// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minigames.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Minigames _$MinigamesFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'minigames']);
  return Minigames(
    id: json['id'] as String,
    minigames: (json['minigames'] as List)
        ?.map((e) =>
            e == null ? null : Minigame.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$MinigamesToJson(Minigames instance) => <String, dynamic>{
      'id': instance.id,
      'minigames': instance.minigames?.map((e) => e?.toJson())?.toList(),
    };
