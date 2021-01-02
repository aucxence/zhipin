import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/login/ui/sms_code.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneAuthLogin extends StatefulWidget {
  @override
  _PhoneAuthLoginState createState() => _PhoneAuthLoginState();
}

class _PhoneAuthLoginState extends State<PhoneAuthLogin>
    with SingleTickerProviderStateMixin {
  var countrycode = "+237";
  bool _firsttime = false, terms = false;
  var focus = new FocusNode();
  var textcontrol = new TextEditingController();

  static AnimationController control;
  static Animation<Offset> offset;

  bool suivant = false;

  @override
  void initState() {
    super.initState();
    control =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    var statuslistener = (status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          terms = false;
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: Stack(children: stackmanager()),
    );
  }

  Widget spacing() {
    return SizedBox(height: ScreenUtil().setHeight(100));
  }

  List<Widget> stackmanager() {
    List<Widget> wholeset = [];

    var login = Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(40),
            vertical: ScreenUtil().setHeight(150)),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Votre numéro de téléphone",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(50), color: Colors.black)),
            spacing(),
            Stack(
              children: <Widget>[
                TextField(
                  controller: textcontrol,
                  focusNode: focus,
                  onChanged: (value) {
                    if (value.length > 0) {
                      setState(() => suivant = true);
                    } else {
                      setState(() => suivant = false);
                    }
                  },
                  decoration: InputDecoration(
                      hintText: "Saisissez ici",
                      contentPadding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(150),
                          bottom: ScreenUtil().setHeight(50)),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87))),
                  keyboardType: TextInputType.number,
                ),
                Positioned(
                    left: 0,
                    bottom: ScreenUtil().setHeight(23),
                    child: DropdownButton<String>(
                        iconEnabledColor: Colors.black,
                        value: countrycode,
                        underline: Container(color: Colors.white),
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(35),
                            color: Colors.black45),
                        onChanged: (String newValue) => countrycode = newValue,
                        items: <String>['+237', '+235']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList()))
              ],
            ),
            spacing(),
            GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(20)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(05.0),
                      color: suivant ? Colours.app_main : Colors.black45),
                  child: Center(
                      child: Text("Suivant",
                          style: TextStyle(fontSize: ScreenUtil().setSp(35)))),
                  //color: Colours.app_main
                ),
                onTap: () {
                  if (suivant) {
                    setState(() {
                      _firsttime = true;
                      terms = true;
                    });
                    if (_firsttime) {
                      switch (control.status) {
                        case AnimationStatus.completed:
                          control.reverse();
                          break;
                        case AnimationStatus.dismissed:
                          focus.unfocus();
                          control.forward();
                          break;
                        default:
                      }
                    }
                  }
                }),
          ],
        ));

    wholeset.add(login);

    if (_firsttime && terms) {
      VoidCallback rollout = () {
        switch (control.status) {
          case AnimationStatus.completed:
            control.reverse();
            break;
          default:
        }
        setState(() {
          terms = false;
        });
      };
      var barrier = Stack(children: <Widget>[
        new ModalBarrier(color: Colors.black26),
        new Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
                position: offset,
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(300),
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(30),
                            horizontal: ScreenUtil().setWidth(20)),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "S'il vous plait, lisez et agréez au contenu ci-bas",
                              style: TextStyle(color: Colors.black54),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                              "Politique de respect des utilisateurs",
                              style: TextStyle(color: Colors.black26),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    switch (control.status) {
                                      case AnimationStatus.completed:
                                        control.reverse();
                                        break;
                                      default:
                                    }

                                    //control.removeStatusListener(statuslistener);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: Colors.white,
                                  child: Text("Retour",
                                      style:
                                          TextStyle(color: Colours.app_main)),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SmsCode(
                                            phonenumber:
                                                "+237" + textcontrol.text,
                                            callback: rollout,
                                          ),
                                        ));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: Colours.app_main,
                                  child: Text("Agréer et Continuer",
                                      style:
                                          TextStyle(color: Colours.text_white)),
                                )
                              ],
                            )
                          ],
                        )))))
      ]);

      wholeset.add(barrier);
    }

    return wholeset;
  }

  VoidCallback rollinout = () {};
}
