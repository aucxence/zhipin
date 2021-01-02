import 'package:json_annotation/json_annotation.dart';

part 'career.g.dart';

@JsonSerializable()
class Career {
    Career();

    String career;
    List choices;
    
    factory Career.fromJson(Map<String,dynamic> json) => _$CareerFromJson(json);
    Map<String, dynamic> toJson() => _$CareerToJson(this);
}
