// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patients.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patients _$PatientsFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['list']);
  return Patients(
    list: (json['list'] as List)
        ?.map((e) =>
            e == null ? null : Patient.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PatientsToJson(Patients instance) => <String, dynamic>{
      'list': instance.list?.map((e) => e?.toJson())?.toList(),
    };
