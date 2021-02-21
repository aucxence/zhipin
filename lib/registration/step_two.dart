import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/ability_finder.dart';
import 'package:my_zhipin_boss/registration/category_finder.dart';
import 'package:my_zhipin_boss/registration/item_completer.dart';
import 'package:my_zhipin_boss/registration/step_three.dart';
import 'package:my_zhipin_boss/registration/work_descriptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class StepTwo extends StatefulWidget {
  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> with SingleTickerProviderStateMixin {
  bool genre, suivant = false;

  DateTimePickerLocale _locale = DateTimePickerLocale.fr;

  String MIN_DATETIME = '1990-01-01';
  String MAX_DATETIME = '2021-12-01';
  String INIT_DATETIME = '2018-01-01';

  DateTimePickerTheme theme;

  var hiddenzones = <bool>[false, false];

  var validations = <bool>[
    false, // company name
    false, // début période
    false, // fin période
    false, // catégorie du job
    false, // tags
    true, // description du job
  ];

  static var LABELS = [
    "Remplissez votre nom de l'entreprise",
    "Par exemple 2017-06",
    "Par exemple 2019-06",
    "Saisissez la catégorie de l'emploi",
    "Choisissez vos compétences spécifiques",
    "Décrivez votre travail"
  ];

  var labels = <String>[
    "Remplissez votre nom de l'entreprise",
    "Par exemple 2017-06",
    "Par exemple 2019-06",
    "Saisissez la catégorie de l'emploi",
    "Choisissez vos compétences spécifiques",
    "Décrivez votre travail"
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
    // WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);
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
                onTap: () => _validersuivant(),
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
          onTap: () => _validersuivant()),
    );

    wholeset.add(button);

    return wholeset;
  }

  _validersuivant() {
    User model = ScopedModel.of<User>(context);
    if (suivant) {
      model.updateCompany(labels[0]);
      model.updatePeriod1(labels[1]);
      model.updatePeriod2(labels[2]);
      model.updatePosCategory(labels[3]);
      model.updateJobTags(labels[4]);
      model.updateWorkDescription(labels[5]);
      // Toast.show("bonne validation");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StepThree()));
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
        child: Text("Plus récente expérience professionelle",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(50), color: Colors.black))));

    widgets.add(Container(
        alignment: Alignment.centerLeft,
        child: Text("Pour les recommendations d'entreprises identiques",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black45))));

    widgets.add(spacing());

    widgets.addAll([
      _complicatedTextField("Nom de l'entreprise", labels[0], validations[0],
          () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return ItemCompleter(
                    title: "Nom de l'entreprise",
                    hint: "Svp entrez le nom de l'entreprise",
                    collection: "companylist",
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
        setState(() {
          labels[0] = result;
          validations[0] = true;
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
        print(validations);
      }),
      _pagedivider(),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _datepicker("Prise de service", labels[1], validations[1],
                () async {
              _showDatePicker(1, DateTimePickerMode.date);
            }),
            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(30),
                  right: ScreenUtil().setWidth(45)),
              child: Text("à",
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            ),
            _datepicker("Fin de service", labels[2], validations[2], () async {
              _showDatePicker(2, DateTimePickerMode.dateonly);
            }),
          ],
        ),
      ),
      _pagedivider(),
      _complicatedTextField("Catégorie de l'emploi", labels[3], validations[3],
          () async {
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
        var parts = result.split("-");
        setState(() {
          labels[3] = parts[1];
          validations[3] = true;
          hiddenzones[0] = true;
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
        chosenfield = parts[0];
      }),
      _pagedivider()
    ]);

    if (hiddenzones[0]) {
      widgets.add(_complicatedTextField(
          "Compétences Spécifiques", labels[4], validations[4], () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return AbilityFinder(
                      collection: "fieldareas", field: chosenfield);
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
        setState(() {
          labels[4] = result;
          validations[4] = true;
          hiddenzones[1] = true;
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
      }));
      widgets.add(_pagedivider());
    }

    if (hiddenzones[1]) {
      widgets.add(_complicatedTextField(
          "Description du travail", labels[5], validations[5], () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return WorkDescriptor();
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
        setState(() {
          labels[5] = result;
          validations[5] = (result != null);
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
      }));
      widgets.add(_pagedivider());
    }

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
  void _showDatePicker(int labelnumber, DateTimePickerMode mode) {
    DatePicker.showDatePicker(
      context,
      pickerMode: mode,
      pickerTheme: theme,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime.parse(INIT_DATETIME),
      dateFormat: "yyyy-MMMM",
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
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
        //print("suivant: " + suivant.toString());
        // print("validations: " + validations.toString());
      },
    );
  }
}
