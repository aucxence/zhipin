// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) {
  return Job()
    ..id = json['id'].toString() as String
    ..jobtitle = json['jobtitle'] as String
    ..jobsalarymin = json['jobsalarymin'] as num
    ..jobsalarymax = json['jobsalarymax'] as num
    ..companyid = json['companyid'].toString() as String
    ..companyname = json['companyname'] as String
    ..companycategory = json['companycategory'] as String
    ..companyicon = json['companyicon'] as String
    ..jobtown = json['jobtown'] as String
    ..neighborhood = json['neighborhood'] as String
    ..experiencemin = json['experiencemin'] as num
    ..experiencemax = json['experiencemax'] as num
    ..degree = json['degree'] as String
    ..recruitername = json['recruitername'] as String
    ..recruiterpic = json['recruiterpic'] as String
    ..recruiterposition = json['recruiterposition'] as String
    ..recruiterId = (json['recruiterId'] != null) ? json['recruiterId'] : ''
    ..available = json['available'] as bool
    ..createdAt = json['createdAt'] as String
    ..technical = json['technical'] as List
    ..jobdetailsid = json['jobdetailsid'].toString() as String
    ..viewcount = json['viewcount'] as num;
}

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'jobtitle': instance.jobtitle,
      'jobsalarymin': instance.jobsalarymin,
      'jobsalarymax': instance.jobsalarymax,
      'companyid': instance.companyid,
      'companyname': instance.companyname,
      'companycategory': instance.companycategory,
      'companyicon': instance.companyicon,
      'jobtown': instance.jobtown,
      'neighborhood': instance.neighborhood,
      'experiencemin': instance.experiencemin,
      'experiencemax': instance.experiencemax,
      'degree': instance.degree,
      'recruitername': instance.recruitername,
      'recruiterpic': instance.recruiterpic,
      'recruiterposition': instance.recruiterposition,
      'recruiterId': (instance.recruiterId != null) ? instance.recruiterId : '',
      'available': instance.available,
      'createdAt': instance.createdAt,
      'technical': instance.technical,
      'jobdetailsid': instance.jobdetailsid,
      'viewcount': instance.viewcount,
    };
