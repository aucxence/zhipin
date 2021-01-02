import 'package:json_annotation/json_annotation.dart';

part 'chatmessage.g.dart';

@JsonSerializable()
class Chatmessage {
    Chatmessage();

    String id;
    String from;
    Map<String,dynamic> message;
    String to;
    
    factory Chatmessage.fromJson(Map<String,dynamic> json) => _$ChatmessageFromJson(json);
    Map<String, dynamic> toJson() => _$ChatmessageToJson(this);
}
