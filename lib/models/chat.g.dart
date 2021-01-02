// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat()
    ..id = json['id'].toString() as String
    ..companyname = json['companyname'] as String
    ..date = json['date'] as String
    ..lastmsg = json['lastmsg'] as String
    ..bossid = json['bossid'] as String
    ..bossname = json['bossname'] as String
    ..bosspic = json['bosspic'] as String
    ..bossposition = json['bossposition'] as String
    ..jobid = json['jobid'].toString() as String
    ..unreadcount = json['unreadcount'] as num
    ..chatlineid = json['chatlineid'].toString() as String
    ..lasttime = json['lasttime'] as String;
}

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'companyname': instance.companyname,
      'date': instance.date,
      'lastmsg': instance.lastmsg,
      'bossid': instance.bossid,
      'bossname': instance.bossname,
      'bosspic': instance.bosspic,
      'bossposition': instance.bossposition,
      'jobid': instance.jobid,
      'unreadcount': instance.unreadcount,
      'chatlineid': instance.chatlineid,
      'lasttime': instance.lasttime
    };
