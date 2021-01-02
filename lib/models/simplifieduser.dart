import 'package:json_annotation/json_annotation.dart';

part 'simplifieduser.g.dart';

@JsonSerializable()
class Simplifieduser {
    Simplifieduser();

    String id;
    String name;
    String pic;
    String userid;
    
    factory Simplifieduser.fromJson(Map<String,dynamic> json) => _$SimplifieduserFromJson(json);
    Map<String, dynamic> toJson() => _$SimplifieduserToJson(this);
}
