// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simplifieduser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Simplifieduser _$SimplifieduserFromJson(Map<String, dynamic> json) {
  return Simplifieduser()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..pic = json['pic'] as String
    ..userid = json['userid'] as String;
}

Map<String, dynamic> _$SimplifieduserToJson(Simplifieduser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pic': instance.pic,
      'userid': instance.userid
    };
