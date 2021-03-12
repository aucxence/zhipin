import 'package:scoped_model/scoped_model.dart';

class User {
  bool _gender = true;

  String _pic,
      _nom = "1",
      _prenom = "2",
      _birth = "1992-06",
      _profexp = "2015-06",
      _whatsappnumber = "1992",
      _company,
      _period1,
      _period2,
      _poscategory,
      _jobtags,
      _workdescription,
      _jobindustry,
      _jobachievement,
      _school,
      _degree,
      _major,
      _timeframe,
      schoolachievement,
      _advantage = '''
1. Diplomé en ingénieurie informatique (BAC + 5) avec mention
2. 10 ans d'expérience dans le dévelopement mobile
3. Pilote des projets innovants tels que ...
4. Certifié dans les technologies ...
5. ...
                        ''',
      _expectedstatus,
      _expectedjob,
      _expectedcareer,
      _expectedtown,
      _expectedmoney,
      _projectname,
      _projectrole,
      _projectduration1,
      _projectduration2,
      _projectdescription,
      _projectachievement,
      _projectlink,
      _socialmedia,
      _certifications,
      _uid;

  String get uid => _uid;
  String get pic => _pic;
  String get nom => _nom;
  String get prenom => _prenom;
  bool get gender => _gender;
  String get birth => _birth;
  String get profexp => _profexp;

  String get company => _company;
  String get period1 => _period1;
  String get period2 => _period2;
  String get poscategory => _poscategory;
  String get jobtags => _jobtags;
  String get workdescription => _workdescription;

  String get school => _school;
  String get degree => _degree;
  String get major => _major;
  String get timeframe => _timeframe;

  String get advantage => _advantage;

  String get expectedstatus => _expectedstatus;
  String get expectedjob => _expectedjob;
  String get expectedcareer => _expectedcareer;
  String get expectedtown => _expectedtown;
  String get expectedmoney => _expectedmoney;

  void updatePic(String pic) => _pic = pic;
  void updateNom(String nom) {
    _nom = nom;
    // notifyListeners();
  }

  void updatePrenom(String prenom) => _prenom = prenom;
  void updateWhatsAppNumber(String whatsappnumber) =>
      _whatsappnumber = whatsappnumber;
  void updateGender(bool gender) => _gender = gender;
  void updateBirth(String birth) => _birth = birth;
  void updateProfExp(String profexp) => _profexp = profexp;
  void updateCompany(String company) => _company = company;
  void updatePeriod1(String period1) => _period1 = period1;
  void updatePeriod2(String period2) => _period2 = period2;
  void updatePosCategory(String poscategory) => _poscategory = poscategory;
  void updateJobTags(String jobtags) => _jobtags = jobtags;
  void updateWorkDescription(String workdescription) =>
      _workdescription = workdescription;
  void updateSchool(String school) => _school = school;
  void updateDegree(String degree) => _degree = degree;
  void updateMajor(String major) => _major = major;
  void updateTimeFrame(String timeframe) => _timeframe = timeframe;
  void updateAdvantage(String advantage) => _advantage = advantage;
  void updateExpectedStatus(String expectedstatus) =>
      _expectedstatus = expectedstatus;
  void updateExpectedJob(String expectedjob) => _expectedjob = expectedjob;
  void updateExpectedCareer(String expectedcareer) =>
      _expectedcareer = expectedcareer;
  void updateExpectedTown(String expectedtown) => _expectedtown = expectedtown;
  void updateExpectedMoney(String expectedmoney) =>
      _expectedmoney = expectedmoney;
  void updateSocialMedia(String sodialmedia) => _socialmedia = socialmedia;
  void updateCertifications(String certifications) =>
      _certifications = certifications;

  // --------------------------------------------------------------------------------------

  String get whatsappnumber => _whatsappnumber;
  String get jobindustry => _jobindustry;
  String get jobachievement => _jobachievement;
  String get projectname => _projectname;
  String get projectrole => _projectrole;
  String get projectduration1 => _projectduration1;
  String get projectduration2 => _projectduration2;
  String get projectdescription => _projectdescription;
  String get projectachievement => _projectachievement;
  String get projectlink => _projectlink;
  String get socialmedia => _socialmedia;
  String get certifications => _certifications;
}
