import 'package:json_annotation/json_annotation.dart';

part 'specifics.g.dart';

@JsonSerializable()
class Specifics {
    Specifics();

    String area;
    List jobs;
    
    factory Specifics.fromJson(Map<String,dynamic> json) => _$SpecificsFromJson(json);
    Map<String, dynamic> toJson() => _$SpecificsToJson(this);
}
