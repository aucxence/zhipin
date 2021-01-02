import 'package:json_annotation/json_annotation.dart';

part 'major.g.dart';

@JsonSerializable()
class Major {
    Major();

    String majorfullname;
    String majorshortname;
    
    factory Major.fromJson(Map<String,dynamic> json) => _$MajorFromJson(json);
    Map<String, dynamic> toJson() => _$MajorToJson(this);
}
