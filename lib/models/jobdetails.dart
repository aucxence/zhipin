import 'package:json_annotation/json_annotation.dart';

part 'jobdetails.g.dart';

@JsonSerializable()
class Jobdetails {
    Jobdetails();

    String id;
    String task;
    String Note;
    num staffrangemin;
    num staffrangemax;
    String companyfield;
    String jobid;
    num viewcount;
    
    factory Jobdetails.fromJson(Map<String,dynamic> json) => _$JobdetailsFromJson(json);
    Map<String, dynamic> toJson() => _$JobdetailsToJson(this);
}
