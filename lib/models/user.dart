import 'package:json_annotation/json_annotation.dart';
import "field.dart";
import "userjob.dart";
part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  String id;
  String birthdate;
  String createdAt;
  String email;
  List<Field> fields;
  String firstname;
  String gender;
  String lastname;
  String livesin;
  String password;
  String phonenumber;
  String countrycode;
  String username;
  List templates;
  bool firsttime;
  bool respectrules;
  List chats;
  List<Userjob> jobs;
  List userpics;

  bool type = false;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
