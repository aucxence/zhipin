import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_zhipin_boss/components/complicated_textfield.dart';
import 'package:my_zhipin_boss/components/frame.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';
import 'package:my_zhipin_boss/components/push_manoeuver.dart';
import 'package:my_zhipin_boss/components/scrollcomponent.dart';
import 'package:my_zhipin_boss/components/toaster.dart';
import 'package:my_zhipin_boss/components/valid_button.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/utilities/ability_finder.dart';
import 'package:my_zhipin_boss/registration/overview/bilan_resume.dart';
import 'package:my_zhipin_boss/registration/utilities/category_finder.dart';
import 'package:my_zhipin_boss/registration/utilities/desired_areas.dart';
import 'package:my_zhipin_boss/registration/utilities/item_completer.dart';
import 'package:my_zhipin_boss/registration/utilities/major_finder.dart';
import 'package:my_zhipin_boss/registration/utilities/item_finder.dart';
import 'package:my_zhipin_boss/registration/utilities/work_descriptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

import 'constants.dart';

class StepFour extends StatefulWidget {
  @override
  _StepFourState createState() => _StepFourState();
}

class _StepFourState extends State<StepFour>
    with SingleTickerProviderStateMixin {
  bool genre, suivant = false;

  DateTimePickerLocale _locale = DateTimePickerLocale.fr;

  String MIN_DATETIME = '1990-01-01';
  String MAX_DATETIME = '2021-12-01';
  String INIT_DATETIME = '2018-01-01';

  DateTimePickerTheme theme;

  var hiddenzones = <bool>[false];

  var validations = <bool>[
    false, // company name
    false, // début période
    false, // fin période
    false, // description du job
    false
  ];

  static const LB = [
    "Quelle est votre situation?",
    "Quelle catégorie d'emploi désirez-vous?",
    "Renseigner vos choix de carrière",
    "Ville désirée",
    "Marge salariale"
  ];

  var labels = <String>[
    "Quelle est votre situation?",
    "Quelle catégorie d'emploi désirez-vous?",
    "Renseigner vos choix de carrière",
    "Ville désirée",
    "Marge salariale"
  ];

  static AnimationController control;
  static Animation<Offset> offset;

  ScrollController _scrollcontroller = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Function eq = const ListEquality().equals;

  var chosenfield;

  var isSwitched = true;

  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    control =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // var statuslistener = (status) {
    //   if(status == AnimationStatus.dismissed) {
    //     setState(() {
    //       _companyname = false;
    //     });
    //   }
    // };
    // control.addStatusListener(statuslistener);
    offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
        .animate(control);
  }

  @override
  dispose() {
    control.dispose();
    super.dispose();
  }

  AppState appstate;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    appstate = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    appstate.updateLoading(false);

    theme = DateTimePickerTheme(
      backgroundColor: Colors.white,
      cancelTextStyle: TextStyle(color: Colours.app_main),
      confirmTextStyle: TextStyle(color: Colours.app_main),
      itemTextStyle:
          TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30)),
      confirm: Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
          child: Icon(
            Icons.done,
            color: Colours.app_main,
          )),
      cancel: Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
          child: Icon(Icons.close, color: Colours.app_main)),
      pickerHeight: ScreenUtil().setHeight(500),
      titleHeight: ScreenUtil().setHeight(90),
      itemHeight: ScreenUtil().setHeight(70),
    );
    //WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);

    return frameComponent(context, _validersuivant, stackmanager(), suivant);
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(50));
  }

  List<Widget> stackmanager() {
    List<Widget> wholeset = [];

    var login = scrollingComponent(getWidgetColumn(), _scrollcontroller);

    wholeset.add(login);

    var expansion = SizedBox.expand();

    wholeset.add(expansion);

    var button = validationButton(suivant, _validersuivant);

    wholeset.add(button);

    return wholeset;
  }

  var valid = {
    0: "Choisissez votre status",
    1: "Remplissez le 2è champ",
    2: "Renseignez votre carrière",
    3: "Renseignez votre ville",
    4: "Renseignez votre attente salariale",
  };

  _validersuivant() {
    User model = appstate.user;
    appstate.updateLoading(true);
    if (suivant) {
      model.updateExpectedStatus(labels[0]);
      model.updateExpectedJob(labels[1]);
      model.updateExpectedCareer(labels[2]);
      model.updateExpectedTown(labels[3]);
      model.updateExpectedMoney(labels[4]);
      model.updateExpectedWorkSector(chosenfield);
      // Toast.show("bonne validation");

      appstate.updateUser(model);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OverallResume()));
    } else {
      appstate.updateLoading(false);
      for (int i = 0; i < 5; i++) {
        if (!validations[i]) {
          print(i.toString() + ": " + validations.toString());
          appstate.updateLoading(false);
          var errorMessage = valid[i];
          showToast(fToast, Icons.no_encryption, errorMessage, 10);
          break;
        }
      }
    }
  }

  List<Widget> getWidgetColumn() {
    var widgets = <Widget>[];

    widgets.add(Container(
        alignment: Alignment.center,
        child: Text("Intention professionelle",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(50), color: Colors.black))));

    widgets.add(Container(
        alignment: Alignment.centerLeft,
        child: Text(
            "Cette information permettra de vous proposer des positions semblables",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black45))));

    widgets.add(spacing());

    widgets.addAll([
      complicatedTextField(
          "Situation Professionelle", labels[0], validations[0], () async {
        _showDatePicker(0, DateTimePickerMode.column, {
          "values": [
            "Disponible - Peut commencer n'importe quand",
            "Occupé - Peut se libérer en moins d'un mois",
            "Occupé - Quand même ouvert à des opportunités exceptionelles",
            "Occupé - Pas en recherche d'emploi"
          ]
        });
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField(
          "Secteur d'activité désiré", labels[1], validations[1], () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(CategoryFinder(
                context: context,
                index: "field",
                title: "Catégorie",
                hint: "Svp entrez la catégorie de l'entreprise",
                collection: "fieldareas")));
        if (result != null) {
          var parts = result.split("-");
          setState(() {
            labels[1] = parts[1];
            validations[1] = true;
            suivant = eq(validations, [true, true, true, true, true]);
          });
          chosenfield = parts[0];
        }
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Choix de carrière", labels[2], validations[2],
          () async {
        final result = await Navigator.push(context,
            pushManoeuver(DesiredAreas(collection: "careers", selectable: 3)));
        if (result != null) {
          setState(() {
            labels[2] = result;
            validations[2] = true;
            suivant = eq(validations, [true, true, true, true, true]);
          });
          // chosenfield = parts[0];
        }
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Ville du travail", labels[3], validations[3],
          () async {
        _showDatePicker(3, DateTimePickerMode.degree, Constants.villes);
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Marge salariale", labels[4], validations[4],
          () async {
        _showDatePicker(4, DateTimePickerMode.degree, Constants.margesalariale);
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      ListTile(
        title: Text(
          "Autoriser l'algorithme à voir mon profil",
          textAlign: TextAlign.left,
          style:
              TextStyle(fontSize: ScreenUtil().setSp(25), color: Colors.black),
          overflow: TextOverflow.fade,
        ),
        subtitle: Text(
          "Le robot va intelligemment vous suggérer des positions ouvertes",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(30), color: Colors.black54),
          overflow: TextOverflow.fade,
        ),
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
            //inactiveTrackColor: Colors.gr,
          ),
        ),
      )
    ]);

    return widgets;
  }

  var naturalspacing = 10.0;

  /// Display date picker.
  void _showDatePicker(int labelnumber, DateTimePickerMode mode,
      Map<String, List<String>> data) {
    DatePicker.showDatePicker(context,
        pickerMode: mode,
        pickerTheme: theme,
        minDateTime: DateTime.parse(MIN_DATETIME),
        maxDateTime: DateTime.now(),
        initialDateTime: DateTime.parse(INIT_DATETIME),
        dateFormat: "yyyy-MMMM",
        data: data,
        locale: _locale,
        onClose: () => print("----- onClose -----"),
        onCancel: () => print('onCancel'),
        onChange: null,
        onConfirm: (dateTime, List<int> index) {
          var today = index[0] + DateTime.parse(MIN_DATETIME).year;
          print(today);
          setState(() {
            labels[labelnumber] = (today > DateTime.now().year &&
                    mode == DateTimePickerMode.dateonly)
                ? "De nos jours"
                : new DateFormat("yyyy-MM").format(dateTime);
            validations[labelnumber] = true;
            suivant = eq(validations, [true, true, true, true, true]);
          });
          //print("suivant: " + suivant.toString());
          // print("validations: " + validations.toString());
        },
        onCnfrm: (String a, String b) {
          var stuff = mode == DateTimePickerMode.column ? a : a + " - " + b;
          print(stuff);
          setState(() {
            labels[labelnumber] = stuff;
            validations[labelnumber] = true;
            suivant = eq(validations, [true, true, true, true, true]);
            if (mode == DateTimePickerMode.degree) {
              hiddenzones[0] = !(labels[1].contains("CEPE") ||
                  labels[1].contains("BEPC") ||
                  labels[1].contains("Probatoire") ||
                  labels[1].contains("BAC"));
              if (!hiddenzones[0]) {
                labels[2] = LB[2];
                validations[2] = false;
              }
            }
          });
        });
  }
}
