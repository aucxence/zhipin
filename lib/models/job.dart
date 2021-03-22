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
  String commissionSystem;

  String get getId => id;

  void setId(String id) => this.id = id;

  String get getJobtitle => jobtitle;

  void setJobtitle(String jobtitle) => this.jobtitle = jobtitle;

  num get getJobsalarymin => jobsalarymin;

  void setJobsalarymin(num jobsalarymin) => this.jobsalarymin = jobsalarymin;

  num get getJobsalarymax => jobsalarymax;

  void setJobsalarymax(num jobsalarymax) => this.jobsalarymax = jobsalarymax;

  String get getCompanyid => companyid;

  void setCompanyid(String companyid) => this.companyid = companyid;

  String get getCompanyname => companyname;

  void setCompanyname(String companyname) => this.companyname = companyname;

  String get getCompanycategory => companycategory;

  void setCompanycategory(String companycategory) =>
      this.companycategory = companycategory;

  String get getCompanyicon => companyicon;

  void setCompanyicon(String companyicon) => this.companyicon = companyicon;

  String get getJobtown => jobtown;

  void setJobtown(String jobtown) => this.jobtown = jobtown;

  String get getNeighborhood => neighborhood;

  void setNeighborhood(String neighborhood) => this.neighborhood = neighborhood;

  num get getExperiencemin => experiencemin;

  void setExperiencemin(num experiencemin) =>
      this.experiencemin = experiencemin;

  num get getExperiencemax => experiencemax;

  void setExperiencemax(num experiencemax) =>
      this.experiencemax = experiencemax;

  String get getDegree => degree;

  void setDegree(String degree) => this.degree = degree;

  String get getRecruitername => recruitername;

  void setRecruitername(String recruitername) =>
      this.recruitername = recruitername;

  String get getRecruiterpic => recruiterpic;

  void setRecruiterpic(String recruiterpic) => this.recruiterpic = recruiterpic;

  String get getRecruiterposition => recruiterposition;

  void setRecruiterposition(String recruiterposition) =>
      this.recruiterposition = recruiterposition;

  String get getRecruiterId => recruiterId;

  void setRecruiterId(String recruiterId) => this.recruiterId = recruiterId;

  bool get getAvailable => available;

  void setAvailable(bool available) => this.available = available;

  String get getCreatedAt => createdAt;

  void setCreatedAt(String createdAt) => this.createdAt = createdAt;

  List get getTechnical => technical;

  void setTechnical(List technical) => this.technical = technical;

  String get getJobdetailsid => jobdetailsid;

  void setJobdetailsid(String jobdetailsid) => this.jobdetailsid = jobdetailsid;

  num get getViewcount => viewcount;

  void setViewcount(num viewcount) => this.viewcount = viewcount;

  String get getCommissionSystem => commissionSystem;

  void setCommissionSystem(String commissionSystem) =>
      this.commissionSystem = commissionSystem;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
  Map<String, dynamic> toJson() => _$JobToJson(this);
}
