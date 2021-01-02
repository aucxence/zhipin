import 'package:my_zhipin_boss/BossRegistrationModel.dart';
import 'package:my_zhipin_boss/RegistrationModel.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/bossRegistration/company_completer.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/category_finder.dart';
import 'package:my_zhipin_boss/registration/confirmation/field_writer.dart';
import 'package:my_zhipin_boss/registration/desired_areas.dart';
import 'package:my_zhipin_boss/registration/item_completer.dart';
import 'package:my_zhipin_boss/registration/step_three.dart';
import 'package:my_zhipin_boss/registration/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class CompanyDetails extends StatefulWidget {
  final String companyname;

  CompanyDetails({Key key, this.companyname}) : super(key: key);

  @override
  _CompanyDetailsState createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails>
    with SingleTickerProviderStateMixin {
  bool suivant = false;

  var validations = <bool>[
    false, // profil
    false, // nom
    false, // entreprise
    false // adresse mail
  ];

  var labels = <String>[
    "",
    "Abbréviation de l'entreprise",
    "Catégorie",
    "Staff"
  ];

  var valid = [
    {"id": 0, "response": "Choisissez votre avatar"},
    {"id": 1, "response": "Choisissez votre genre"},
    {"id": 2, "response": "Renseignez votre nom"},
    {"id": 3, "response": "Renseignez votre prenom"},
    {"id": 4, "response": "Renseignez votre année et mois de naissance"},
    {"id": 6, "response": "Renseignez votre expérience professionelle"},
  ];

  DateTimePickerLocale _locale = DateTimePickerLocale.fr;

  String MIN_DATETIME = '1990-01-01';
  String MAX_DATETIME = '2021-12-01';
  String INIT_DATETIME = '2018-01-01';

  DateTimePickerTheme theme;

  ScrollController _scrollcontroller = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Function eq = const ListEquality().equals;

  var controllertab = <TextEditingController>[
    new TextEditingController(),
    new TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    // control.dispose();
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

    labels[0] = widget.companyname;
    validations[0] = true;

    WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);
    return ScopedModelDescendant<BossRegistrationModel>(
        builder: (context, child, model) {
      // controllertab[0] = new TextEditingController(text: model.nom);
      // controllertab[1] = new TextEditingController(text: model.prenom);
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

  List<Widget> stackmanager(BuildContext context, BossRegistrationModel model) {
    List<Widget> wholeset = [];

    var login = Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(40),
            top: ScreenUtil().setHeight(20),
            bottom: ScreenUtil().setHeight(130)),
        margin: EdgeInsets.symmetric(vertical: 0),
        height: ScreenUtil().setHeight(1334),
        // color: Colors.blue,
        child: SingleChildScrollView(
            controller: _scrollcontroller,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: getWidgetColumn(model),
            )));

    wholeset.add(login);

    var button = Positioned(
      bottom: ScreenUtil().setHeight(10),
      right: ScreenUtil().setWidth(15),
      left: ScreenUtil().setWidth(15),
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

  _validersuivant(BuildContext context, BossRegistrationModel model) {
    if (suivant) {
      model.updateEntreprise(labels[0]);
      model.updateAbbrev(labels[1]);
      model.updateExpertise(labels[2]);
      model.updateStaff(labels[3]);

      var count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });

      // Navigator.pop(context, labels.join('`'));
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

  List<Widget> getWidgetColumn(BossRegistrationModel model) {
    var widgets = <Widget>[];

    widgets.add(Align(
        alignment: Alignment.center,
        child: Text("Informations essentielles",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(50), color: Colors.black))));

    widgets.add(Align(
        alignment: Alignment.center,
        child: Text("les prospects auront accès à ces informations",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black45))));

    widgets.add(spacing());

    widgets.addAll([
      // _basictextfield("Fonction", "Quelle est votre fonction", 0, 1),

      _complicatedTextField(
          "Nom Complet de l'entreprise", labels[0], validations[0], () async {
        Navigator.pop(context);
      }),
      _pagedivider(),
      _complicatedTextField(
          "Abbréviation de l'entreprise", labels[1], validations[1], () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return FieldWriter(
                      title: "Quelle est l'abbréviation?",
                      hint: "CTL",
                      inputformatter: true);
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
        setState(() {
          labels[1] = result;
          validations[1] = true;
          suivant = eq(validations, [true, true, true, true]);
        });
        print(validations);
      }),
      _pagedivider(),
      _complicatedTextField("Catégorie", labels[2], validations[2], () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return DesiredAreas(collection: "careers", selectable: 1);
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
            suivant = eq(validations, [true, true, true, true]);
          });
          // chosenfield = parts[0];
        }
      }),
      _pagedivider(),
      _complicatedTextField("Nombre d'employés", labels[3], validations[3],
          () async {
        _showDatePicker(3, DateTimePickerMode.column, {
          "values": [
            "0 - 19 personnes",
            "20 - 99 personnes",
            "100 - 499 personnes",
            "500 - 999 personnes",
            "1000 - 9999 personnes"
          ]
        });
      }),
      _pagedivider()
    ]);

    return widgets;
  }

  Widget _pagedivider() {
    return new Divider(
      color: Colors.black45,
    );
  }

  var naturalspacing = 10.0;

  Widget _datepicker(
      String label, String hint, VoidCallback callback, bool changecolor) {
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
              Text(
                label,
                style: TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: ScreenUtil().setWidth(500),
                      child: Text(
                        hint,
                        style: TextStyle(
                            color: changecolor
                                ? Colours.app_main
                                : Colors.black54),
                        overflow: TextOverflow.ellipsis,
                      )),
                  Transform.scale(
                      scale: 0.5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: changecolor ? Colors.black45 : Colours.app_main,
                      )),
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
        },
        onCnfrm: (String a, String b) {
          var staff = a;
          // print(stuff);
          setState(() {
            labels[labelnumber] = staff;
            validations[labelnumber] = true;
            suivant = eq(validations, [true, true, true, true]);
          });
        });
  }

  Widget _complicatedTextField(
      String label, String hint, bool changecolor, VoidCallback callback) {
    return GestureDetector(
        onTap: callback,
        child: ListTile(
          title: Container(
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
                          color:
                              changecolor ? Colours.app_main : Colors.black54),
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
          ),
        ));
  }
}
