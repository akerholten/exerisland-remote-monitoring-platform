// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addPatientForm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddPatientForm _$AddPatientFormFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['firstName', 'lastName', 'email', 'birthDate']);
  return AddPatientForm(
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    birthDate: json['birthDate'] as String,
    note: json['note'] as String,
  );
}

Map<String, dynamic> _$AddPatientFormToJson(AddPatientForm instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'birthDate': instance.birthDate,
      'note': instance.note,
    };
