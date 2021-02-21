import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/ability_finder.dart';
import 'package:my_zhipin_boss/registration/category_finder.dart';
import 'package:my_zhipin_boss/registration/item_completer.dart';
import 'package:my_zhipin_boss/registration/major_finder.dart';
import 'package:my_zhipin_boss/registration/my_advantage.dart';
import 'package:my_zhipin_boss/registration/school_finder.dart';
import 'package:my_zhipin_boss/registration/step_one.dart';
import 'package:my_zhipin_boss/registration/work_descriptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_zhipin_boss/registration/step_four.dart';

class StepThree extends StatefulWidget {
  @override
  _StepThreeState createState() => _StepThreeState();
}

class _StepThreeState extends State<StepThree>
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
    false // description du job
  ];

  static const LB = [
    "Dans quelle école avez-vous fréquenté?",
    "Renseigner votre niveau académique",
    "Renseigner votre domaine de compétence",
    "Période de temps"
  ];

  var labels = <String>[
    "Dans quelle école avez-vous fréquenté?",
    "Renseigner votre niveau académique",
    "Renseigner votre domaine de compétence",
    "Période de temps"
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
                onTap: () {
                  _validersuivant();
                },
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
            children: stackmanager(),
          ),
        ));
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(50));
  }

  List<Widget> stackmanager() {
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
            children: getWidgetColumn(),
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
        onTap: () {
          _validersuivant();
        },
      ),
    );

    wholeset.add(button);

    return wholeset;
  }

  _validersuivant() {
    User model = ScopedModel.of<User>(context);
    if (suivant) {
      model.updateSchool(labels[0]);
      model.updateDegree(labels[1]);
      model.updateMajor(labels[2]);
      model.updateTimeFrame(labels[3]);
      // Toast.show("bonne validation");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AdvantageDescriptor()));
    } else {
      for (int i = 0; i < 7; i++) {
        if (i == 5) continue;
        if (!validations[i]) {
          print(i.toString() + ": " + validations.toString());
          // Toast.show(valid[i]["response"]);
          break;
        }
      }
    }
  }

  List<Widget> getWidgetColumn() {
    var widgets = <Widget>[];

    widgets.add(Container(
        alignment: Alignment.center,
        child: Text("Expérience académique",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(50), color: Colors.black))));

    widgets.add(Container(
        alignment: Alignment.centerLeft,
        child: Text(
            "Un remplissage détaillé peut ajouter des points à votre CV",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black45))));

    widgets.add(spacing());

    widgets.addAll([
      _complicatedTextField("Nom de l'école", labels[0], validations[0],
          () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return SchoolFinder(
                    title: "Nom de l'école",
                    hint: "Svp entrez le nom de l'école",
                    collection: "schoollist",
                    ordering: "schoolfullname",
                  );
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
        print("---------------------------------" + result.toString());
        if (result != null) {
          setState(() {
            labels[0] = result;
            validations[0] = true;
            suivant = eq(validations, [true, true, true, true]);
          });
          print(validations);
        }
      }),
      _pagedivider(),
      _datepicker("Niveau Académique", labels[1], validations[1], () async {
        _showDatePicker(1, DateTimePickerMode.degree, {
          "CEPE": ["Cours ordinaire", "Cours du soir"],
          "BEPC": ["Cours ordinaire", "Cours du soir"],
          "Probatoire": [
            "Sans mention",
            "Mention Passable",
            "Mention Assez bien",
            "Mention Bien",
            "Mention Très Bien",
            "Mention Excellente"
          ],
          "BAC": [
            "Sans mention",
            "Mention Passable",
            "Mention Assez bien",
            "Mention Bien",
            "Mention Très Bien",
            "Mention Excellente"
          ],
          "License": [
            "Sans mention",
            "Mention Passable",
            "Mention Assez bien",
            "Mention Bien",
            "Mention Très Bien",
            "Mention Excellente"
          ],
          "Master 1": [
            "Sans mention",
            "Mention Passable",
            "Mention Assez bien",
            "Mention Bien",
            "Mention Très Bien",
            "Mention Excellente"
          ],
          "Master 2": [
            "Sans mention",
            "Mention Passable",
            "Mention Assez bien",
            "Mention Bien",
            "Mention Très Bien",
            "Mention Excellente"
          ],
          "Doctorat": [
            "Sans mention",
            "Mention Passable",
            "Mention Assez bien",
            "Mention Bien",
            "Mention Très Bien",
            "Mention Excellente"
          ]
        });
      }),
      _pagedivider(),
      (hiddenzones[0])
          ? _complicatedTextField("Spécialité/Major", labels[2], validations[2],
              () async {
              final result = await Navigator.push(
                  context,
                  PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return MajorFinder(
                          title: "Votre spécialité",
                          hint: "Svp entrez votre spécialité",
                          collection: "majorlist",
                          ordering: "majorfullname",
                        );
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
              print("---------------------------------");
              if (result != null) {
                setState(() {
                  labels[2] = result;
                  validations[2] = true;
                  suivant = eq(validations, [true, true, true, true]);
                });
                print(validations);
              }
            })
          : Container(),
      (hiddenzones[0]) ? _pagedivider() : Container(),
      _datepicker("Période", labels[3], validations[3], () async {
        _showDatePicker(3, DateTimePickerMode.range, null);
      }),
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
            suivant = eq(validations, [true, true, true, true]);
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
            suivant = eq(validations, [true, true, true, true]);
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
