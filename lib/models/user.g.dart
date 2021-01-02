// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as String
    ..birthdate = json['birthdate'] as String
    ..createdAt = json['createdAt'] as String
    ..email = json['email'] as String
    ..fields = (json['fields'] as List)
        ?.map(
            (e) => e == null ? null : Field.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..firstname = json['firstname'] as String
    ..gender = json['gender'] as String
    ..lastname = json['lastname'] as String
    ..livesin = json['livesin'] as String
    ..password = json['password'] as String
    ..phonenumber = json['phonenumber'] as String
    ..countrycode = json['countrycode'] as String
    ..username = json['username'] as String
    ..templates = json['templates'] as List
    ..firsttime = json['firsttime'] as bool
    ..respectrules = json['respectrules'] as bool
    ..chats = json['chats'] as List
    ..jobs = (json['jobs'] as List)
        ?.map((e) =>
            e == null ? null : Userjob.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..userpics = json['userpics'] as List;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'birthdate': instance.birthdate,
      'createdAt': instance.createdAt,
      'email': instance.email,
      'fields': instance.fields,
      'firstname': instance.firstname,
      'gender': instance.gender,
      'lastname': instance.lastname,
      'livesin': instance.livesin,
      'password': instance.password,
      'phonenumber': instance.phonenumber,
      'countrycode': instance.countrycode,
      'username': instance.username,
      'templates': instance.templates,
      'firsttime': instance.firsttime,
      'respectrules': instance.respectrules,
      'chats': instance.chats,
      'jobs': instance.jobs,
      'userpics': instance.userpics
    };
