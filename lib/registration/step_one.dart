import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;

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

  var valid = {
    0: "Choisissez votre avatar",
    1: "Choisissez votre genre",
    2: "Renseignez votre nom",
    3: "Renseignez votre prenom",
    4: "Renseignez votre année et mois de naissance",
    6: "Renseignez votre expérience professionelle",
  };

  final picker = ImagePicker();

  static AnimationController control;
  static Animation<Offset> offset;

  ScrollController _scrollcontroller = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime birth;

  var birthday = "Par exemple 1992-06",
      avatarimage = "assets/images/avatar.jpg",
      experience = "Par exemple 2015-06";

  final defaultbirthday = "Par exemple 1992-06",
      defaultexperience = "Par exemple 2015-06";

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

  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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

  showToast(IconData icon, String message, num timeout) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: timeout),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);

    return Scaffold(
        appBar: AppBar(
          leading: Transform.rotate(
              angle: math.pi,
              child: IconButton(
                icon: Icon(Icons.exit_to_app),
                color: Colors.redAccent,
                onPressed: () {
                  UserDaoService dao = ScopedModel.of<AppState>(context).dao;
                  dao.signOut();
                },
              )),
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
            children: stackmanager(context),
          ),
        ));
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(50));
  }

  List<Widget> stackmanager(BuildContext context) {
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
          onTap: () => _validersuivant()),
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

  _validersuivant() {
    User model = ScopedModel.of<User>(context);
    if (suivant) {
      model.updateNom(controllertab[0].text);
      model.updatePrenom(controllertab[1].text);
      model.updateGender(genre);
      model.updateBirth(birthday);
      model.updatePic(avatarimage);
      model.updateProfExp(experience);
      if (validations[5]) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StepTwo()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StepTwo()));
      }
    } else {
      for (int i = 0; i <= 6; i++) {
        if (i == 5) continue;
        if (!validations[i]) {
          // print(i.toString() + ": " + validations.toString());
          var errorMessage = valid[i];
          showToast(Icons.no_encryption, errorMessage, 10);
          // Toast.show(valid[i]["response"]);
          break;
        }
      }
    }
  }

  List<Widget> getWidgetColumn() {
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
              activeColor: Colours.app_main,
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
              activeColor: Colours.app_main,
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
      _datepicker("Année et mois de Naissance", birthday, defaultbirthday, () {
        _showDatePicker(true);
      }),
      _pagedivider(),
      _basicdropdown(),
      _pagedivider()
    ]);

    if (validations[5]) {
      widgets.add(_datepicker("Date d'entrée dans le monde professionelle",
          experience, defaultexperience, () async {
        _showDatePicker(false);
      }));
    }

    return widgets;
  }

  void updateModel(User model, var index, var value) {
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
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.fade,
            )),
        DropdownButton<bool>(
            isExpanded: true,
            iconEnabledColor: Colors.black45,
            value: validations[5],
            underline: Container(color: Colors.white),
            style: TextStyle(color: Colours.app_main),
            selectedItemBuilder: (BuildContext context) {
              return <bool>[false, true].map((bool value) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      value == true ? 'Oui' : 'Non',
                      style: TextStyle(color: Colours.app_main),
                    ),
                  ],
                );
              }).toList();
            },
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
      autofocus: false,
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

  Future getImage(ImageSource imagesource) async {
    final pickedFile = await picker.getImage(source: imagesource);

    return pickedFile;
  }

  Widget _photooptions() {
    var photocallbacks = [
      () {
        getImage(ImageSource.camera).then((pickedFile) {
          setState(() {
            if (pickedFile != null) {
              avatarimage = pickedFile.path;
            } else {
              print('No image selected.');
            }
          });
          control.reverse();
        });
      },
      () {
        getImage(ImageSource.gallery).then((pickedFile) {
          setState(() {
            if (pickedFile != null) {
              avatarimage = pickedFile.path;
            } else {
              print('No image selected.');
            }
          });
          control.reverse();
        });
      },
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

  Widget _datepicker(
      String label, String hint, String defaultvalue, VoidCallback callback) {
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
                  Text(hint,
                      style: TextStyle(
                          color: hint != defaultvalue
                              ? Colours.app_main
                              : Colors.black54)),
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
