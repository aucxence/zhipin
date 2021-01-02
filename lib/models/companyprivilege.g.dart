// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'companyprivilege.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Companyprivilege _$CompanyprivilegeFromJson(Map<String, dynamic> json) {
  return Companyprivilege()
    ..insurance = json['insurance'] as bool
    ..congepaye = json['congepaye'] as bool
    ..food = json['food'] as bool
    ..businesstrips = json['businesstrips'] as bool
    ..salarybonus = json['salarybonus'] as bool;
}

Map<String, dynamic> _$CompanyprivilegeToJson(Companyprivilege instance) =>
    <String, dynamic>{
      'insurance': instance.insurance,
      'congepaye': instance.congepaye,
      'food': instance.food,
      'businesstrips': instance.businesstrips,
      'salarybonus': instance.salarybonus
    };
