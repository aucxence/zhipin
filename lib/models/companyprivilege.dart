import 'package:json_annotation/json_annotation.dart';

part 'companyprivilege.g.dart';

@JsonSerializable()
class Companyprivilege {
    Companyprivilege();

    bool insurance;
    bool congepaye;
    bool food;
    bool businesstrips;
    bool salarybonus;
    
    factory Companyprivilege.fromJson(Map<String,dynamic> json) => _$CompanyprivilegeFromJson(json);
    Map<String, dynamic> toJson() => _$CompanyprivilegeToJson(this);
}
