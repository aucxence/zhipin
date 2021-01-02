import 'package:json_annotation/json_annotation.dart';
import "companyprivilege.dart";
import "companymember.dart";
part 'company.g.dart';

@JsonSerializable()
class Company {
    Company();

    String id;
    String shortname;
    String fullname;
    String companyicon;
    String workschedulemin;
    String workschedulemax;
    bool flexiblehours;
    String introduction;
    String companyfield;
    List companykeywords;
    num capital;
    List pics;
    Companyprivilege privileges;
    String category;
    String town;
    String neighborhood;
    num staffrangemin;
    num staffrangemax;
    List<Companymember> members;
    String website;
    String startedOn;
    bool stateofbusiness;
    List jobs;
    
    factory Company.fromJson(Map<String,dynamic> json) => _$CompanyFromJson(json);
    Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
