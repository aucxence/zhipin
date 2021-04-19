import 'package:json_annotation/json_annotation.dart';
import 'package:scoped_model/scoped_model.dart';
// part 'boss.g.dart';

@JsonSerializable()
class Boss extends Model {
  String _pic, _nom, _entreprise, _abbrev, _fonction, _mail, _expertise, _staff;
  // bool _type, _completedSubscription = false;

  Boss();

  void updatePic(String pic) {
    _pic = pic;
    notifyListeners();
  }

  void updateNom(String nom) {
    _nom = nom;
    notifyListeners();
  }

  void updateEntreprise(String entreprise) {
    _entreprise = entreprise;
    notifyListeners();
  }

  void updateFonction(String fonction) {
    _fonction = fonction;
    notifyListeners();
  }

  void updateMail(String mail) {
    _mail = mail;
    notifyListeners();
  }

  void updateAbbrev(String abbrev) {
    _abbrev = abbrev;
    notifyListeners();
  }

  void updateExpertise(String expertise) {
    _expertise = expertise;
    notifyListeners();
  }

  void updateStaff(String staff) {
    _staff = staff;
    notifyListeners();
  }

  // --------------------------------------------------------------------------------------

  String get pic => _pic;
  String get nom => _nom;
  String get entreprise => _entreprise;
  String get abbrev => _abbrev;
  String get fonction => _fonction;
  String get mail => _mail;
  String get expertise => _expertise;
  String get staff => _staff;

  Boss.fromJson(Map<String, dynamic> json)
      : _pic = json['pic'].toString(),
        _nom = json['nom'].toString(),
        _abbrev = json['abbrev'].toString(),
        _entreprise = json['entreprise'].toString(),
        _expertise = json['expertise'].toString(),
        _staff = json['staff'],
        _fonction = json['fonction'].toString(),
        _mail = json['mail'].toString()
  // _type = json['type'],
  // _completedSubscription = json['completedSubscription']
  ;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pic': _pic,
        'nom': _nom,
        'abbrev': _abbrev,
        'entreprise': _entreprise,
        'expertise': _expertise,
        'staff': _staff,
        'staffmin': int.parse(_staff.split('-')[0]),
        'staffmax': int.parse(_staff.split('-')[1]),
        'fonction': _fonction,
        'mail': _mail,
        // 'type': _type,
        // 'completedSubscription': _completedSubscription
      };
}
