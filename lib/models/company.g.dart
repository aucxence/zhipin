// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return Company()
    ..id = json['id'] as String
    ..shortname = json['shortname'] as String
    ..fullname = json['fullname'] as String
    ..companyicon = json['companyicon'] as String
    ..workschedulemin = json['workschedulemin'] as String
    ..workschedulemax = json['workschedulemax'] as String
    ..flexiblehours = json['flexiblehours'] as bool
    ..introduction = json['introduction'] as String
    ..companyfield = json['companyfield'] as String
    ..companykeywords = json['companykeywords'] as List
    ..capital = json['capital'] as num
    ..pics = json['pics'] as List
    ..privileges = json['privileges'] == null
        ? null
        : Companyprivilege.fromJson(json['privileges'] as Map<String, dynamic>)
    ..category = json['category'] as String
    ..town = json['town'] as String
    ..neighborhood = json['neighborhood'] as String
    ..staffrangemin = json['staffrangemin'] as num
    ..staffrangemax = json['staffrangemax'] as num
    ..members = (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Companymember.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..website = json['website'] as String
    ..startedOn = json['startedOn'] as String
    ..stateofbusiness = json['stateofbusiness'] as bool
    ..jobs = json['jobs'] as List;
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'shortname': instance.shortname,
      'fullname': instance.fullname,
      'companyicon': instance.companyicon,
      'workschedulemin': instance.workschedulemin,
      'workschedulemax': instance.workschedulemax,
      'flexiblehours': instance.flexiblehours,
      'introduction': instance.introduction,
      'companyfield': instance.companyfield,
      'companykeywords': instance.companykeywords,
      'capital': instance.capital,
      'pics': instance.pics,
      'privileges': instance.privileges,
      'category': instance.category,
      'town': instance.town,
      'neighborhood': instance.neighborhood,
      'staffrangemin': instance.staffrangemin,
      'staffrangemax': instance.staffrangemax,
      'members': instance.members,
      'website': instance.website,
      'startedOn': instance.startedOn,
      'stateofbusiness': instance.stateofbusiness,
      'jobs': instance.jobs
    };
