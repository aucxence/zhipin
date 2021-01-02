import 'package:json_annotation/json_annotation.dart';
import "specifics.dart";
part 'fieldareas.g.dart';

@JsonSerializable()
class Fieldareas {
    Fieldareas();

    String field;
    List<Specifics> specifics;
    
    factory Fieldareas.fromJson(Map<String,dynamic> json) => _$FieldareasFromJson(json);
    Map<String, dynamic> toJson() => _$FieldareasToJson(this);
}
