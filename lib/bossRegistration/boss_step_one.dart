import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_zhipin_boss/components/complicated_textfield.dart';
import 'package:my_zhipin_boss/components/frame.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';
import 'package:my_zhipin_boss/components/popup_route.dart';
import 'package:my_zhipin_boss/components/push_manoeuver.dart';
import 'package:my_zhipin_boss/components/scrollcomponent.dart';
import 'package:my_zhipin_boss/components/valid_button.dart';
import 'package:my_zhipin_boss/registration/personalInformation/grid_widget.dart';
import 'package:my_zhipin_boss/registration/personalInformation/photo_options.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/bossRegistration/boss_step_two.dart';
import 'package:my_zhipin_boss/bossRegistration/company_completer.dart';
import 'package:my_zhipin_boss/bossRegistration/transition_job.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/models/boss.dart';
import 'package:my_zhipin_boss/mycupertinopicker/flutter_cupertino_date_picker.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/confirmation/field_writer.dart';
import 'package:my_zhipin_boss/registration/utilities/item_completer.dart';
import 'package:my_zhipin_boss/registration/academics/step_three.dart';
import 'package:my_zhipin_boss/registration/professionals/step_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BossStepOne extends StatefulWidget {
  @override
  _BossStepOneState createState() => _BossStepOneState();
}

class _BossStepOneState extends State<BossStepOne> {
  bool genre, suivant = false, _avatargrid = false, _photoclick = false;

  UserDaoService dao = new UserDaoService();

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

  var secondmodel = new Boss();

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

  AppState appstate;

  FToast fToast;

  final picker = ImagePicker();

  Function eq = const ListEquality().equals;

  var controllertab = <TextEditingController>[
    new TextEditingController(),
    new TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<PickedFile> getImage(ImageSource imagesource) async {
    final pickedFile = await picker.getImage(source: imagesource);

    return pickedFile;
  }

  @override
  dispose() {
    control.dispose();
    super.dispose();
  }

  // Future<void> scrollafterbuild(Duration d) {
  //   return _scrollcontroller.animateTo(
  //     _scrollcontroller.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // WidgetsBinding.instance.addPostFrameCallback(scrollafterbuild);
    // scrollafterbuild();
    appstate = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    appstate.updateLoading(false);
    // controllertab[0] = new TextEditingController(text: model.nom);
    // controllertab[1] = new TextEditingController(text: model.prenom);

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

  _validersuivant() async {
    Boss model = appstate.boss;

    if (suivant) {
      appstate.updateLoading(true);
      model.updatePic(avatarimage);

      if (!avatarimage.startsWith('assets/images')) {
        String downloadUrl =
            await dao.uploadFile(avatarimage, directory: 'profile pictures');
        model.updatePic(downloadUrl);
      }

      model.updateNom(labels[0]);
      model.updateMail(labels[3]);
      model.updateFonction(labels[2]);

      model.updateEntreprise(secondmodel.entreprise);
      model.updateAbbrev(secondmodel.abbrev);
      model.updateStaff(secondmodel.staff);
      model.updateExpertise(secondmodel.expertise);

      appstate.updateBoss(model);

      try {
        await dao.user
            .updateProfile(photoURL: model.pic, displayName: model.nom);
        String companyid = await dao.saveUserAndCompany(
            {...model.toJson(), 'uid': appstate.dao.user.uid});

        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new BossStepTwo(companyid: companyid),
            ));
      } catch (e) {
        print(model.toJson());
        print(e);
        appstate.updateLoading(false);
      }
    } else {
      for (int i = 0; i < 5; i++) {
        if (i == 4) continue;
        if (!validations[i]) {
          // print(i.toString() + ": " + validations.toString());
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
        child: Text("les prospects auront accès à ces informations",
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
            radius: ScreenUtil().setHeight(ScreenUtil().setHeight(100.0)),
            backgroundImage: AssetImage(avatarimage),
          ),
        )));

    widgets.add(pagedivider(ScreenUtil().setHeight(70)));

    widgets.addAll([
      // _basictextfield("Fonction", "Quelle est votre fonction", 0, 1),

      complicatedTextField("Nom Complet", labels[0], validations[1], () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(FieldWriter(
                title: "Votre nom complet",
                hint: "Alex Barry",
                inputformatter: false)));
        // print("---------------------------------");
        setState(() {
          labels[0] = result;
          validations[1] = true;
          suivant = eq(validations, [true, true, true, true, true]);
        });
        // print(validations);
      }),

      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Nom de l'entreprise", labels[1], validations[2],
          () async {
        await Navigator.push(
            context,
            pushManoeuver(ScopedModel<Boss>(
                model: secondmodel,
                child: CompanyCompleter(
                  title: "Nom de l'entreprise",
                  hint: "Svp entrez le nom de l'entreprise",
                  collection: "companylist",
                ))));

        if (secondmodel.entreprise != null) {
          setState(() {
            labels[1] =
                '' + secondmodel.abbrev + ' - ' + secondmodel.entreprise;
            validations[2] = true;
            suivant = eq(validations, [true, true, true, true, true]);
          });
        }
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Fonction", labels[2], validations[3], () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(FieldWriter(
                title: "Quelle est votre fonction?",
                hint: "Responsable des ventes",
                inputformatter: false)));
        // print("---------------------------------");
        setState(() {
          labels[2] = result;
          validations[3] = true;
          suivant = eq(validations, [true, true, true, true, true]);
        });
        // print(validations);
      }),
      pagedivider(ScreenUtil().setHeight(70)),
      complicatedTextField("Adresse mail", labels[3], validations[4], () async {
        final result = await Navigator.push(
            context,
            pushManoeuver(FieldWriter(
                title: "Votre boite mail",
                hint: "mycompany@mycompany.com",
                inputformatter: false)));
        // print("---------------------------------");
        setState(() {
          labels[3] = result;
          validations[4] = true;
          suivant = eq(validations, [true, true, true, true, true]);
        });
        // print(validations);
      }),
      pagedivider(ScreenUtil().setHeight(70)),
    ]);

    return widgets;
  }

  void updateModel(User model, var index, var value) {
    if (index == 2)
      model.updateNom(value);
    else if (index == 3) model.updatePrenom(value);
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
}
