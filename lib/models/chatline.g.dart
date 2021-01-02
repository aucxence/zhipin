// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chatline _$ChatlineFromJson(Map<String, dynamic> json) {
  return Chatline()
    ..id = json['id'].toString() as String
    ..jobid = json['jobid'].toString() as String
    ..jobdetailsid = json['jobdetailsid'].toString() as String
    ..chatid = json['chatid'].toString() as String
    ..messages = (json['messages'] as List)
        ?.map((e) {
           
            return e == null ? null : Chatmessage.fromJson(Map<String, dynamic>.from(e));
        })
        ?.toList();
}

Map<String, dynamic> _$ChatlineToJson(Chatline instance) => <String, dynamic>{
      'id': instance.id,
      'jobid': instance.jobid,
      'jobdetailsid': instance.jobdetailsid,
      'chatid': instance.chatid,
      'messages': instance.messages
    };
