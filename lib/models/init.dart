import 'package:json_annotation/json_annotation.dart';

part 'init.g.dart';

@JsonSerializable()
class Init {
  Init();

  bool mode;
  String language;
  String fontFamily;

  factory Init.fromJson(Map<String, dynamic> json) => _$InitFromJson(json);
  Map<String, dynamic> toJson() => _$InitToJson(this);
}
