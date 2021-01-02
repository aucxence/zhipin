import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_view/pin_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SmsCode extends StatefulWidget {
  final String phonenumber;
  final Function() callback;

  SmsCode({Key key, this.phonenumber, this.callback}) : super(key: key);

  @override
  _SmsCodeState createState() => _SmsCodeState();
}

class _SmsCodeState extends State<SmsCode> with SingleTickerProviderStateMixin {
  bool computing = false, terms = false;
  var focus = new FocusNode();
  var textcontrol = new TextEditingController();
  var countdownseconds = 60;
  String verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

  static AnimationController control;

  String smsCode;

  @override
  void initState() {
    super.initState();
    widget.callback();
    control = AnimationController(
        vsync: this, duration: Duration(seconds: countdownseconds));

    control.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!computing) {}
      }
    });

    _sendCodeToPhoneNumber();

    control.forward();

    print("++++++++++++++++++++++++ " + widget.phonenumber);
  }

  void _signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;

    print("Logged-in User: " + user.phoneNumber);
  }

  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      setState(() {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + widget.phonenumber);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };

    await auth.verifyPhoneNumber(
        phoneNumber: widget.phonenumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
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
                  submit: (String smsCode) {
                    this.smsCode = smsCode;
                    _signInWithPhoneNumber(smsCode);
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
                  _signInWithPhoneNumber(smsCode);
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
  Animation<int> animation;

  @override
  build(BuildContext context) {
    return new Text(
      animation.value.toString(),
      style: new TextStyle(
          color: Colors.black45, fontSize: ScreenUtil().setSp(30.0)),
    );
  }
}
