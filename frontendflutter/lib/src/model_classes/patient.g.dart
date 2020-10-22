// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['firstName', 'lastName', 'email', 'birthDate']);
  return Patient(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    birthDate: json['birthDate'] as String,
    recentActivityDate: json['recentActivityDate'] as String,
    note: json['note'] as String,
    recommendations: (json['recommendations'] as List)
        ?.map((e) => e == null
            ? null
            : Recommendation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    sessions: (json['sessions'] as List)
        ?.map((e) =>
            e == null ? null : Session.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..shortID = json['shortID'] as String
    ..age = json['age'] as int ?? 0
    ..recommendationsCount = json['recommendationsCount'] as int ?? 0
    ..recommendationsCompleted = json['recommendationsCompleted'] as int ?? 0;
}

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'birthDate': instance.birthDate,
      'recentActivityDate': instance.recentActivityDate,
      'note': instance.note,
      'shortID': instance.shortID,
      'age': instance.age,
      'recommendationsCount': instance.recommendationsCount,
      'recommendationsCompleted': instance.recommendationsCompleted,
      'sessions': instance.sessions?.map((e) => e?.toJson())?.toList(),
      'recommendations':
          instance.recommendations?.map((e) => e?.toJson())?.toList(),
    };
