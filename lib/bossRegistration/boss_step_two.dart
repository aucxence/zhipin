import 'package:my_zhipin_boss/JobRegistrationModel.dart';
import 'package:my_zhipin_boss/components/datepicker.dart';
import 'package:my_zhipin_boss/components/push_manoeuver.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/models/job.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/utilities/ability_finder.dart';
import 'package:my_zhipin_boss/registration/overview/bilan_resume.dart';
import 'package:my_zhipin_boss/registration/utilities/category_finder.dart';
import 'package:my_zhipin_boss/registration/confirmation/long_field_writer_2.dart';
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
import 'package:my_zhipin_boss/components/page_divider.dart';
import 'package:my_zhipin_boss/components/complicated_textfield.dart';

class BossStepTwo extends StatefulWidget {
  @override
  _BossStepTwoState createState() => _BossStepTwoState();
}

class _BossStepTwoState extends State<BossStepTwo>
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
    false,
    false,
    false,
    false
  ];

  static const LB = [
    "Quel poste rendez-vous disponible?",
    "Quelle expérience est requise?",
    "Quelle est le niveau d'étude requis?",
    "Quelle est la marge salariale?",
    "Décrivez le processus de bonus"
  ];

  var labels = <String>[
    "Quel poste rendez-vous disponible?",
    "Quelle expérience est requise?",
    "Quelle est le niveau d'étude requis?",
    "Quelle est la marge salariale?",
    "Décrivez le processus de bonus",
    "Quel est le job description?",
    "Quels sont les mots-clés?",
    "Quelle est la location?"
  ];

  var valid = [
    {"id": 0, "response": "Choisissez le titre du poste disponible"},
    {"id": 1, "response": "Décidez de l'expérience requise"},
    {"id": 2, "response": "Renseignez le niveau minimal d'étude"},
    {"id": 3, "response": "Renseignez la marge salariale"},
    // {"id": 4, "response": "Renseignez le système de commission"},
    {"id": 5, "response": "Décrivez le travail que vous offrez"},
    {"id": 6, "response": "Donnez des mots clés"},
    {"id": 7, "response": "Renseignez le lieu du poste offert"}
  ];

  static AnimationController control;
  static Animation<Offset> offset;

  Job model = new Job();

  ScrollController _scrollcontroller = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Function eq = const ListEquality().equals;

  var chosenfield;

  var isSwitched = true;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
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

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black45,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            GestureDetector(
                onTap: () => null,
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    child: Center(
                        child: Text("Suivant",
                            style: TextStyle(
                              color:
                                  suivant ? Colours.app_main : Colors.black45,
                              fontSize: ScreenUtil().setSp(30),
                            )))))
          ],
        ),
        body: Form(
          key: _formKey,
          child: Stack(
            children: stackmanager(context, model),
          ),
        ));
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(50));
  }

  List<Widget> stackmanager(BuildContext context, Job model) {
    List<Widget> wholeset = [];

    var login = Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(40),
          right: ScreenUtil().setWidth(40),
          top: ScreenUtil().setHeight(0),
          bottom: ScreenUtil().setHeight(130)),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
          controller: _scrollcontroller,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getWidgetColumn(model),
          )),
    );

    wholeset.add(login);

    var expansion = SizedBox.expand();

    wholeset.add(expansion);

    var button = Positioned(
      bottom: ScreenUtil().setHeight(20),
      right: ScreenUtil().setWidth(20),
      left: ScreenUtil().setWidth(20),
      child: GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(05.0),
                color: suivant ? Colours.app_main : Colors.black45),
            child: Center(
                child: Text("Suivant",
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)))),
            //color: Colours.app_main
          ),
          onTap: () => _validersuivant(context, model)),
    );

    wholeset.add(button);

    return wholeset;
  }

  _validersuivant(BuildContext context, Job model) {
    if (suivant) {
      // model.updateExpectedStatus(labels[0]);
      // model.updateExpectedJob(labels[1]);
      // model.updateExpectedCareer(labels[2]);
      // model.updateExpectedTown(labels[3]);
      // model.updateExpectedMoney(labels[4]);
      // Toast.show("bonne validation");
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ScopedModel<RegistrationModel>(
      //             model: model, child: OverallResume())));
    } else {
      for (int i = 0; i <= 7; i++) {
        if (i == 5) continue;
        if (!validations[i]) {
          print(i.toString() + ": " + validations.toString());
          Toast.show(valid[i]["response"]);
          break;
        }
      }
    }
  }

  List<Widget> getWidgetColumn(Job model) {
    var widgets = <Widget>[];

    widgets.add(Container(
        alignment: Alignment.center,
        child: Text("Offre d'emploi",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(50), color: Colors.black))));

    widgets.add(Container(
        alignment: Alignment.centerLeft,
        child: Text(
            "Ces informations serviront à la recommendation des candidats ayant les compétences requises",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black45))));

    widgets.add(spacing());

    widgets.addAll([
      complicatedTextField(
          "Titre du poste disponible", labels[0], validations[0], () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(CategoryFinder(
                context: context,
                index: "field",
                title: "Catégorie",
                hint: "Svp entrez la catégorie de l'entreprise",
                collection: "fieldareas")));
        print(validations);
        if (result != null) {
          var parts = result.split("-");
          setState(() {
            labels[0] = parts[1];
            validations[0] = true;
            suivant = eq(
                validations, [true, true, true, true, false, true, true, true]);
          });
          chosenfield = parts[0];
          print(validations);
        }
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Expérience requise", labels[1], validations[1],
          () async {
        _showDatePicker(1, DateTimePickerMode.column, {
          "values": [
            "sans importance",
            "Moins d'1 an",
            "Entre 1 et 3 ans",
            "Entre 3 et 5 ans",
            "Entre 5 et 10 ans",
            "Plus de 10 ans"
          ]
        });
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Niveau minimal d'étude", labels[2], validations[2],
          () async {
        _showDatePicker(2, DateTimePickerMode.column, {
          "values": [
            "CEPE",
            "BEPC",
            "Probatoire",
            "BAC",
            "License",
            "Master 1",
            "Master 2",
            "Doctorat"
          ]
        });
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Marge salariale", labels[3], validations[3],
          () async {
        _showDatePicker(3, DateTimePickerMode.degree, {
          "Débatable": ["Débatable"],
          "10K": [
            "15K",
            "20K",
            "25K",
            "30K",
            "35K",
            "40K",
            "45K",
            "50K",
            "60K"
          ],
          "25K": ["35K", "45K", "55K", "65K", "75K"],
          "50K": ["60K", "70K", "80K", "90K", "100K"],
          "75K": ["85K", "95K", "105K", "115K", "125K"],
          "100K": [
            "150K",
            "200K",
            "250K",
            "300K",
            "350K",
            "400K",
            "450K",
            "500K",
            "550K",
            "650K",
            "700K",
            "750K"
          ],
          "250K": [
            "300K",
            "350K",
            "400K",
            "450K",
            "500K",
            "550K",
            "650K",
            "700K",
            "750K",
            "800K",
            "850K",
          ],
          "500K": [
            "300K",
            "350K",
            "400K",
            "450K",
            "500K",
            "550K",
            "650K",
            "700K",
            "750K",
            "800K",
            "850K",
            "900K",
            "950K",
            "1M"
          ],
          "750K": ["800K", "850K", "900K", "950K", "1M", "1,5M"],
          "1M": ["2M", "3M", "4M", "5M", "6M", "7M", "8M", "9M", "10M"]
        });
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField(
          "Système de commission (s'il y en a)", labels[4], validations[4],
          () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(LongFieldWriter(
                advantage: ' ',
                hinttext: '''
1. Diplomé en ingénieurie informatique (BAC + 5) avec mention
2. 10 ans d'expérience dans le dévelopement mobile
3. Pilote des projets innovants tels que ...
4. Certifié dans les technologies ...
5. ...
                      ''',
                topic: "Bonus de performance",
                collection: "advantagetemplate")));

        print(validations);

        // validations[4] = (result != null);
        if (result != null) {
          setState(() {
            // model.updateAdvantage(result);
            labels[4] = result;
            suivant = eq(
                validations, [true, true, true, true, false, true, true, true]);
          });
          // print("********************** " + model.abbrev);
          print(validations);
        }
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Description du travail", labels[5], validations[5],
          () async {
        final result =
            await Navigator.push(context, pushManoeuver(WorkDescriptor()));
        if (result != null) {
          setState(() {
            labels[5] = result;
            validations[5] = (result != null);
            suivant = eq(
                validations, [true, true, true, true, false, true, true, true]);
          });
          print(validations);
        }
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Mots-clés", labels[6], validations[6], () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(AbilityFinder(
                collection: "fieldareas", index: "field", field: chosenfield)));
        print(validations);
        setState(() {
          labels[6] = (result != null) ? result : 'Mots-clés';
          validations[6] = (result != null);
          suivant = eq(
              validations, [true, true, true, true, false, true, true, true]);
        });
        // chosenfield = parts[0];
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Location", labels[7], validations[7], () async {
        _showDatePicker(7, DateTimePickerMode.degree, {
          "laborum": [
            "Baden",
            "Ironton",
            "Succasunna",
            "Marion",
            "Leola",
            "Geyserville",
            "Robinson",
            "Dola",
            "Datil"
          ],
          "nostrud": [
            "Sabillasville",
            "Woodlands",
            "Gardiner",
            "Campo",
            "Barronett",
            "Esmont",
            "Spelter"
          ],
          "fugiat": [
            "Kersey",
            "Northridge",
            "Jenkinsville",
            "Cliff",
            "Beason",
            "Greenbackville",
            "Broadlands"
          ],
          "laboris": [
            "Orin",
            "Derwood",
            "Veguita",
            "Ellerslie",
            "Ola",
            "Malott",
            "Harmon"
          ],
          "pariatur": ["Roland", "Alafaya", "Harleigh", "Lacomb", "Savage"],
          "officia": [
            "Turah",
            "Gilmore",
            "Morriston",
            "Cotopaxi",
            "Homestead",
            "Hoagland",
            "Urie"
          ],
          "nisi": [
            "Logan",
            "Grill",
            "Colton",
            "Brogan",
            "Sunnyside",
            "Berwind",
            "Kohatk",
            "Mathews"
          ],
          "cupidatat": [
            "Tuskahoma",
            "Goochland",
            "Wauhillau",
            "Faywood",
            "Jennings"
          ]
        });
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
          var stuff = a;

          if (mode == DateTimePickerMode.degree) {
            stuff = a + ' - ' + b;
          }

          setState(() {
            labels[labelnumber] = stuff;
            validations[labelnumber] = true;
            suivant = eq(
                validations, [true, true, true, true, false, true, true, true]);
            // if (mode == DateTimePickerMode.degree) {
            //   hiddenzones[0] = !(labels[1].contains("CEPE") ||
            //       labels[1].contains("BEPC") ||
            //       labels[1].contains("Probatoire") ||
            //       labels[1].contains("BAC"));
            //   if (!hiddenzones[0]) {
            //     labels[2] = LB[2];
            //     validations[2] = false;
            //   }
            // }
          });

          print(validations);
        });
  }
}
