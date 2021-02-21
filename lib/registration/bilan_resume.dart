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
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

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
                onTap: () => _validersuivant(),
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(20)),
                    child: Center(
                        child: Text("Confirmer",
                            style: TextStyle(
                              color: Colours.app_main,
                              fontSize: ScreenUtil().setSp(30),
                            )))))
          ],
        ),
        body: Stack(children: stackmanager()));
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

    var button = Positioned(
      bottom: ScreenUtil().setHeight(20),
      right: ScreenUtil().setWidth(20),
      left: ScreenUtil().setWidth(20),
      child: GestureDetector(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(05.0),
                color: Colours.app_main),
            child: Center(
                child: Text("Confirmer",
                    style: TextStyle(fontSize: ScreenUtil().setSp(35)))),
            //color: Colours.app_main
          ),
          onTap: () {}),
    );

    wholeset.add(button);

    return wholeset;
  }

  List<Widget> getWidgetColumn() {
    User model = ScopedModel.of<User>(context);

    var widgets = <Widget>[];

    print("1. nom: ${model.nom}");
    print("2. Prenom: ${model.prenom}");
    print("3. Pic: ${model.pic}");
    print("4. ExpectedJob: ${model.expectedjob}");
    print("5. Expectedmoney: ${model.expectedmoney}");

    widgets.add(_steponewidget(model.nom + " " + model.prenom, model.profexp,
        model.birth, model.degree, model.pic, () async {
      final result = Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScopedModel<User>(
                  model: model, child: StepOneConfirmation())));
      if (result != null) print("Modification effectuée");
    }));

    widgets.add(_stepwidget("Atouts", null, null, null, model.advantage));

    widgets.add(_stepwidget("Ambition Professionelle", model.expectedjob,
        model.expectedmoney, model.expectedcareer, null));

    widgets.add(_stepwidget("Expérience Professionelle", model.company,
        model.jobtags, model.period1 + " - " + model.period2, null));

    (model.projectduration1 != null)
        ? widgets.add(_stepwidget(
            "Expérience des projets",
            model.projectname,
            model.projectrole,
            model.projectduration1 + " - " + model.projectduration2,
            model.projectdescription))
        : widgets.add(_stepwidget("Expérience des projets", model.projectname,
            model.projectrole, "", model.projectdescription));

    widgets.add(_stepwidget(
        "Education",
        model.school,
        model.degree + " " + model.major,
        model.timeframe,
        model.schoolachievement));

    widgets.add(
        _stepwidget("Page social media", model.socialmedia, null, null, null));

    widgets.add(
        _stepwidget("Certifications", model.certifications, null, null, null));

    return widgets;
  }

  Widget _steponewidget(name, experience, age, degree, avatarimage, callback) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        child: ListTile(
          onTap: callback,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(width: ScreenUtil().setWidth(20)),
              Transform.scale(
                  scale: 0.8,
                  child: Image.asset(
                      "assets/images/icon/ic_action_share_black.png"))
            ],
          ),
          subtitle: Text(
            name + " " + degree,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(25), color: Colors.black54),
          ),
          trailing: CircleAvatar(
            radius: ScreenUtil().setWidth(ScreenUtil().setHeight(150.0)),
            backgroundImage: AssetImage(avatarimage),
          ),
        ));
  }

  _validersuivant() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RootScene()));
  }

  Widget _stepwidget(
      var step, var firstinfo, var secondinfo, var thirdinfo, var fourthinfo) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
            child: Text(
              step,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(35),
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          (firstinfo != null)
              ? Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(30)),
                  child: ListTile(
                    title: (firstinfo != null)
                        ? Text(
                            firstinfo,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(25),
                                color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          )
                        : SizedBox.shrink(),
                    subtitle: (secondinfo != null)
                        ? Text(
                            secondinfo,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(20),
                                color: Colors.black54),
                          )
                        : SizedBox.shrink(),
                    trailing: (thirdinfo != null)
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(15.0)),
                                child: Text(
                                  thirdinfo,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      color: Colors.black54),
                                ),
                              ),
                              Transform.scale(
                                  scale: 0.5,
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.black54)),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                )
              : Container(),
          (fourthinfo != null)
              ? ListTile(
                  // padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                  // alignment: Alignment.left,
                  title: Text(
                    fourthinfo,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.black54),
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : SizedBox.shrink(),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          OutlineButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(05)),
            onPressed: () {},
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Changer " + step,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(30), color: Colors.black45),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            borderSide:
                BorderSide(color: Colors.black12, style: BorderStyle.solid),
          )
        ],
      ),
    );
  }
}
