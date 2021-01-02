import 'package:my_zhipin_boss/RegistrationModel.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class StepOne extends StatefulWidget {
  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> with SingleTickerProviderStateMixin {
  bool genre, suivant = false, _avatargrid = false, _photoclick = false;

  var validations = <bool>[
    false, // avatar
    false, // gender
    false, // nom
    false, // prenom
    false, // année et mois de naissance
    false, // employee ?
    false // experience professionelle
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

  DateTime birth;

  var birthday = "Par exemple 1992-06",
      avatarimage = "assets/images/avatar.jpg",
      experience = "Par exemple 2015-06";

  var photooptionsnames = [
    "Prendre photo",
    "choisir à partir de l'album",
    "choisir un avatar",
    "annuler"
  ];

  Function eq = const ListEquality().equals;

  var controllertab = <TextEditingController>[
    new TextEditingController(),
    new TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
    control =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    var statuslistener = (status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _photoclick = false;
          _avatargrid = false;
        });
      }
    };
    control.addStatusListener(statuslistener);
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
    WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);
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

    if (_avatargrid) {
      var barrier = Stack(children: <Widget>[
        new ModalBarrier(color: Colors.black26),
        _gridwidget(),
      ]);

      wholeset.add(barrier);
    }

    if (_photoclick) {
      var barrier = Stack(children: <Widget>[
        new ModalBarrier(color: Colors.black26),
        _photooptions(),
      ]);

      wholeset.add(barrier);
    }

    return wholeset;
  }

  _validersuivant(BuildContext context, RegistrationModel model) {
    if (suivant) {
      model.updateNom(controllertab[0].text);
      model.updatePrenom(controllertab[1].text);
      model.updateGender(genre);
      model.updateBirth(birthday);
      model.updatePic(avatarimage);
      model.updateProfExp(experience);
      //Toast.show("bonne validation");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScopedModel<RegistrationModel>(
                  model: model, child: StepTwo())));
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

  List<Widget> getWidgetColumn(RegistrationModel model) {
    var widgets = <Widget>[];

    widgets.add(Align(
        alignment: Alignment.center,
        child: Text("Informations essentielles",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(50), color: Colors.black))));

    widgets.add(Align(
        alignment: Alignment.center,
        child: Text("de votre profil",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black45))));

    widgets.add(spacing());

    widgets.add(Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _photoclick = true;
            });
            control.forward();
          },
          child: CircleAvatar(
            radius: ScreenUtil().setWidth(ScreenUtil().setHeight(150.0)),
            backgroundImage: AssetImage(avatarimage),
          ),
        )));

    widgets.add(Align(
        alignment: Alignment.center,
        child: Text("Uploadez une photo de profil",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black45))));

    widgets.add(Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
              value: true,
              groupValue: genre,
              onChanged: (newvalue) {
                setState(() {
                  genre = newvalue;
                  validations[1] = true;
                  suivant = eq(validations,
                          [true, true, true, true, true, false, false]) ||
                      eq(validations,
                          [true, true, true, true, true, true, true]);
                  print(validations);
                });
              }),
          Text("Homme", style: TextStyle(color: Colors.black)),
          Radio(
              value: false,
              groupValue: genre,
              onChanged: (newvalue) {
                setState(() {
                  genre = newvalue;
                  validations[1] = true;
                  suivant = eq(validations,
                          [true, true, true, true, true, false, false]) ||
                      eq(validations,
                          [true, true, true, true, true, true, true]);
                  print(validations);
                });
              }),
          Text("Femme", style: TextStyle(color: Colors.black)),
        ],
      ),
    ));

    widgets.addAll([
      _basictextfield("Remplissez votre nom", "Nom", 2),
      _pagedivider(),
      _basictextfield("Remplissez votre prénom", "Prénom", 3),
      _pagedivider(),
      _datepicker("Année et mois de Naissance", birthday, () {
        _showDatePicker(true);
      }),
      _pagedivider(),
      _basicdropdown(),
      _pagedivider()
    ]);

    if (validations[5]) {
      widgets.add(_datepicker(
          "Date d'entrée dans le monde professionelle", experience, () async {
        _showDatePicker(false);
      }));
    }

    return widgets;
  }

  void updateModel(RegistrationModel model, var index, var value) {
    if (index == 2)
      model.updateNom(value);
    else if (index == 3) model.updatePrenom(value);
  }

  Widget _gridwidget() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
            position: offset,
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(400),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(30),
                      horizontal: ScreenUtil().setWidth(20)),
                  child: GridView.builder(
                    itemCount: 8,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                    itemBuilder: (context, index) {
                      var j = index + 1;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            avatarimage = "assets/images/avatars/avatar" +
                                j.toString() +
                                ".png";
                            validations[0] =
                                avatarimage != "assets/images/avatar.jpg";
                            suivant = eq(validations, [
                                  true,
                                  true,
                                  true,
                                  true,
                                  true,
                                  false,
                                  false
                                ]) ||
                                eq(validations,
                                    [true, true, true, true, true, true, true]);
                            control.reverse();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: ScreenUtil()
                                .setWidth(ScreenUtil().setHeight(150.0)),
                            backgroundImage: AssetImage(
                                "assets/images/avatars/avatar" +
                                    j.toString() +
                                    ".png"),
                          ),
                        ),
                      );
                    },
                  ),
                ))));
  }

  Widget _pagedivider() {
    return new Divider(
      color: Colors.black45,
    );
  }

  var naturalspacing = 10.0;

  Widget _basicdropdown() {
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(10.0)),
            child: Text(
              "Etes-vous déjà entré dans le monde professionel?",
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30), color: Colors.black),
              overflow: TextOverflow.fade,
            )),
        DropdownButton<bool>(
            isExpanded: true,
            iconEnabledColor: Colors.black,
            value: validations[5],
            underline: Container(color: Colors.white),
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35), color: Colors.black45),
            onChanged: (bool newValue) {
              setState(() {
                validations[5] = newValue;

                print("Employé? " + validations[5].toString());

                if (!validations[5]) {
                  experience = "Par exemple 2015-06";
                  validations[6] = false;
                }
                setState(() {
                  suivant = eq(validations,
                          [true, true, true, true, true, false, false]) ||
                      eq(validations,
                          [true, true, true, true, true, true, true]);
                });
              });
            },
            items:
                <bool>[false, true].map<DropdownMenuItem<bool>>((bool value) {
              return DropdownMenuItem(
                  value: value,
                  child: Text(
                    value ? "Oui" : "Non",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setSp(30),
                    ),
                  ));
            }).toList())
      ],
    );
  }

  Widget _basictextfield(String hint, String label, int index) {
    return TextField(
      controller: controllertab[index - 2],
      style: TextStyle(color: Colours.app_main),
      onChanged: (value) {
        validations[index] = value.isNotEmpty;
        print(" tttttt : " + validations[index].toString());
        validations[index] = value.isNotEmpty;
        setState(() {
          suivant =
              eq(validations, [true, true, true, true, true, false, false]) ||
                  eq(validations, [true, true, true, true, true, true, true]);
        });

        return value;
      },
      decoration: InputDecoration(
        //helperText: hint,
        hintText: hint,
        hintStyle:
            TextStyle(fontSize: ScreenUtil().setSp(30), color: Colors.black54),
        //labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
      ),
    );
  }

  Widget _photooptions() {
    var photocallbacks = [
      () {},
      () {},
      () {
        setState(() {
          _photoclick = false;
          _avatargrid = true;
        });
        control.forward();
      },
      () {
        control.reverse();
      }
    ];

    return Align(
        alignment: Alignment.bottomCenter,
        child: SlideTransition(
            position: offset,
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(475),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(30),
                        horizontal: ScreenUtil().setWidth(20)),
                    child: ListView.separated(
                      itemCount: photocallbacks.length,
                      separatorBuilder: (context, index) {
                        return _pagedivider();
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20),
                          ),
                          child: GestureDetector(
                            onTap: photocallbacks[index],
                            child: Center(
                              child: Text(photooptionsnames[index],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(30))),
                            ),
                          ),
                        );
                      },
                    )))));
  }

  Widget _datepicker(String label, String hint, VoidCallback callback) {
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
                  Text(hint, style: TextStyle(color: Colors.black54)),
                  Transform.scale(
                      scale: 0.5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black45,
                      )),
                ],
              ),
            ],
          ),
        ));
  }

  /// Display date picker.
  void _showDatePicker(bool oneortwo) {
    const String MIN_DATETIME = '1960-01-01';
    const String MAX_DATETIME = '2021-01-01';
    const String INIT_DATETIME = '2019-05-17';
    DateTimePickerLocale _locale = DateTimePickerLocale.fr;

    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Valider', style: TextStyle(color: Colours.app_main)),
        cancel: Text('Annuler', style: TextStyle(color: Colors.black45)),
      ),
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: DateTime.parse(INIT_DATETIME),
      dateFormat: "yyyy-MM",
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: null,
      onConfirm: (dateTime, index) {
        birth = dateTime;
        setState(() {
          oneortwo
              ? birthday = new DateFormat("yyyy-MM").format(dateTime)
              : experience = new DateFormat("yyyy-MM").format(dateTime);
          oneortwo ? validations[4] = true : validations[6] = true;
          suivant =
              eq(validations, [true, true, true, true, true, true, true]) ||
                  eq(validations, [true, true, true, true, true, false, false]);
        });
        print("suivant: " + suivant.toString());
        print("validations: " + validations.toString());
      },
    );
  }
}
