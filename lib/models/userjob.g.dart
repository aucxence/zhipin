// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userjob.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Userjob _$UserjobFromJson(Map<String, dynamic> json) {
  return Userjob()
    ..id = json['id'] as String
    ..appliedOn = json['appliedOn'] as String
    ..relatedchatid = json['relatedchatid'] as String;
}

Map<String, dynamic> _$UserjobToJson(Userjob instance) => <String, dynamic>{
      'id': instance.id,
      'appliedOn': instance.appliedOn,
      'relatedchatid': instance.relatedchatid
    };
