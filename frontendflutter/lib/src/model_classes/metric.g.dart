// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Metric _$MetricFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'name', 'value', 'unit']);
  return Metric(
    id: json['id'] as String,
    name: json['name'] as String,
    value: json['value'] as int,
    unit: json['unit'] as String,
  );
}

Map<String, dynamic> _$MetricToJson(Metric instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'unit': instance.unit,
    };
