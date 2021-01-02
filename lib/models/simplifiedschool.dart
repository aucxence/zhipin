import 'package:json_annotation/json_annotation.dart';

part 'simplifiedschool.g.dart';

@JsonSerializable()
class Simplifiedschool {
    Simplifiedschool();

    String schoolfullname;
    String schoolshortname;
    
    factory Simplifiedschool.fromJson(Map<String,dynamic> json) => _$SimplifiedschoolFromJson(json);
    Map<String, dynamic> toJson() => _$SimplifiedschoolToJson(this);
}
