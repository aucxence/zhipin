import 'package:json_annotation/json_annotation.dart';

part 'userjob.g.dart';

@JsonSerializable()
class Userjob {
    Userjob();

    String id;
    String appliedOn;
    String relatedchatid;
    
    factory Userjob.fromJson(Map<String,dynamic> json) => _$UserjobFromJson(json);
    Map<String, dynamic> toJson() => _$UserjobToJson(this);
}
