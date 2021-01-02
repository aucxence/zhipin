import 'package:json_annotation/json_annotation.dart';

part 'field.g.dart';

@JsonSerializable()
class Field {
    Field();

    String id;
    String Position;
    num salarymin;
    num salarymax;
    String ville;
    
    factory Field.fromJson(Map<String,dynamic> json) => _$FieldFromJson(json);
    Map<String, dynamic> toJson() => _$FieldToJson(this);
}
