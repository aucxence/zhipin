// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jobdetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Jobdetails _$JobdetailsFromJson(Map<String, dynamic> json) {
  return Jobdetails()
    ..id = json['id'].toString() as String
    ..task = json['task'] as String
    ..Note = json['Note'] as String
    ..staffrangemin = json['staffrangemin'] as num
    ..staffrangemax = json['staffrangemax'] as num
    ..companyfield = json['companyfield'] as String
    ..jobid = json['jobid'].toString() as String
    ..viewcount = json['viewcount'] as num;
}

Map<String, dynamic> _$JobdetailsToJson(Jobdetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task': instance.task,
      'Note': instance.Note,
      'staffrangemin': instance.staffrangemin,
      'staffrangemax': instance.staffrangemax,
      'companyfield': instance.companyfield,
      'jobid': instance.jobid,
      'viewcount': instance.viewcount
    };
