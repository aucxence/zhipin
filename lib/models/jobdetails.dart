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

  String get getId => this.id;

  void setId(String id) => this.id = id;

  get getTask => this.task;

  void setTask(task) => this.task = task;

  get getNote => this.Note;

  void setNote(Note) => this.Note = Note;

  get getStaffrangemin => this.staffrangemin;

  void setStaffrangemin(staffrangemin) => this.staffrangemin = staffrangemin;

  get getStaffrangemax => this.staffrangemax;

  void setStaffrangemax(staffrangemax) => this.staffrangemax = staffrangemax;

  get getCompanyfield => this.companyfield;

  void setCompanyfield(companyfield) => this.companyfield = companyfield;

  get getJobid => this.jobid;

  void setJobid(jobid) => this.jobid = jobid;

  get getViewcount => this.viewcount;

  void setViewcount(viewcount) => this.viewcount = viewcount;

  factory Jobdetails.fromJson(Map<String, dynamic> json) =>
      _$JobdetailsFromJson(json);
  Map<String, dynamic> toJson() => _$JobdetailsToJson(this);
}
