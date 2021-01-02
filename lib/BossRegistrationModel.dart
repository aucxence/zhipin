import 'package:scoped_model/scoped_model.dart';

class BossRegistrationModel extends Model {
  String _pic, _nom, _entreprise, _abbrev, _fonction, _mail, _expertise, _staff;

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
}
