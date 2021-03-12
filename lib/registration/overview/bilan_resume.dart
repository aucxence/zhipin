import 'package:my_zhipin_boss/components/frame.dart';
import 'package:my_zhipin_boss/components/push_manoeuver.dart';
import 'package:my_zhipin_boss/components/valid_button.dart';
import 'package:my_zhipin_boss/registration/confirmation/field_writer.dart';
import 'package:my_zhipin_boss/registration/confirmation/long_field_writer.dart';
import 'package:my_zhipin_boss/registration/confirmation/step_four_conf.dart';
import 'package:my_zhipin_boss/registration/confirmation/step_three_conf.dart';
import 'package:my_zhipin_boss/registration/confirmation/step_two_conf.dart';
import 'package:my_zhipin_boss/registration/overview/step_one_widget.dart';
import 'package:my_zhipin_boss/registration/overview/step_widget.dart';
import 'package:my_zhipin_boss/registration/utilities/desired_areas.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/app/root_scene.dart';
import 'package:my_zhipin_boss/registration/confirmation/step_one_conf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';

class OverallResume extends StatefulWidget {
  @override
  _OverallResumeState createState() => _OverallResumeState();
}

class _OverallResumeState extends State<OverallResume> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  AppState appstate;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    appstate = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    appstate.updateLoading(false);

    return frameComponent(context, _validersuivant, stackmanager(), true,
        validationlabel: "Confirmer");
  }

  List<Widget> stackmanager() {
    List<Widget> wholeset = [];

    var login = Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(125)),
        child: ListView.separated(
          separatorBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
            child: Divider(
              color: Colors.black45,
              height: ScreenUtil().setHeight(70),
            ),
          ),
          itemCount: getWidgetColumn().length,
          itemBuilder: (context, index) => getWidgetColumn()[index],
        ));

    wholeset.add(login);

    var expansion = SizedBox.expand();

    wholeset.add(expansion);

    var button =
        validationButton(true, _validersuivant, validationlabel: "Confirmer");

    wholeset.add(button);

    return wholeset;
  }

  List<Widget> getWidgetColumn() {
    User model = appstate.user;

    var widgets = <Widget>[];

    // print("1. nom: ${model.nom}");
    // print("2. Prenom: ${model.prenom}");
    // print("3. Pic: ${model.pic}");
    // print("4. ExpectedJob: ${model.expectedjob}");
    // print("5. Expectedmoney: ${model.expectedmoney}");

    widgets.add(steponewidget(model, () async {
      final result = Navigator.push(context,
          MaterialPageRoute(builder: (context) => StepOneConfirmation()));
      if (result != null) print("Modification effectuée");
    }));

    widgets.add(stepwidget(context, "Atouts", null, null, null, model.advantage,
        callback: (ctx) async {
      final result = await Navigator.push(
          ctx,
          pushManoeuver(LongFieldWriter(
            existing: model.advantage,
            hinttext: "Décrivez vos atouts",
            collection: "advantagetemplate",
            topic: "Atouts",
            condition: (String value) {
              return (value.split("").length > 5);
            },
          )));
      model.updateAdvantage(result);
      appstate.updateUser(model);
    }));

    widgets.add(stepwidget(
        context,
        "Ambition Professionelle",
        model.expectedjob,
        model.expectedmoney,
        model.expectedcareer,
        null, callback: (ctx) async {
      await Navigator.push(
          ctx, pushManoeuver(StepFourConf(appstate: appstate)));
    }));

    widgets.add(model.profexp != 'Pas d\'expérience'
        ? stepwidget(
            context,
            "Expérience Professionelle",
            model.company,
            model.jobtags,
            model.period1 + " - " + model.period2,
            null, callback: (ctx) async {
            await Navigator.push(
                ctx, pushManoeuver(StepTwoConf(appstate: appstate)));
          })
        : stepwidget(context, "Expérience Professionelle", null, null, null,
            model.profexp, callback: (ctx) async {
            await Navigator.push(
                ctx, pushManoeuver(StepTwoConf(appstate: appstate)));
          }));

    (model.projectduration1 != null)
        ? widgets.add(stepwidget(
            context,
            "Projets Majeurs",
            model.projectname,
            model.projectrole,
            model.projectduration1 + " - " + model.projectduration2,
            model.projectdescription))
        : widgets.add(stepwidget(context, "Projets Majeurs", model.projectname,
            model.projectrole, "", model.projectdescription));

    widgets.add(stepwidget(
        context,
        "Education",
        model.school,
        model.degree + " " + model.major,
        model.timeframe,
        model.schoolachievement, callback: (ctx) async {
      await Navigator.push(
          ctx, pushManoeuver(StepThreeConf(appstate: appstate)));
    }));

    widgets.add(stepwidget(
        context, "Page social media", model.socialmedia, null, null, null,
        callback: (ctx) async {
      final result = await Navigator.push(
          ctx,
          pushManoeuver(FieldWriter(
            title: "Page Réseaux Sociaux",
            hint: "https://github.com/aucxence/",
            validateFn: (email) => RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(email),
          )));
      model.updateSocialMedia(result);
      appstate.updateUser(model);
    }));

    widgets.add(stepwidget(
        context, "Certifications", model.certifications, null, null, null,
        callback: (ctx) async {
      final result = await Navigator.push(ctx,
          pushManoeuver(DesiredAreas(collection: "careers", selectable: 3)));
      model.updateCertifications(result);
      appstate.updateUser(model);
    }));

    return widgets;
  }

  _validersuivant() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RootScene()));
  }
}
