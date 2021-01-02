// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatmessage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chatmessage _$ChatmessageFromJson(Map<String, dynamic> json) {
  return Chatmessage()
    ..id = json['id'].toString() as String
    ..from = json['fromid'].toString() as String
    ..message = Map<String, dynamic>.from(json['message']) 
    ..to = json['toid'].toString() as String;
}

Map<String, dynamic> _$ChatmessageToJson(Chatmessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromid': instance.from,
      'message': instance.message,
      'toid': instance.to
    };
