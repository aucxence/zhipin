part of 'date_picker_i18n.dart';

/// Français (Fr) United States
class _StringsFr extends _StringsI18n {
  const _StringsFr();

  @override
  String getCancelText() {
    return 'Annuler';
  }

  @override
  String getDoneText() {
    return 'Valider';
  }

  @override
  List<String> getMonths() {
    return [
      "Janvier",
      "Février",
      "Mars",
      "Avril",
      "May",
      "Juin",
      "Juillet",
      "Aout",
      "Septembre",
      "Octobre",
      "Novembre",
      "Decembre"
    ];
  }

  @override
  List<String> getWeeksFull() {
    return [
      "Lundi",
      "Mardi",
      "Mercredi",
      "Jeudi",
      "Vendredi",
      "Samedi",
      "Dimanche",
    ];
  }

  @override
  List<String> getWeeksShort() {
    return [
      "Lun",
      "Mar",
      "Mer",
      "Jeu",
      "Ven",
      "Sam",
      "Dim",
    ];
  }
}
