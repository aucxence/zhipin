// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) {
  return Field()
    ..id = json['id'] as String
    ..Position = json['Position'] as String
    ..salarymin = json['salarymin'] as num
    ..salarymax = json['salarymax'] as num
    ..ville = json['ville'] as String;
}

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'id': instance.id,
      'Position': instance.Position,
      'salarymin': instance.salarymin,
      'salarymax': instance.salarymax,
      'ville': instance.ville
    };
