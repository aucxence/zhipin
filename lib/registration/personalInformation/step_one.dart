import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_zhipin_boss/components/basic_textfield.dart';
import 'package:my_zhipin_boss/components/complicated_textfield.dart';
import 'package:my_zhipin_boss/components/datepicker.dart';
import 'package:my_zhipin_boss/components/frame.dart';
import 'package:my_zhipin_boss/components/gender_radio_button.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';
import 'package:my_zhipin_boss/components/popup_route.dart';
import 'package:my_zhipin_boss/components/scrollcomponent.dart';
import 'package:my_zhipin_boss/components/valid_button.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/registration/personalInformation/basic_dropdown.dart';
import 'package:my_zhipin_boss/registration/personalInformation/grid_widget.dart';
import 'package:my_zhipin_boss/registration/personalInformation/photo_options.dart';
import 'package:my_zhipin_boss/registration/academics/step_three.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/professionals/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;

import '../../components/toaster.dart';

class StepOne extends StatefulWidget {
  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  bool genre, suivant = false;
  // , _avatargrid = false, _photoclick = false;

  var validations = <bool>[
    false, // avatar
    false, // gender
    false, // nom
    false, // prenom
    false, // année et mois de naissance
    false, // experience professionelle
  ];

  var valid = {
    0: "Choisissez votre avatar",
    1: "Choisissez votre genre",
    2: "Renseignez votre nom",
    3: "Renseignez votre prenom",
    4: "Renseignez votre année et mois de naissance",
    5: "Renseignez votre expérience professionelle",
  };

  final picker = ImagePicker();

  // static AnimationController control;
  // static Animation<Offset> offset;

  ScrollController _scrollcontroller = ScrollController();

  DateTime birth;

  var birthday = "Par exemple 1992-06",
      avatarimage = "assets/images/avatar.jpg",
      experience = "Par exemple 2020-03";

  final defaultbirthday = "Par exemple 1992-06",
      defaultexperience = "Par exemple 2020-03";

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
    // control =
    //     AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // var statuslistener = (status) {
    //   if (status == AnimationStatus.dismissed) {
    //     setState(() {
    //       _photoclick = false;
    //       _avatargrid = false;
    //     });
    //   }
    // };
    // control.addStatusListener(statuslistener);
    // offset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
    // .animate(control);
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

