import 'package:json_annotation/json_annotation.dart';

part 'companymember.g.dart';

@JsonSerializable()
class Companymember {
    Companymember();

    String id;
    String position;
    String firstname;
    String lastname;
    
    factory Companymember.fromJson(Map<String,dynamic> json) => _$CompanymemberFromJson(json);
    Map<String, dynamic> toJson() => _$CompanymemberToJson(this);
}
