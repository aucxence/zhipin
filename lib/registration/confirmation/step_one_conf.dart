import 'package:image_picker/image_picker.dart';
import 'package:my_zhipin_boss/components/frame.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';
import 'package:my_zhipin_boss/components/popup_route.dart';
import 'package:my_zhipin_boss/components/push_manoeuver.dart';
import 'package:my_zhipin_boss/components/valid_button.dart';
import 'package:my_zhipin_boss/registration/personalInformation/grid_widget.dart';
import 'package:my_zhipin_boss/registration/personalInformation/photo_options.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/confirmation/field_writer.dart';
import 'package:my_zhipin_boss/registration/confirmation/long_field_writer.dart';
import 'package:my_zhipin_boss/registration/professionals/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class StepOneConfirmation extends StatefulWidget {
  @override
  _StepOneState createState() => _StepOneState();
}

class _StepOneState extends State<StepOneConfirmation> {
  bool genre, suivant = true;

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

  DateTime birth;

  final picker = ImagePicker();

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
  }

  @override
  dispose() {
    super.dispose();
  }

  // void scrollafterbuild(Duration d) {
  //   _scrollcontroller.animateTo(
  //     _scrollcontroller.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeOut,
  //   );
  // }

  AppState appstate;

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

    appstate = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    appstate.updateLoading(false);

    return frameComponent(context, _validersuivant, stackmanager(), suivant);
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(50));
  }

  List<Widget> stackmanager() {
    List<Widget> wholeset = [];

    var model = appstate.user;

    var login = Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(40),
            right: ScreenUtil().setWidth(40),
            top: ScreenUtil().setHeight(20),
            bottom: ScreenUtil().setHeight(130)),
        margin: EdgeInsets.symmetric(vertical: 0),
        child: ListView.separated(
          itemCount: getWidgetColumn(model).length,
          separatorBuilder: (context, index) => pagedivider(),
          itemBuilder: (context, index) => getWidgetColumn(model)[index],
        ));

    wholeset.add(login);

    var button = validationButton(suivant, _validersuivant);

    wholeset.add(button);

    return wholeset;
  }

  _validersuivant() {
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

  List<Widget> getWidgetColumn(User model) {
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
        onTap: () async {
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
      ),
    ));

    widgets.add(_component("Nom", model.nom, () async {
      final result = await Navigator.push(
        context,
        pushManoeuver(FieldWriter(title: "Nom", hint: "Entrez votre nom")),
      );

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
          pushManoeuver(
              FieldWriter(title: "Prenom", hint: "Entrez votre prenom")));

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
          pushManoeuver(FieldWriter(
              title: "Numéro WhatsApp", hint: "Entrez votre numéro WhatsApp")));

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
          pushManoeuver(LongFieldWriter(
              existing: model.advantage,
              hinttext: '''
1. Diplomé en ingénieurie informatique (BAC + 5) avec mention
2. 10 ans d'expérience dans le dévelopement mobile
3. Pilote des projets innovants tels que ...
4. Certifié dans les technologies ...
5. ...
                        ''',
              topic: "Vos points forts",
              collection: "advantagetemplate")));

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

  void updateModel(User model, var index, var value) {
    if (index == 2)
      model.updateNom(value);
    else if (index == 3) model.updatePrenom(value);

    suivant =
        eq(validations, [true, true, true, true, true, true, true, true]) ||
            eq(validations, [true, true, true, true, true, false, true, true]);
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

  // Widget _gridwidget(User model) {
  //   return Align(
  //       alignment: Alignment.bottomCenter,
  //       child: SlideTransition(
  //           position: offset,
  //           child: Card(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10)),
  //               child: Container(
  //                 width: double.infinity,
  //                 height: ScreenUtil().setHeight(400),
  //                 padding: EdgeInsets.symmetric(
  //                     vertical: ScreenUtil().setHeight(30),
  //                     horizontal: ScreenUtil().setWidth(20)),
  //                 child: GridView.builder(
  //                   itemCount: 8,
  //                   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
  //                       crossAxisCount: 4),
  //                   itemBuilder: (context, index) {
  //                     var j = index + 1;
  //                     return GestureDetector(
  //                       onTap: () {
  //                         setState(() {
  //                           avatarimage = "assets/images/avatars/avatar" +
  //                               j.toString() +
  //                               ".png";
  //                           model.updatePic(avatarimage);

  //                           suivant = eq(validations, [
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 true
  //                               ]) ||
  //                               eq(validations, [
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 true,
  //                                 false,
  //                                 true,
  //                                 true
  //                               ]);
  //                           control.reverse();
  //                         });
  //                       },
  //                       child: Container(
  //                         alignment: Alignment.center,
  //                         child: CircleAvatar(
  //                           radius: ScreenUtil()
  //                               .setWidth(ScreenUtil().setHeight(150.0)),
  //                           backgroundImage: AssetImage(
  //                               "assets/images/avatars/avatar" +
  //                                   j.toString() +
  //                                   ".png"),
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ))));
  // }

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
