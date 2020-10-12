// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signupForm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupForm _$SignupFormFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['email', 'firstName', 'lastName', 'password']);
  return SignupForm(
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    password: json['password'] as String,
    userType: json['userType'] as String ?? 'observer',
    organizationID: json['organizationID'] as String,
  );
}

Map<String, dynamic> _$SignupFormToJson(SignupForm instance) =>
    <String, dynamic>{
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'password': instance.password,
      'userType': instance.userType,
      'organizationID': instance.organizationID,
    };
