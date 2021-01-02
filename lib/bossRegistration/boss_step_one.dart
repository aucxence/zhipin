import 'package:my_zhipin_boss/BossRegistrationModel.dart';
import 'package:my_zhipin_boss/RegistrationModel.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/bossRegistration/company_completer.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/confirmation/field_writer.dart';
import 'package:my_zhipin_boss/registration/item_completer.dart';
import 'package:my_zhipin_boss/registration/step_three.dart';
import 'package:my_zhipin_boss/registration/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class BossStepOne extends StatefulWidget {
  @override
  _BossStepOneState createState() => _BossStepOneState();
}

class _BossStepOneState extends State<BossStepOne>
    with SingleTickerProviderStateMixin {
  bool genre, suivant = false, _avatargrid = false, _photoclick = false;

  var validations = <bool>[
    false, // profil
    false, // nom
    false, // entreprise
    false, // fonction
    false, // adresse mail
  ];

  var labels = <String>[
    "Remplissez votre nom complet",
    "Remplissez votre nom de l'entreprise",
    "Remplissez votre fonction",
    "Remplissez votre adresse mail"
  ];

  var secondmodel = new BossRegistrationModel();

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

  _validersuivant(BuildContext context, BossRegistrationModel model) async {
    if (suivant) {
      model.updateNom(labels[0]);
      model.updateAbbrev(secondmodel.abbrev);
      model.updateEntreprise(secondmodel.entreprise);
      model.updateFonction(labels[2]);
      model.updateMail(labels[3]);
      model.updateStaff(secondmodel.staff);

      final r = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new ScopedModel(
                child: validations[5] ? StepTwo() : StepThree(),
                model: new BossRegistrationModel()),
          ));
    } else {
      for (int i = 0; i < 7; i++) {
        if (i == 5) continue;
        if (!validations[i]) {
          // print(i.toString() + ": " + validations.toString());
          // Toast.show(valid[i]["response"]);
          break;
        }
      }
    }
  }

  List<Widget> getWidgetColumn(model) {
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

    widgets.add(Align(
        alignment: Alignment.center,
        child: ListTile(
          onTap: () {
            setState(() {
              _photoclick = true;
            });
            control.forward();
          },
          title: Text("Photo de profil"),
          trailing: CircleAvatar(
            radius: ScreenUtil().setWidth(ScreenUtil().setHeight(100.0)),
            backgroundImage: AssetImage(avatarimage),
          ),
        )));

    widgets.add(_pagedivider());

    widgets.addAll([
      // _basictextfield("Fonction", "Quelle est votre fonction", 0, 1),

      _complicatedTextField("Nom Complet", labels[0], validations[1], () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return FieldWriter(
                      title: "Votre nom complet",
                      hint: "Alex Barry",
                      inputformatter: false);
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
        // print("---------------------------------");
        setState(() {
          labels[0] = result;
          validations[1] = true;
          suivant = eq(validations, [true, true, true, true, true]);
        });
        // print(validations);
      }),

      _pagedivider(),
      _complicatedTextField("Nom de l'entreprise", labels[1], validations[2],
          () async {
        await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return ScopedModel<BossRegistrationModel>(
                      model: secondmodel,
                      child: CompanyCompleter(
                        title: "Nom de l'entreprise",
                        hint: "Svp entrez le nom de l'entreprise",
                        collection: "companylist",
                      ));
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

        if (secondmodel.entreprise != null) {
          setState(() {
            labels[1] =
                '' + secondmodel.abbrev + ' - ' + secondmodel.entreprise;
            validations[2] = true;
            suivant = eq(validations, [true, true, true, true, true]);
          });
        }
      }),
      _pagedivider(),
      _complicatedTextField("Fonction", labels[2], validations[3], () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return FieldWriter(
                      title: "Quelle est votre fonction?",
                      hint: "Responsable des ventes",
                      inputformatter: false);
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
        // print("---------------------------------");
        setState(() {
          labels[2] = result;
          validations[3] = true;
          suivant = eq(validations, [true, true, true, true, true]);
        });
        // print(validations);
      }),
      _pagedivider(),
      _complicatedTextField("Adresse mail", labels[3], validations[4],
          () async {
        final result = await Navigator.push(
            context,
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return FieldWriter(
                      title: "Votre boite mail",
                      hint: "mycompany@mycompany.com",
                      inputformatter: false);
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
        // print("---------------------------------");
        setState(() {
          labels[3] = result;
          validations[4] = true;
          suivant = eq(validations, [true, true, true, true, true]);
        });
        // print(validations);
      }),
      _pagedivider()
    ]);

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
                            suivant =
                                eq(validations, [true, true, true, true, true]);
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

  Widget _basictextfield(
      String label, String hint, int controllerindex, int validationindex) {
    return ListTile(
      title: Container(
        child: Column(
          children: <Widget>[
            Container(
              // padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(25), color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextField(
              controller: controllertab[controllerindex],
              style: TextStyle(color: Colours.app_main),
              onChanged: (value) {
                validations[validationindex] = value.isNotEmpty;
                // print(" tttttt : " + validations[validationindex].toString());
                // validations[index] = value.isNotEmpty;
                setState(() {
                  suivant = eq(validations, [true, true, true, true, true]);
                });

                return value;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: -10),
                //helperText: hint,
                hintText: hint,
                hintStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(30), color: Colors.black54),
                //labelText: label,
                labelStyle: TextStyle(color: Colors.black),
                border: InputBorder.none,
              ),
            )
          ],
        ),
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
      // onClose: () => print("----- onClose -----"),
      // onCancel: () => print('onCancel'),
      onChange: null,
      onConfirm: (dateTime, index) {
        birth = dateTime;
        setState(() {
          oneortwo
              ? birthday = new DateFormat("yyyy-MM").format(dateTime)
              : experience = new DateFormat("yyyy-MM").format(dateTime);
          oneortwo ? validations[4] = true : validations[6] = true;
          suivant = eq(validations, [true, true, true, true, true]);
        });
        // print("suivant: " + suivant.toString());
        // print("validations: " + validations.toString());
      },
    );
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
