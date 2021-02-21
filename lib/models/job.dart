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
  String recruiterId;
  bool available;
  String createdAt;
  List technical;
  String jobdetailsid;
  num viewcount;
  String get getId => id;

  set setId(String id) => this.id = id;

  String get getJobtitle => jobtitle;

  set setJobtitle(String jobtitle) => this.jobtitle = jobtitle;

  num get getJobsalarymin => jobsalarymin;

  set setJobsalarymin(num jobsalarymin) => this.jobsalarymin = jobsalarymin;

  num get getJobsalarymax => jobsalarymax;

  set setJobsalarymax(num jobsalarymax) => this.jobsalarymax = jobsalarymax;

  String get getCompanyid => companyid;

  set setCompanyid(String companyid) => this.companyid = companyid;

  String get getCompanyname => companyname;

  set setCompanyname(String companyname) => this.companyname = companyname;

  String get getCompanycategory => companycategory;

  set setCompanycategory(String companycategory) =>
      this.companycategory = companycategory;

  String get getCompanyicon => companyicon;

  set setCompanyicon(String companyicon) => this.companyicon = companyicon;

  String get getJobtown => jobtown;

  set setJobtown(String jobtown) => this.jobtown = jobtown;

  String get getNeighborhood => neighborhood;

  set setNeighborhood(String neighborhood) => this.neighborhood = neighborhood;

  num get getExperiencemin => experiencemin;

  set setExperiencemin(num experiencemin) => this.experiencemin = experiencemin;

  num get getExperiencemax => experiencemax;

  set setExperiencemax(num experiencemax) => this.experiencemax = experiencemax;

  String get getDegree => degree;

  set setDegree(String degree) => this.degree = degree;

  String get getRecruitername => recruitername;

  set setRecruitername(String recruitername) =>
      this.recruitername = recruitername;

  String get getRecruiterpic => recruiterpic;

  set setRecruiterpic(String recruiterpic) => this.recruiterpic = recruiterpic;

  String get getRecruiterposition => recruiterposition;

  set setRecruiterposition(String recruiterposition) =>
      this.recruiterposition = recruiterposition;

  String get getRecruiterId => recruiterId;

  set setRecruiterId(String recruiterId) => this.recruiterId = recruiterId;

  bool get getAvailable => available;

  set setAvailable(bool available) => this.available = available;

  String get getCreatedAt => createdAt;

  set setCreatedAt(String createdAt) => this.createdAt = createdAt;

  List get getTechnical => technical;

  set setTechnical(List technical) => this.technical = technical;

  String get getJobdetailsid => jobdetailsid;

  set setJobdetailsid(String jobdetailsid) => this.jobdetailsid = jobdetailsid;

  num get getViewcount => viewcount;

  set setViewcount(num viewcount) => this.viewcount = viewcount;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
