// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fieldareas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fieldareas _$FieldareasFromJson(Map<String, dynamic> json) {
  return Fieldareas()
    ..field = json['field'] as String
    ..specifics = (json['specifics'] as List)
        ?.map((e) =>
            e == null ? null : Specifics.fromJson(Map<String, dynamic>.from(e)))
        ?.toList();
}

Map<String, dynamic> _$FieldareasToJson(Fieldareas instance) =>
    <String, dynamic>{'field': instance.field, 'specifics': instance.specifics};
