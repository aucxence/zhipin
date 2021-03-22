import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/login/ui/components/or_divider.dart';
import 'package:my_zhipin_boss/login/ui/components/rounded_input_field.dart';
import 'package:my_zhipin_boss/login/ui/components/social_icon.dart';
import 'package:my_zhipin_boss/login/ui/countries_page.dart';
import 'package:my_zhipin_boss/login/ui/components/rounded_password_field.dart';
import 'package:my_zhipin_boss/login/ui/sms_code.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

enum SignInProvider { mail, phone }

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
  String email = '', password = '';

  bool isEmailValid(String input) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(input);
  }

  bool isValidPassword(String input) {
    return (new RegExp("(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})")
            .hasMatch(input)) ||
        (new RegExp("(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})")
            .hasMatch(input));
  }

  var current_country = {
    'name': "Cameroon",
    'alpha2Code': "CM",
    'alpha3Code': "CMR",
    'callingCodes': "+237",
    'letter': "C"
  };

  var provider = SignInProvider.phone;

  static AnimationController control;
  static Animation<Offset> offset;

  bool suivant = false;

  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
    print(control.lastElapsedDuration);
    if (control.lastElapsedDuration != null) {
      control.dispose();
    }
    super.dispose();
  }

  Future<void> _sendCodeToPhoneNumber(UserDaoService dao, String phonenumber) {
    Function verificationCompleted = () {
      print(
          'Inside sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded');
    };

    Function verificationFailed = () {
      print('Phone number verification failed. Code. Message: ');
    };

    Function codeSent = () async {
      print("code sent to " + phonenumber);
      String smsCode = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SmsCode(
                phonenumber:
                    current_country['callingCodes'] + textcontrol.text),
          ));

      ScopedModel.of<AppState>(context).updateLoading(false);

      return smsCode;
    };

    Function codeAutoRetrievalTimeout = () {};

    return dao.sendCodeToPhoneNumber(phonenumber, 60, verificationCompleted,
        verificationFailed, codeSent, codeAutoRetrievalTimeout);
  }

  showToast(IconData icon, String message, num timeout) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SizedBox(
            width: 12.0,
          ),
          Text(message),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: timeout),
    );
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
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  (provider == SignInProvider.phone)
                      ? "Votre numéro de téléphone"
                      : "Votre e-mail et mot de passe",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(45), color: Colors.black),
                  textAlign: TextAlign.center),
              spacing(),
              (provider == SignInProvider.phone)
                  ? Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                                context,
                                PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (BuildContext context, _, __) {
                                      return CountryPage();
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
                            print(new Map<String, dynamic>.from(result));
                            if (result != null) {
                              current_country =
                                  new Map<String, String>.from(result);
                              print(current_country);
                              setState(() {
                                countrycode = current_country['callingCodes'];
                              });
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text(countrycode,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(30),
                                      color: Colors.black)),
                              SizedBox(
                                width: ScreenUtil().setWidth(10),
                              ),
                              Transform.rotate(
                                  angle: 3.1415926535897932 / 2,
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: Colors.black45,
                                    size: 20.0,
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Expanded(
                          child: TextField(
                            controller: textcontrol,
                            focusNode: focus,
                            style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                            onChanged: (value) {
                              if (value.length > 5) {
                                setState(() => suivant = true);
                              } else {
                                setState(() => suivant = false);
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Numéro de téléphone",
                              hintStyle:
                                  TextStyle(fontSize: ScreenUtil().setSp(30)),
                              contentPadding: EdgeInsets.only(
                                  // left: ScreenUtil().setWidth(150),
                                  // bottom: ScreenUtil().setHeight(50)
                                  ),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        )
                      ],
                    )
                  : RoundedInputField(
                      hintText: "Votre email",
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          suivant =
                              isEmailValid(value) && isValidPassword(password);
                        });
                      },
                      validationFn: isEmailValid),
              (provider == SignInProvider.phone)
                  ? Divider(
                      color: Colors.black45,
                    )
                  : RoundedPasswordField(
                      onChanged: (value) {
                        setState(() {
                          password = value;
                          print(isEmailValid(email));
                          print(isValidPassword(value));
                          suivant =
                              isEmailValid(email) && isValidPassword(value);
                        });
                      },
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
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(35),
                                color: Colors.white))),
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
              spacing(),
              // SizedBox(
              //                     height: ScreenUtil().setHeight(1334) * 0.03),
              OrDivider(),
              spacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocialIcon(
                    iconSrc: provider == SignInProvider.phone
                        ? "assets/images/login/email-1.svg"
                        : "assets/images/login/phone.svg",
                    press: () {
                      setState(() {
                        if (provider == SignInProvider.mail) {
                          email = '';
                          password = '';
                        } else {
                          textcontrol.text = '';
                        }
                        suivant = false;
                        provider = (provider == SignInProvider.mail)
                            ? SignInProvider.phone
                            : SignInProvider.mail;
                      });
                    },
                  ),
                  // SocialIcon(
                  //   iconSrc: "assets/images/login/facebook-logo.svg",
                  //   press: () {},
                  // ),
                  // SocialIcon(
                  //   iconSrc: "assets/images/login/yahoo.svg",
                  //   press: () {},
                  // ),
                ],
              ),
            ],
          ),
        ));

    wholeset.add(login);

    if (_firsttime && terms) {
      AsyncCallback rollout = () async {
        switch (control.status) {
          case AnimationStatus.completed:
            setState(() {
              terms = false;
            });
            return control.reverse();
            break;
          default:
        }
        setState(() {
          terms = false;
        });
        return Future.delayed(Duration(seconds: 0));
      };
      var barrier = <Widget>[
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
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(30),
                            bottom: ScreenUtil().setHeight(0),
                            left: ScreenUtil().setWidth(20),
                            right: ScreenUtil().setWidth(20)),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "S'il vous plait, lisez et agréez au contenu ci-bas",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: ScreenUtil().setSp(20)),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Text(
                              "Politique de respect des utilisateurs",
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: ScreenUtil().setSp(20)),
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
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(ScreenUtil().setSp(20)),
                                    child: Text("Retour",
                                        style: TextStyle(
                                            color: Colours.app_main,
                                            fontSize: ScreenUtil().setSp(20))),
                                  ),
                                ),
                                RaisedButton(
                                  onPressed: () async {
                                    // ScopedModel.of<AppState>(context)
                                    //     .updateLoading(true);

                                    UserDaoService dao =
                                        ScopedModel.of<AppState>(context).dao;
                                    await rollout();

                                    if (provider == SignInProvider.phone) {
                                      try {
                                        await _sendCodeToPhoneNumber(
                                            dao,
                                            current_country['callingCodes'] +
                                                textcontrol.text);
                                        print('-----------------------');
                                      } catch (error) {
                                        String errorMessage =
                                            dao.parseAuthError(error);
                                        this.showToast(Icons.no_encryption,
                                            errorMessage, 50);
                                        print(error);
                                      }

                                      // do nothing
                                    } else {
                                      try {
                                        print(email + ' - ' + password);
                                        var result = await dao.emailSignUp(
                                            email, password);
                                        await dao.sendVerificationEmail(result);
                                      } catch (error) {
                                        String errorMessage =
                                            dao.parseAuthError(error);
                                        this.showToast(Icons.no_encryption,
                                            errorMessage, 50);
                                        print(error);
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  color: Colours.app_main,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(ScreenUtil().setSp(20)),
                                    child: Text("Agréer et Continuer",
                                        style: TextStyle(
                                            color: Colours.text_white,
                                            fontSize: ScreenUtil().setSp(20))),
                                  ),
                                )
                              ],
                            )
                          ],
                        )))))
      ];

      wholeset.addAll(barrier);
    }

    return wholeset;
  }

  VoidCallback rollinout = () {};
}
