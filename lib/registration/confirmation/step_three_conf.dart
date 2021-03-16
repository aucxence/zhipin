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
import 'package:my_zhipin_boss/registration/utilities/category_finder.dart';
import 'package:my_zhipin_boss/registration/utilities/item_completer.dart';
import 'package:my_zhipin_boss/registration/utilities/major_finder.dart';
import 'package:my_zhipin_boss/registration/Edge/my_advantage.dart';
import 'package:my_zhipin_boss/registration/utilities/item_finder.dart';
import 'package:my_zhipin_boss/registration/utilities/work_descriptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:my_zhipin_boss/registration/expectations/step_four.dart';

class StepThreeConf extends StatefulWidget {
  final AppState appstate;

  const StepThreeConf({Key key, this.appstate}) : super(key: key);

  @override
  _StepThreeConfState createState() => _StepThreeConfState();
}

class _StepThreeConfState extends State<StepThreeConf>
    with SingleTickerProviderStateMixin {
  bool genre, suivant = true;

  DateTimePickerLocale _locale = DateTimePickerLocale.fr;

  String MIN_DATETIME = '1990-01-01';
  String MAX_DATETIME = '2021-12-01';
  String INIT_DATETIME = '2018-01-01';

  DateTimePickerTheme theme;

  var hiddenzones = <bool>[false];

  var validations = <bool>[
    true, // company name
    true, // début période
    true, // fin période
    true // description du job
  ];

  var labels = <String>[
    "Dans quelle école avez-vous fréquenté?",
    "Renseigner votre niveau académique",
    "Renseigner votre domaine de compétence",
    "Période de temps"
  ];

  var valid = {
    0: "Renseignez votre école de formation",
    1: "Renseignez votre niveau académique",
    2: "Renseignez votre domaine de compétence",
    3: "Renseignez votre période d'étude"
  };

  var mentions = [
    "Sans mention",
    "Mention Passable",
    "Mention Assez bien",
    "Mention Bien",
    "Mention Très Bien",
    "Mention Excellente"
  ];

  static const LB = [
    "Dans quelle école avez-vous fréquenté?",
    "Renseigner votre niveau académique",
    "Renseigner votre domaine de compétence",
    "Période de temps"
  ];

  static AnimationController control;
  static Animation<Offset> offset;

  ScrollController _scrollcontroller = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Function eq = const ListEquality().equals;

  var chosenfield;

  FToast fToast;

  @override
  void initState() {
    super.initState();
    labels = [
      widget.appstate.user.school,
      widget.appstate.user.degree,
      widget.appstate.user.major,
      widget.appstate.user.timeframe
    ];
    fToast = FToast();
    fToast.init(context);
    control =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

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

  _validersuivant() {
    appstate.updateLoading(true);
    User model = appstate.user;
    if (suivant) {
      model.updateSchool(labels[0]);
      model.updateDegree(labels[1]);
      model.updateMajor(labels[2]);
      model.updateTimeFrame(labels[3]);

      appstate.updateUser(model);

      Navigator.pop(context, true);
    } else {
      appstate.updateLoading(false);
      for (int i = 0; i < 7; i++) {
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
      complicatedTextField("Nom de l'école", labels[0], validations[0],
          () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(ItemFinder(
              title: "Nom de l'école",
              hint: "Svp entrez le nom de l'école",
              collection: "schoollist",
              index: "searchindex",
              ordering: "schoolfullname",
            )));
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
      pagedivider(ScreenUtil().setHeight(70)),
      _datepicker("Niveau Académique", labels[1], validations[1], () async {
        _showDatePicker(1, DateTimePickerMode.degree, {
          "CEPE": ["Cours ordinaire", "Cours du soir"],
          "BEPC": ["Cours ordinaire", "Cours du soir"],
          "Probatoire": mentions,
          "BAC": mentions,
          "License": mentions,
          "Master 1": mentions,
          "Master 2": mentions,
          "Doctorat": mentions
        });
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      (hiddenzones[0])
          ? complicatedTextField("Spécialité/Major", labels[2], validations[2],
              () async {
              final result = await Navigator.push(
                context,
                pushManoeuver(ItemFinder(
                  title: "Votre spécialité",
                  hint: "Svp entrez votre spécialité",
                  collection: "majorlist",
                  index: "searchindex",
                  ordering: "majorfullname",
                )),
              );
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
      (hiddenzones[0]) ? pagedivider(ScreenUtil().setHeight(70)) : Container(),
      _datepicker("Période", labels[3], validations[3], () async {
        _showDatePicker(3, DateTimePickerMode.range, null);
      }),
    ]);

    return widgets;
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
