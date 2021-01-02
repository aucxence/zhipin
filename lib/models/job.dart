import 'package:json_annotation/json_annotation.dart';

part 'job.g.dart';

@JsonSerializable()
class Job {
    Job();

    String id;
    String jobtitle;
    num jobsalarymin;
    num jobsalarymax;
    String companyid;
    String companyname;
    String companycategory;
    String companyicon;
    String jobtown;
    String neighborhood;
    num experiencemin;
    num experiencemax;
    String degree;
    String recruitername;
    String recruiterpic;
    String recruiterposition;
    bool available;
    String createdAt;
    List technical;
    String jobdetailsid;
    num viewcount;
    
    factory Job.fromJson(Map<String,dynamic> json) => _$JobFromJson(json);
    Map<String, dynamic> toJson() => _$JobToJson(this);
}
