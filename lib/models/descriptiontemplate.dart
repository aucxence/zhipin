import 'package:json_annotation/json_annotation.dart';

part 'descriptiontemplate.g.dart';

@JsonSerializable()
class Descriptiontemplate {
    Descriptiontemplate();

    String userpics;
    String position;
    String description;
    
    factory Descriptiontemplate.fromJson(Map<String,dynamic> json) => _$DescriptiontemplateFromJson(json);
    Map<String, dynamic> toJson() => _$DescriptiontemplateToJson(this);
}
