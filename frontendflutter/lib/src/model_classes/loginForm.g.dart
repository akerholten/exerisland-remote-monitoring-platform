// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loginForm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginForm _$LoginFormFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['email', 'password']);
  return LoginForm(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$LoginFormToJson(LoginForm instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };
