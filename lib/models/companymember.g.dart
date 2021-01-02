// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companymember.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Companymember _$CompanymemberFromJson(Map<String, dynamic> json) {
  return Companymember()
    ..id = json['id'] as String
    ..position = json['position'] as String
    ..firstname = json['firstname'] as String
    ..lastname = json['lastname'] as String;
}

Map<String, dynamic> _$CompanymemberToJson(Companymember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': instance.position,
      'firstname': instance.firstname,
      'lastname': instance.lastname
    };
