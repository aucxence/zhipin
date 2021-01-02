import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
    Chat();

    String id;
    String companyname;
    String date;
    String lastmsg;
    String bossid;
    String bossname;
    String bosspic;
    String bossposition;
    String jobid;
    num unreadcount;
    String chatlineid;
    String lasttime;
    
    factory Chat.fromJson(Map<String,dynamic> json) => _$ChatFromJson(json);
    Map<String, dynamic> toJson() => _$ChatToJson(this);
}
