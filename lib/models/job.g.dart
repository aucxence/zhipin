// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) {
  return Job()
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
    ..technical = json['technical'] as List;
}

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'jobtitle': instance.jobtitle,
      'jobsalarymin': instance.jobsalarymin,
      'jobsalarymax': instance.jobsalarymax,
      'experiencemin': instance.experiencemin,
      'experiencemax': instance.experiencemax,
      'degree': instance.degree,
      'technical': instance.technical,
      'commissionSystem': instance.commissionSystem,
      'description': instance.description,
      'sidenote': instance.sidenote,
      'jobtown': instance.jobtown,
      'neighborhood': instance.neighborhood,
      'companyid': instance.companyid,
      'companyname': instance.companyname,
      'companycategory': instance.companycategory,
      'companyicon': instance.companyicon,
      'staffrangemin': instance.staffrangemin,
      'staffrangemax': instance.staffrangemax,
      'companyfield': instance.companyfield,
      'recruitername': instance.recruitername,
      'recruiterpic': instance.recruiterpic,
      'recruiterposition': instance.recruiterposition,
      'recruiterId': (instance.recruiterId != null) ? instance.recruiterId : '',
      'available': instance.available,
    };
