import 'package:my_zhipin_boss/RegistrationModel.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/confirmation/field_writer.dart';
import 'package:my_zhipin_boss/registration/confirmation/long_field_writer.dart';
import 'package:my_zhipin_boss/registration/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class StepOneConfirmation extends StatefulWidget {
  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOneConfirmation>
    with SingleTickerProviderStateMixin {
  bool genre, suivant = false, _avatargrid = false, _photoclick = false;

  var validations = <bool>[
    true, // avatar
    true, // nom
    true, // prenom
    true, // gender
    true, // experience professionelle
    false, // numéro whatsapp
    true, // année et mois de naissance
    true // atouts
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

  DateTimePickerLocale _locale = DateTimePickerLocale.fr;

  static const String MIN_DATETIME = '1990-01-01';
  static const String MAX_DATETIME = '2021-12-01';
  static const String INIT_DATETIME = '2018-01-01';

  DateTimePickerTheme theme;

  @override
  void initState() {
    super.initState();
    suivant =
        eq(validations, [true, true, true, true, true, true, true, true]) ||
            eq(validations, [true, true, true, true, true, false, true, true]);
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

  // void scrollafterbuild(Duration d) {
  //   _scrollcontroller.animateTo(
  //     _scrollcontroller.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print(validations);

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

    return ScopedModelDescendant<RegistrationModel>(
        builder: (context, child, model) {
      // print("////////////////// " + model.nom);
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black45,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text("Profil",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(30))),
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
        child: ListView.separated(
          itemCount: getWidgetColumn(model).length,
          separatorBuilder: (context, index) => _pagedivider(),
          itemBuilder: (context, index) => getWidgetColumn(model)[index],
        ));

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
        new ModalBarrier(
          color: Colors.black26,
          dismissible: true,
        ),
        _gridwidget(model),
      ]);

      wholeset.add(barrier);
    }

    if (_photoclick) {
      var barrier = Stack(children: <Widget>[
        new ModalBarrier(
          color: Colors.black26,
          dismissible: true,
        ),
        _photooptions(),
      ]);

      wholeset.add(barrier);
    }

    return wholeset;
  }

  _validersuivant(BuildContext context, RegistrationModel model) {
    if (suivant) {
      Navigator.pop(context, true);
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
      child: ListTile(
        leading: Text(
          "Photo",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black45, fontSize: ScreenUtil().setSp(30)),
        ),
        trailing: CircleAvatar(
          radius: ScreenUtil().setWidth(ScreenUtil().setHeight(120.0)),
          backgroundImage: AssetImage(avatarimage),
        ),
        onTap: () {
          setState(() {
            _photoclick = true;
          });
          control.forward();
        },
      ),
    ));

    widgets.add(_component("Nom", model.nom, () async {
      final result = await Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return FieldWriter(title: "Nom", hint: "Entrez votre nom");
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

      print("---------------------- " + result);

      if (result != null) {
        setState(() {
          model.updateNom(result);
        });
        print("********************** " + model.nom);
      }
    }));

    widgets.add(_component("Prenom", model.prenom, () async {
      final result = await Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return FieldWriter(
                    title: "Prenom", hint: "Entrez votre prenom");
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

      print("---------------------- " + result);

      if (result != null) {
        setState(() {
          model.updatePrenom(result);
        });
        print("********************** " + model.prenom);
      }
    }));

    widgets.add(_component("Genre", model.gender ? "Homme" : "Femme", () async {
      DatePicker.showDatePicker(context,
          pickerMode: DateTimePickerMode.column,
          pickerTheme: theme,
          minDateTime: DateTime.parse(MIN_DATETIME),
          maxDateTime: DateTime.now(),
          initialDateTime: DateTime.parse(INIT_DATETIME),
          dateFormat: "yyyy-MMMM",
          data: {
            "values": ["Homme", "Femme"]
          },
          locale: _locale,
          onClose: () => print("----- onClose -----"),
          onCancel: () => print('onCancel'),
          onChange: null,
          onConfirm: null,
          onCnfrm: (String a, String b) {
            setState(() {
              model.updateGender(a == "Homme");
              suivant = eq(validations,
                      [true, true, true, true, true, true, true, true]) ||
                  eq(validations,
                      [true, true, true, true, true, false, true, true]);
            });
          });
    }));

    widgets.add(
        _component("Entrée dans le monde professionelle", model.profexp, () {
      DatePicker.showDatePicker(context,
          pickerMode: DateTimePickerMode.updatedpicker,
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
              model.updateProfExp((today > DateTime.now().year)
                  ? "Pas d'expérience"
                  : new DateFormat("yyyy-MM").format(dateTime));

              suivant = eq(validations,
                      [true, true, true, true, true, true, true, true]) ||
                  eq(validations,
                      [true, true, true, true, true, false, true, true]);
            });
            //print("suivant: " + suivant.toString());
            // print("validations: " + validations.toString());
          },
          updateditem: "Pas d'expérience");
    }));

    widgets.add(_component("Numéro WhatsApp", model.whatsappnumber, () async {
      final result = await Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return FieldWriter(
                    title: "Numéro WhatsApp",
                    hint: "Entrez votre numéro WhatsApp");
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

      print("---------------------- " + result);

      if (result != null) {
        setState(() {
          model.updateWhatsAppNumber(result);
          validations[5] = result != "";
          suivant = eq(validations,
                  [true, true, true, true, true, true, true, true]) ||
              eq(validations,
                  [true, true, true, true, true, false, true, true]);
        });
        print("********************** " + model.prenom);
      }
    }));

    widgets.add(_component("Date de naissance", model.birth, () async {
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
            model.updateBirth(new DateFormat("yyyy-MM").format(dateTime));
            suivant = eq(validations,
                    [true, true, true, true, true, true, true, true]) ||
                eq(validations,
                    [true, true, true, true, true, false, true, true]);
          });
          print("suivant: " + suivant.toString());
          print("validations: " + validations.toString());
        },
      );
    }));

    widgets.add(_component("Atouts", model.advantage, () async {
      final result = await Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return ScopedModel(
                  model: model,
                  child: LongFieldWriter(
                      advantage: model.advantage,
                      hinttext: '''
1. Diplomé en ingénieurie informatique (BAC + 5) avec mention
2. 10 ans d'expérience dans le dévelopement mobile
3. Pilote des projets innovants tels que ...
4. Certifié dans les technologies ...
5. ...
                        ''',
                      topic: "Vos points forts",
                      collection: "advantagetemplate"),
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

      print("---------------------- " + result);

      if (result != null) {
        setState(() {
          model.updateAdvantage(result);
          suivant = eq(validations,
                  [true, true, true, true, true, true, true, true]) ||
              eq(validations,
                  [true, true, true, true, true, false, true, true]);
        });
        print("********************** " + model.advantage);
      }
    }));

    return widgets;
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
                    height: ScreenUtil().setHeight(620),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(30),
                        horizontal: ScreenUtil().setWidth(20)),
                    child: ListView.separated(
                      itemCount: photocallbacks.length,
                      separatorBuilder: (context, index) {
                        return _pagedivider();
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: photocallbacks[index],
                          title: Center(
                            child: Text(photooptionsnames[index],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(30))),
                          ),
                        );
                      },
                    )))));
  }

  void updateModel(RegistrationModel model, var index, var value) {
    if (index == 2)
      model.updateNom(value);
    else if (index == 3) model.updatePrenom(value);

    suivant =
        eq(validations, [true, true, true, true, true, true, true, true]) ||
            eq(validations, [true, true, true, true, true, false, true, true]);
  }

  Widget _gridwidget(RegistrationModel model) {
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
                            model.updatePic(avatarimage);

                            suivant = eq(validations, [
                                  true,
                                  true,
                                  true,
                                  true,
                                  true,
                                  true,
                                  true,
                                  true
                                ]) ||
                                eq(validations, [
                                  true,
                                  true,
                                  true,
                                  true,
                                  true,
                                  false,
                                  true,
                                  true
                                ]);
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

  Widget _component(label, content, callback) {
    return Container(
        child: ListTile(
            onTap: callback,
            title: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black45, fontSize: ScreenUtil().setSp(25)),
              ),
            ),
            // contentPadding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
            subtitle: Text(
              content,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(30)),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
              child: Transform.scale(
                  scale: 0.4,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black45,
                  )),
            )));
  }
}