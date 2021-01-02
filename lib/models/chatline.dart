import 'package:json_annotation/json_annotation.dart';
import "chatmessage.dart";
part 'chatline.g.dart';

@JsonSerializable()
class Chatline {
    Chatline();

    String id;
    String jobid;
    String jobdetailsid;
    String chatid;
    List<Chatmessage> messages;
    
    factory Chatline.fromJson(Map<String,dynamic> json) => _$ChatlineFromJson(json);
    Map<String, dynamic> toJson() => _$ChatlineToJson(this);
}
