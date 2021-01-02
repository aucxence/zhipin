import 'package:my_zhipin_boss/RegistrationModel.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/ability_finder.dart';
import 'package:my_zhipin_boss/registration/bilan_resume.dart';
import 'package:my_zhipin_boss/registration/category_finder.dart';
import 'package:my_zhipin_boss/registration/desired_areas.dart';
import 'package:my_zhipin_boss/registration/item_completer.dart';
import 'package:my_zhipin_boss/registration/major_finder.dart';
import 'package:my_zhipin_boss/registration/school_finder.dart';
import 'package:my_zhipin_boss/registration/work_descriptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

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

  var valid = [
    {"id": 0, "response": "Choisissez votre avatar"},
    {"id": 1, "response": "Choisissez votre genre"},
    {"id": 2, "response": "Renseignez votre nom"},
    {"id": 3, "response": "Renseignez votre prenom"},
    {"id": 4, "response": "Renseignez votre année et mois de naissance"},
    {"id": 6, "response": "Renseignez votre expérience professionelle"},
  ];

  static AnimationController control;
  static Animation<Offset> offset;

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

  void scrollafterbuild(Duration d) {
    _scrollcontroller.animateTo(
      _scrollcontroller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
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
    //WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);
    return ScopedModelDescendant<RegistrationModel>(
        builder: (context, child, model) {
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
                  onTap: () => _validersuivant(context, model),
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
    });
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(50));
  }

  List<Widget> stackmanager(BuildContext context, RegistrationModel model) {
    List<Widget> wholeset = [];

    var login = Container(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(40),
          right: ScreenUtil().setWidth(40),
          top: ScreenUtil().setHeight(20),
          bottom: ScreenUtil().setHeight(130)),
      margin: EdgeInsets.symmetric(vertical: 0),
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

  _validersuivant(BuildContext context, RegistrationModel model) {
    if (suivant) {
      model.updateExpectedStatus(labels[0]);
      model.updateExpectedJob(labels[1]);
      model.updateExpectedCareer(labels[2]);
      model.updateExpectedTown(labels[3]);
      model.updateExpectedMoney(labels[4]);
      // Toast.show("bonne validation");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScopedModel<RegistrationModel>(
                  model: model, child: OverallResume())));
    } else {
      for (int i = 0; i < 4; i++) {
        if (i == 5) continue;
        if (!validations[i]) {
          print(i.toString() + ": " + validations.toString());
          // Toast.show(valid[i]["response"]);
          break;
        }
      }
    }
  }

  List<Widget> getWidgetColumn(RegistrationModel model) {
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
      _datepicker("Situation Professionelle", labels[0], validations[0],
          () async {
        _showDatePicker(0, DateTimePickerMode.column, {
          "values": [
            "Disponible - Peut commencer n'importe quand",
            "Occupé - Peut se libérer en moins d'un mois",
            "Occupé - Quand même ouvert à des opportunités exceptionelles",
            "Occupé - Pas en recherche d'emploi"
          ]
        });
      }),
      _pagedivider(),
      _complicatedTextField(
          "Catégorie d'emploi désirée", labels[1], validations[1], () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return CategoryFinder(
                      context: context,
                      title: "Catégorie",
                      hint: "Svp entrez la catégorie de l'entreprise",
                      collection: "fieldareas");
                },
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(1.0, 0.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );
                }));
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
      _pagedivider(),
      _complicatedTextField("Choix de carrière", labels[2], validations[2],
          () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return DesiredAreas(collection: "careers", selectable: 3);
                },
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return SlideTransition(
                    position: new Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: new SlideTransition(
                      position: new Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(1.0, 0.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );
                }));
        if (result != null) {
          setState(() {
            labels[2] = result;
            validations[2] = true;
            suivant = eq(validations, [true, true, true, true, true]);
          });
          // chosenfield = parts[0];
        }
      }),
      _pagedivider(),
      _datepicker("Ville du travail", labels[3], validations[3], () async {
        _showDatePicker(3, DateTimePickerMode.degree, {
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
      _pagedivider(),
      _datepicker("Marge salariale", labels[4], validations[4], () async {
        _showDatePicker(4, DateTimePickerMode.degree, {
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
      _pagedivider(),
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

  Widget _complicatedTextField(
      String label, String hint, bool changecolor, VoidCallback callback) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(25), color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    hint,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: changecolor ? Colours.app_main : Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  )),
                  GestureDetector(
                    onTap: callback,
                    child: Transform.scale(
                        scale: 0.5,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color:
                              changecolor ? Colors.black45 : Colours.app_main,
                        )),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget _pagedivider() {
    return new Divider(
      color: Colors.black45,
      height: ScreenUtil().setHeight(70),
    );
  }

  var naturalspacing = 10.0;

  Widget _datepicker(
      String label, String hint, bool changecolor, VoidCallback callback) {
    return GestureDetector(
        onTap: callback,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(naturalspacing)),
          //color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(25),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(hint,
                      style: TextStyle(
                        color: changecolor ? Colours.app_main : Colors.black54,
                        fontSize: ScreenUtil().setSp(30),
                      ),
                      overflow: TextOverflow.ellipsis),
                  GestureDetector(
                    onTap: callback,
                    child: Transform.scale(
                        scale: 0.5,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color:
                              changecolor ? Colors.black45 : Colours.app_main,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

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
          var stuff = a + " - " + b;
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
