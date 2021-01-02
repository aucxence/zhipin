import 'package:json_annotation/json_annotation.dart';

part 'simplifiedcompany.g.dart';

@JsonSerializable()
class Simplifiedcompany {
    Simplifiedcompany();

    String companyfullname;
    String shortname;
    
    factory Simplifiedcompany.fromJson(Map<String,dynamic> json) => _$SimplifiedcompanyFromJson(json);
    Map<String, dynamic> toJson() => _$SimplifiedcompanyToJson(this);
}
