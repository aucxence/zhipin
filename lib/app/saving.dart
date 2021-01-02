import 'dart:io';

import 'package:my_zhipin_boss/RegistrationModel.dart';
import 'package:my_zhipin_boss/login/ui/login.dart';
import 'package:my_zhipin_boss/login/ui/sms_code.dart';
import 'package:my_zhipin_boss/login/ui/login_page.dart';
import 'package:my_zhipin_boss/registration/ability_finder.dart';
import 'package:my_zhipin_boss/registration/bilan_resume.dart';
import 'package:my_zhipin_boss/registration/category_finder.dart';
import 'package:my_zhipin_boss/registration/confirmation/step_one_conf.dart';
import 'package:my_zhipin_boss/registration/desired_areas.dart';
import 'package:my_zhipin_boss/registration/item_completer.dart';
import 'package:my_zhipin_boss/registration/my_advantage.dart';
import 'package:my_zhipin_boss/registration/step_four.dart';
import 'package:my_zhipin_boss/registration/step_one.dart';
import 'package:my_zhipin_boss/registration/step_three.dart';
import 'package:my_zhipin_boss/registration/step_two.dart';
import 'package:my_zhipin_boss/registration/work_descriptor.dart';
import 'package:my_zhipin_boss/swipe/swipe_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './root_scene.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  List<String> device;
  bool internetcheck = false;
  var registrationmodel = new RegistrationModel();

  @override
  void initState() async {
    super.initState();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firsttime = prefs.getBool('firsttime');
    String who = prefs.getString('who');

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (who != null) {
          // somebody is logged in
          var snapshot = Firestore.instance
              .collection("careers")
              .where("id", isEqualTo: who)
              .snapshots();
          // .first.then((x) { à faire plus tard
          //   x.
          // });

          // I need to get that users info then navigate to rootSchene

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => RootScene()),
              //MaterialPageRoute(builder: (context)=>LoginPage()),
              //MaterialPageRoute(builder: (context)=>SwipeScreen()),
              //MaterialPageRoute(builder: (context)=> PhoneAuthLogin()),
              //MaterialPageRoute(builder: (context)=> SmsCode()),
              //MaterialPageRoute(builder: (context)=> StepOne()),
              // MaterialPageRoute(builder: (context)=> StepTwo()),
              // MaterialPageRoute(builder: (context)=> StepThree()),
              //MaterialPageRoute(builder: (context)=> ItemCompleter(title: "Nom de l'entreprise", hint: "Svp entrez le nom de l'entreprise", collection: "companylist")),
              //MaterialPageRoute(builder: (context)=> CategoryFinder(title: "Catégorie", hint: "Svp entrez la catégorie de l'entreprise", collection: "fieldareas",)),
              //MaterialPageRoute(builder: (context)=> AbilityFinder(collection: "fieldareas", field: "LOCAZONE")),
              //MaterialPageRoute(builder: (context)=> WorkDescriptor()),
              // MaterialPageRoute(builder: (context)=> AdvantageDescriptor()),
              // MaterialPageRoute(builder: (context)=> OverallResume()),
              // MaterialPageRoute(builder: (context)=> ScopedModel(
              //   model: registrationmodel,
              //   child: StepOneConfirmation()
              // )),
              // MaterialPageRoute(
              //   builder: (context) => ScopedModel(
              //       model: new RegistrationModel(), child: StepOne()),
              // ),
              (route) => route == null);

          snapshot.isEmpty.then((nonempty) {
            print("- internetcheck: " + internetcheck.toString());
            print("- non vide: " + nonempty.toString());
            bool empty = !nonempty;
            internetcheck // if internet connection is available
                ? (empty)
                    ? // new customer

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => RootScene()),
                        //MaterialPageRoute(builder: (context)=>LoginPage()),
                        //MaterialPageRoute(builder: (context)=>SwipeScreen()),
                        //MaterialPageRoute(builder: (context)=> PhoneAuthLogin()),
                        //MaterialPageRoute(builder: (context)=> SmsCode()),
                        //MaterialPageRoute(builder: (context)=> StepOne()),
                        // MaterialPageRoute(builder: (context)=> StepTwo()),
                        // MaterialPageRoute(builder: (context)=> StepThree()),
                        //MaterialPageRoute(builder: (context)=> ItemCompleter(title: "Nom de l'entreprise", hint: "Svp entrez le nom de l'entreprise", collection: "companylist")),
                        //MaterialPageRoute(builder: (context)=> CategoryFinder(title: "Catégorie", hint: "Svp entrez la catégorie de l'entreprise", collection: "fieldareas",)),
                        //MaterialPageRoute(builder: (context)=> AbilityFinder(collection: "fieldareas", field: "LOCAZONE")),
                        //MaterialPageRoute(builder: (context)=> WorkDescriptor()),
                        // MaterialPageRoute(builder: (context)=> AdvantageDescriptor()),
                        // MaterialPageRoute(builder: (context)=> OverallResume()),
                        // MaterialPageRoute(builder: (context)=> ScopedModel(
                        //   model: registrationmodel,
                        //   child: StepOneConfirmation()
                        // )),
                        // MaterialPageRoute(
                        //   builder: (context) => ScopedModel(
                        //       model: new RegistrationModel(), child: StepOne()),
                        // ),
                        (route) => route == null)
                    : Navigator.of(context).pushAndRemoveUntil(
                        // MaterialPageRoute(builder: (context) => RootScene()),
                        //MaterialPageRoute(builder: (context)=>LoginPage()),
                        MaterialPageRoute(builder: (context) => SwipeScreen()),
                        //MaterialPageRoute(builder: (context)=> PhoneAuthLogin()),
                        //MaterialPageRoute(builder: (context)=> SmsCode()),
                        //MaterialPageRoute(builder: (context)=> StepOne()),
                        // MaterialPageRoute(builder: (context)=> StepTwo()),
                        // MaterialPageRoute(builder: (context)=> StepThree()),
                        //MaterialPageRoute(builder: (context)=> ItemCompleter(title: "Nom de l'entreprise", hint: "Svp entrez le nom de l'entreprise", collection: "companylist")),
                        //MaterialPageRoute(builder: (context)=> CategoryFinder(title: "Catégorie", hint: "Svp entrez la catégorie de l'entreprise", collection: "fieldareas",)),
                        //MaterialPageRoute(builder: (context)=> AbilityFinder(collection: "fieldareas", field: "LOCAZONE")),
                        //MaterialPageRoute(builder: (context)=> WorkDescriptor()),
                        // MaterialPageRoute(builder: (context)=> AdvantageDescriptor()),
                        // MaterialPageRoute(builder: (context) => DesiredAreas(collection: "careers")),
                        (route) => route == null)
                : AlertDialog(
                    title: Text("Accès Internet"),
                    content: Text(
                        "Vérifiez votre accès internet pour vous connecter à l'application"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Fermer"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  );
          });
        } else {
          if (firsttime) {
            Navigator.of(context).pushAndRemoveUntil(
                // MaterialPageRoute(builder: (context) => RootScene()),
                //MaterialPageRoute(builder: (context)=>LoginPage()),
                MaterialPageRoute(builder: (context) => SwipeScreen()),
                //MaterialPageRoute(builder: (context)=> PhoneAuthLogin()),
                //MaterialPageRoute(builder: (context)=> SmsCode()),
                //MaterialPageRoute(builder: (context)=> StepOne()),
                // MaterialPageRoute(builder: (context)=> StepTwo()),
                // MaterialPageRoute(builder: (context)=> StepThree()),
                //MaterialPageRoute(builder: (context)=> ItemCompleter(title: "Nom de l'entreprise", hint: "Svp entrez le nom de l'entreprise", collection: "companylist")),
                //MaterialPageRoute(builder: (context)=> CategoryFinder(title: "Catégorie", hint: "Svp entrez la catégorie de l'entreprise", collection: "fieldareas",)),
                //MaterialPageRoute(builder: (context)=> AbilityFinder(collection: "fieldareas", field: "LOCAZONE")),
                //MaterialPageRoute(builder: (context)=> WorkDescriptor()),
                // MaterialPageRoute(builder: (context)=> AdvantageDescriptor()),
                // MaterialPageRoute(builder: (context) => DesiredAreas(collection: "careers")),
                (route) => route == null);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                // MaterialPageRoute(builder: (context) => RootScene()),
                //MaterialPageRoute(builder: (context)=>LoginPage()),
                // MaterialPageRoute(builder: (context) => SwipeScreen()),
                MaterialPageRoute(builder: (context) => PhoneAuthLogin()),
                //MaterialPageRoute(builder: (context)=> SmsCode()),
                //MaterialPageRoute(builder: (context)=> StepOne()),
                // MaterialPageRoute(builder: (context)=> StepTwo()),
                // MaterialPageRoute(builder: (context)=> StepThree()),
                //MaterialPageRoute(builder: (context)=> ItemCompleter(title: "Nom de l'entreprise", hint: "Svp entrez le nom de l'entreprise", collection: "companylist")),
                //MaterialPageRoute(builder: (context)=> CategoryFinder(title: "Catégorie", hint: "Svp entrez la catégorie de l'entreprise", collection: "fieldareas",)),
                //MaterialPageRoute(builder: (context)=> AbilityFinder(collection: "fieldareas", field: "LOCAZONE")),
                //MaterialPageRoute(builder: (context)=> WorkDescriptor()),
                // MaterialPageRoute(builder: (context)=> AdvantageDescriptor()),
                // MaterialPageRoute(builder: (context) => DesiredAreas(collection: "careers")),
                (route) => route == null);
          }
        }
      }
    });

    internetcheck =
        (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
    _controller.forward();

    // getDeviceDetails().then((value) {
    //   device = value;
    //   print("+++++++++++++++++++++++++++++++ " + device[0]);
    //   print("+++++++++++++++++++++++++++++++ " + device[1]);
    //   print("+++++++++++++++++++++++++++++++ " + device[2]);
    // }).then((onValue) {
    //   Connectivity().checkConnectivity().then((val) {
    //     internetcheck = (val != ConnectivityResult.none);
    //   }).then((onValue) {
    //     //播放动画
    //     _controller.forward();
    //   });
    // });
  }

  static Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } catch (e) {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Image.asset('assets/images/bg_app_splash.jpg',
          scale: 2.0, fit: BoxFit.cover),
    );
  }
}
