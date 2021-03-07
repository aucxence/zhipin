import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_zhipin_boss/components/complicated_textfield.dart';
import 'package:my_zhipin_boss/components/datepicker.dart';
import 'package:my_zhipin_boss/components/frame.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';
import 'package:my_zhipin_boss/components/push_manoeuver.dart';
import 'package:my_zhipin_boss/components/scrollcomponent.dart';
import 'package:my_zhipin_boss/components/valid_button.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/utilities/ability_finder.dart';
import 'package:my_zhipin_boss/registration/utilities/category_finder.dart';
import 'package:my_zhipin_boss/registration/utilities/item_completer.dart';
import 'package:my_zhipin_boss/registration/academics/step_three.dart';
import 'package:my_zhipin_boss/registration/utilities/work_descriptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../components/toaster.dart';

class StepTwo extends StatefulWidget {
  @override
  _StepTwoState createState() => _StepTwoState();
}

class _StepTwoState extends State<StepTwo> {
  bool suivant = false;

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

  var labels = <String>[
    "Remplissez votre nom de l'entreprise",
    "Par exemple 2017-06",
    "Par exemple 2019-06",
    "Saisissez la catégorie de l'emploi",
    "Choisissez vos compétences spécifiques",
    "Décrivez votre travail"
  ];

  // var valid = [
  //   {"id": 0, "response": "Choisissez votre avatar"},
  //   {"id": 1, "response": "Choisissez votre genre"},
  //   {"id": 2, "response": "Renseignez votre nom"},
  //   {"id": 3, "response": "Renseignez votre prenom"},
  //   {"id": 4, "response": "Renseignez votre année et mois de naissance"},
  //   {"id": 6, "response": "Renseignez votre expérience professionelle"},
  // ];

  var valid = {
    0: "Renseignez votre compagnie",
    1: "Renseignez votre période de début",
    2: "Renseignez votre période de fin",
    3: "Renseignez votre position",
    4: "Renseignez votre tags",
    5: "Renseignez votre description d'emploi",
  };

  ScrollController _scrollcontroller = ScrollController();

  Function eq = const ListEquality().equals;

  var chosenfield;

  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    // control =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // var statuslistener = (status) {
    //   if(status == AnimationStatus.dismissed) {
    //     setState(() {
    //       _companyname = false;
    //     });
    //   }
    // };
    // control.addStatusListener(statuslistener);
    // offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
    //     .animate(control);
  }

  @override
  dispose() {
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
    // WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);
    return frameComponent(context, _validersuivant, stackmanager(), suivant);
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(50));
  }

  List<Widget> stackmanager() {
    List<Widget> wholeset = [];

    // var login = Container(
    //   padding: EdgeInsets.only(
    //       left: ScreenUtil().setWidth(40),
    //       right: ScreenUtil().setWidth(40),
    //       top: ScreenUtil().setHeight(20),
    //       bottom: ScreenUtil().setHeight(130)),
    //   margin: EdgeInsets.symmetric(vertical: 0),
    //   child: SingleChildScrollView(
    //       controller: _scrollcontroller,
    //       child: Column(
    //         //mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: getWidgetColumn(),
    //       )),
    // );

    var login = scrollingComponent(getWidgetColumn(), _scrollcontroller);

    wholeset.add(login);

    var expansion = SizedBox.expand();

    wholeset.add(expansion);

    var button = validationButton(suivant, _validersuivant);

    wholeset.add(button);

    return wholeset;
  }

  _validersuivant() {
    appstate.updateLoading(true);
    if (suivant) {
      User model = appstate.user;
      model.updateCompany(labels[0]);
      model.updatePeriod1(labels[1]);
      model.updatePeriod2(labels[2]);
      model.updatePosCategory(labels[3]);
      model.updateJobTags(labels[4]);
      model.updateWorkDescription(labels[5]);
      // Toast.show("bonne validation");

      appstate.updateUser(model);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StepThree()));
    } else {
      appstate.updateLoading(false);
      for (int i = 0; i < 5; i++) {
        if (!validations[i]) {
          print(i.toString() + ": " + validations.toString());
          // Toast.show(valid[i]["response"]);
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
      complicatedTextField("Nom de l'entreprise", labels[0], validations[0],
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
                      index: "searchindex",
                      sortingField: "companyfullname");
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
      pagedivider(ScreenUtil().setHeight(70)),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            datepicker("Prise de service", labels[1], validations[1], () async {
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
            datepicker("Fin de service", labels[2], validations[2], () async {
              _showDatePicker(2, DateTimePickerMode.dateonly);
            }),
          ],
        ),
      ),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Catégorie de l'emploi", labels[3], validations[3],
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
                      index: "field",
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
      pagedivider(ScreenUtil().setHeight(70))
    ]);

    if (hiddenzones[0]) {
      widgets.add(complicatedTextField(
          "Compétences Spécifiques", labels[4], validations[4], () async {
        final result = await Navigator.push(
          context,
          pushManoeuver(AbilityFinder(
              collection: "fieldareas", index: "field", field: chosenfield)),
        );
        setState(() {
          labels[4] = result;
          validations[4] = true;
          hiddenzones[1] = true;
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
      }));
      widgets.add(pagedivider(ScreenUtil().setHeight(70)));
    }

    if (hiddenzones[1]) {
      widgets.add(complicatedTextField(
          "Description du travail", labels[5], validations[5], () async {
        final result = await Navigator.push(
          context,
          pushManoeuver(WorkDescriptor()),
        );
        setState(() {
          labels[5] = result;
          validations[5] = (result != null);
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
      }));
      widgets.add(pagedivider(ScreenUtil().setHeight(70)));
    }

    return widgets;
  }

  var naturalspacing = 10.0;

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
