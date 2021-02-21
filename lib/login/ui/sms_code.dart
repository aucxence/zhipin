import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:pin_view/pin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class SmsCode extends StatefulWidget {
  final String phonenumber;

  SmsCode({Key key, this.phonenumber}) : super(key: key);

  @override
  _SmsCodeState createState() => _SmsCodeState();
}

class _SmsCodeState extends State<SmsCode> with SingleTickerProviderStateMixin {
  bool computing = false, terms = false;
  var focus = new FocusNode();
  var textcontrol = new TextEditingController();
  var countdownseconds = 60;

  static AnimationController control;

  String smsCode;

  @override
  void dispose() {
    // TODO: implement dispose
    // super.dispose();
    control.dispose();
  }

  @override
  void initState() {
    super.initState();
    // widget.callback();
    control = AnimationController(
        vsync: this, duration: Duration(seconds: countdownseconds));

    control.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!computing) {}
      }
    });

    control.forward();

    print("++++++++++++++++++++++++ " + widget.phonenumber);
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
        child: SingleChildScrollView(
            child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Votre Code SMS secret",
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(50), color: Colors.black)),
            spacing(),
            Stack(
              children: <Widget>[
                PinView(
                  count: 6,
                  margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  autoFocusFirstField: true,
                  obscureText: false,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40.0),
                      fontWeight: FontWeight.w500),
                  dashStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(30.0), color: Colors.grey),
                  submit: (String smscode) {
                    ScopedModel.of<AppState>(context).updateLoading(true);
                    smsCode = smscode;
                    // dao.signInWithPhoneNumber(smsCode);
                    Navigator.pop(context, smsCode);
                  },
                ),
                /*Positioned(
                  left: 0,
                  child: Text(
                    "G-", 
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil().setSp(30)
                    ),
                  )
                )*/
              ],
            ),
            spacing(),
            new Container(
              child: new Center(
                child: new Countdown(
                  animation: new StepTween(
                    begin: countdownseconds,
                    end: 0,
                  ).animate(control),
                ),
              ),
            ),
            spacing(),
            GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(20)),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(05.0),
                      color: textcontrol.text.length < 1
                          ? Colors.black45
                          : Colours.app_main),
                  child: Center(
                      child: Text("Valider",
                          style: TextStyle(fontSize: ScreenUtil().setSp(35)))),
                  //color: Colours.app_main
                ),
                onTap: () {
                  // dao.signInWithPhoneNumber(smsCode);
                  // dao.signOut();
                  Navigator.pop(context, smsCode);
                }),
          ],
        )));

    wholeset.add(login);

    if (computing && terms) {
      var barrier = Stack(children: <Widget>[
        new ModalBarrier(color: Colors.black26),
      ]);

      wholeset.add(barrier);
    }

    return wholeset;
  }

  VoidCallback rollinout = () {};
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  build(BuildContext context) {
    return new Text(
      animation.value.toString(),
      style: new TextStyle(
          color: Colors.black45, fontSize: ScreenUtil().setSp(30.0)),
    );
  }
}