  AppState appstate;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);
    appstate = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    appstate.updateLoading(false);

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

    // if (_avatargrid) {
    //   var barrier = Stack(children: <Widget>[
    //     new ModalBarrier(color: Colors.black26),
    //     _gridwidget(),
    //   ]);

    //   wholeset.add(barrier);
    // }

    // if (_photoclick) {
    //   var barrier = Stack(children: <Widget>[
    //     new ModalBarrier(color: Colors.black26),
    //     _photooptions(),
    //   ]);

    //   wholeset.add(barrier);
    // }

    return wholeset;
  }

  _validersuivant() {
    appstate.updateLoading(true);
    print(validations);
    if (suivant) {
      User model = appstate.user;
      model.updateNom(controllertab[0].text);
      model.updatePrenom(controllertab[1].text);
      model.updateGender(genre);
      model.updateBirth(birthday);
      model.updatePic(avatarimage);
      model.updateProfExp(experience);

      appstate.updateUser(model);

      experience == 'Pas d\'expérience'
          ? Navigator.push(
              context, MaterialPageRoute(builder: (context) => StepThree()))
          : Navigator.push(
              context, MaterialPageRoute(builder: (context) => StepTwo()));
    } else {
      appstate.updateLoading(false);
      for (int i = 0; i < 6; i++) {
        if (!validations[i]) {
          var errorMessage = valid[i];
          showToast(fToast, Icons.no_encryption, errorMessage, 10);
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
          onTap: () async {
            // setState(() {
            //   _photoclick = true;
            // });
            // control.forward();
            final result = await Navigator.push(
                context,
                new AxRoute(
                    label: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    child: _photooptions()));

            print(result);

            switch (result) {
              case "1":
                getImage(ImageSource.camera).then((pickedFile) {
                  setState(() {
                    if (pickedFile != null) {
                      avatarimage = pickedFile.path;
                    } else {
                      print('No image selected.');
                    }
                    validations[0] = avatarimage != "assets/images/avatar.jpg";
                  });
                  // control.reverse();
                });
                break;
              case "2":
                getImage(ImageSource.gallery).then((pickedFile) {
                  setState(() {
                    if (pickedFile != null) {
                      avatarimage = pickedFile.path;
                    } else {
                      print('No image selected.');
                    }
                    validations[0] = avatarimage != "assets/images/avatar.jpg";
                  });
                  // control.reverse();
                });
                break;
              case "3":
                Navigator.push(
                    context,
                    new AxRoute(
                        label: MaterialLocalizations.of(context)
                            .modalBarrierDismissLabel,
                        child: _gridwidget()));
                break;
              default:
                break;
            }
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
          genderRadioButton(true, genre, (newvalue) {
            setState(() {
              genre = newvalue;
              validations[1] = true;
              suivant = eq(validations, [true, true, true, true, true, true]);
              print(validations);
            });
          }, Colours.app_main),
          Text("Homme", style: TextStyle(color: Colors.black)),
          genderRadioButton(false, genre, (newvalue) {
            setState(() {
              genre = newvalue;
              validations[1] = true;
              suivant = eq(validations, [true, true, true, true, true, true]);
              print(validations);
            });
          }, Colours.app_main),
          Text("Femme", style: TextStyle(color: Colors.black)),
        ],
      ),
    ));

    widgets.addAll([
      basictextfield(
          "Renseignez votre nom", "Nom", controllertab[0], updateNomPrenom(2)),
      pagedivider(ScreenUtil().setHeight(70)),
      basictextfield("Renseignez votre prénom", "Prénom", controllertab[1],
          updateNomPrenom(3)),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField(
          "Année et mois de Naissance", birthday, birthday != defaultbirthday,
          () {
        _showDatePicker(true);
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Entrée dans le monde professionel", experience,
          experience != defaultexperience, () async {
        showUpdatedPicker();
      })
    ]);

    return widgets;
  }

  updateNomPrenom(num index) {
    var updateprof = (value) {
      validations[index] = value.isNotEmpty;
      print(" tttttt : " + validations[index].toString());
      validations[index] = value.isNotEmpty;
      setState(() {
        suivant = eq(validations, [true, true, true, true, true, true]);
      });

      return value;
    };

    return updateprof;
  }

  Function gridwidgetcallback(num j) {
    return () {
      setState(() {
        avatarimage = "assets/images/avatars/avatar" + j.toString() + ".png";
        validations[0] = avatarimage != "assets/images/avatar.jpg";
        suivant = eq(validations, [true, true, true, true, true, true]);
        // control.reverse();
        Navigator.pop(context);
      });
    };
  }

  Widget _gridwidget() => gridwidget(gridwidgetcallback);

  var naturalspacing = 10.0;

  Future getImage(ImageSource imagesource) async {
    final pickedFile = await picker.getImage(source: imagesource);

    return pickedFile;
  }

  Widget _photooptions() {
    var photocallbacks = [
      () {
        Navigator.pop(context, "1");
      },
      () {
        Navigator.pop(context, "2");
      },
      () {
        Navigator.pop(context, "3");
      },
      () {
        Navigator.pop(context, "0");
      }
    ];

    return photoOptions(photocallbacks, photooptionsnames);
  }

  /// Display date picker.
  void _showDatePicker(bool oneortwo) {
    const String MIN_DATETIME = '1960-01-01';
    const String MAX_DATETIME = '2021-01-01';
    const String INIT_DATETIME = '1992-05-17';
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
      dateFormat: "yyyy-MMMM",
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
          suivant = eq(validations, [true, true, true, true, true, true]);
        });
        print("suivant: " + suivant.toString());
        print("validations: " + validations.toString());
      },
    );
  }

  showUpdatedPicker() {
    const String MIN_DATETIME = '1960-01-01';
    const String MAX_DATETIME = '2021-01-01';
    const String INIT_DATETIME = '2019-05-17';
    DateTimePickerLocale _locale = DateTimePickerLocale.fr;

    DatePicker.showDatePicker(context,
        pickerMode: DateTimePickerMode.updatedpicker,
        pickerTheme: DateTimePickerTheme(
          showTitle: true,
          confirm: Text('Valider', style: TextStyle(color: Colours.app_main)),
          cancel: Text('Annuler', style: TextStyle(color: Colors.black45)),
        ),
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
            experience = ((today > DateTime.now().year)
                ? "Pas d'expérience"
                : new DateFormat("yyyy-MM").format(dateTime));

            validations[5] = experience != defaultexperience;

            suivant = eq(validations, [true, true, true, true, true, true]);
          });
          //print("suivant: " + suivant.toString());
          // print("validations: " + validations.toString());
        },
        updateditem: "Pas d'expérience");
  }
}
