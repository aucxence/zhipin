// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'career.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Career _$CareerFromJson(Map<String, dynamic> json) {
  return Career()
    ..career = json['career'] as String
    ..choices = json['choices'] as List;
}

Map<String, dynamic> _$CareerToJson(Career instance) =>
    <String, dynamic>{'career': instance.career, 'choices': instance.choices};
