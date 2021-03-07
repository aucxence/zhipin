import 'dart:io';

import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/auth_checker.dart';
import 'package:my_zhipin_boss/bossRegistration/boss_step_one.dart';
import 'package:my_zhipin_boss/bossRegistration/boss_step_two.dart';
import 'package:my_zhipin_boss/load_checker.dart';
import 'package:my_zhipin_boss/login/ui/countries_page.dart';
import 'package:my_zhipin_boss/login/ui/login.dart';
import 'package:my_zhipin_boss/login/ui/sms_code.dart';
import 'package:my_zhipin_boss/login/ui/login_page.dart';
import 'package:my_zhipin_boss/models/boss.dart';
import 'package:my_zhipin_boss/models/init.dart';
import 'package:my_zhipin_boss/registration/utilities/ability_finder.dart';
import 'package:my_zhipin_boss/registration/overview/bilan_resume.dart';
import 'package:my_zhipin_boss/registration/utilities/category_finder.dart';
import 'package:my_zhipin_boss/registration/confirmation/step_one_conf.dart';
import 'package:my_zhipin_boss/registration/utilities/desired_areas.dart';
import 'package:my_zhipin_boss/registration/utilities/item_completer.dart';
import 'package:my_zhipin_boss/registration/Edge/my_advantage.dart';
import 'package:my_zhipin_boss/registration/expectations/step_four.dart';
import 'package:my_zhipin_boss/registration/personalInformation/step_one.dart';
import 'package:my_zhipin_boss/registration/academics/step_three.dart';
import 'package:my_zhipin_boss/registration/professionals/step_two.dart';
import 'package:my_zhipin_boss/registration/utilities/work_descriptor.dart';
import 'package:my_zhipin_boss/swipe/swipe_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './root_scene.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  List<String> device;
  bool internetcheck = false;
  var registrationmodel = new User();

  preparation() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var user = json.decode(prefs.get('user'));
    // Init init = Init.fromJson(user);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushAndRemoveUntil(
            // MaterialPageRoute(builder: (context) => RootScene()),
            // MaterialPageRoute(builder: (context) => LoginPage()),
            // MaterialPageRoute(builder: (context)=>SwipeScreen()),
            // MaterialPageRoute(builder: (context) => PhoneAuthLogin()),
            // MaterialPageRoute(builder: (context) => CountryPage()),
            // MaterialPageRoute(builder: (context)=> SmsCode()),
            // MaterialPageRoute(builder: (context)=> StepOne()),
            // MaterialPageRoute(builder: (context)=> StepTwo()),
            // MaterialPageRoute(builder: (context)=> StepThree()),
            // MaterialPageRoute(builder: (context)=> ItemCompleter(title: "Nom de l'entreprise", hint: "Svp entrez le nom de l'entreprise", collection: "companylist")),
            // MaterialPageRoute(builder: (context)=> CategoryFinder(title: "Catégorie", hint: "Svp entrez la catégorie de l'entreprise", collection: "fieldareas",)),
            // MaterialPageRoute(builder: (context)=> AbilityFinder(collection: "fieldareas", field: "LOCAZONE")),
            // MaterialPageRoute(builder: (context)=> WorkDescriptor()),
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
            // (route) => route == null);
            // MaterialPageRoute(
            //     builder: (context) =>
            //         new ScopedModel(child: BossStepOne(), model: new Boss())),
            MaterialPageRoute(builder: (context) => LoadChecker()),
            (route) => route == null);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    preparation();

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation ?? 0,
      child: Image.asset('assets/images/bg_app_splash.jpg',
          scale: 2.0, fit: BoxFit.cover),
    );
  }
}
