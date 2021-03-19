import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_zhipin_boss/registration/professionals/step_two.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/root_scene.dart';
import 'package:my_zhipin_boss/bossRegistration/boss_step_one.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/login/ui/email_verification.dart';
import 'package:my_zhipin_boss/login/ui/login.dart';
import 'package:my_zhipin_boss/models/boss.dart';
import 'package:my_zhipin_boss/registration/personalInformation/step_one.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/swipe/swipe_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthChecker extends StatelessWidget {
  Widget userStreamBuilder(UserDaoService dao) {
    return StreamBuilder<DocumentSnapshot>(
      stream: dao.getUser(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.exists) {
          var user = snapshot.data.data();

          if (user['completedSubscription'] == false) {
            // print(user);
            try {
              if (user.containsKey('type')) {
                if (user['type'] == true) {
                  return StepOne();
                } else {
                  return BossStepOne();
                }
              } else {
                return new SwipeScreen();
              }
            } catch (e) {
              // print(e);
              return new SwipeScreen();
            }
          } else {
            return RootScene();
          }
        } else if (snapshot.hasError) {
          // print('-----');
          return PhoneAuthLogin();
        } else {
          // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
          // print(dao.user.uid);
          // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
          // dao.signOut();
          // dao.delete();
          return PhoneAuthLogin();
        }
      },
    );
  }

  goTo(num timeout, Widget page) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: timeout), () => true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return page;
          } else {
            return Scaffold(
                backgroundColor: Colors.grey,
                body: Center(child: CircularProgressIndicator()));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(builder: (context, child, appstate) {
      UserDaoService dao = appstate.dao;
      return StreamBuilder<auth.User>(
        stream: dao.getFirebaseUser(),
        builder: (BuildContext context, AsyncSnapshot<auth.User> snap) {
          print('---> ');
          // return Center(child: CircularProgressIndicator());
          if (snap.hasData) {
            var fuser = snap.data;
            print(fuser.providerData[0] == null);
            if (fuser.providerData[0].providerId == 'password') {
              print(fuser.email + ' = ' + fuser.emailVerified.toString());
              // fuser.reload();
              if (fuser.emailVerified) {
                return userStreamBuilder(dao);
              } else {
                return MailVerification(email: fuser.email);
              }
              // aucxence@yahoo.fr
              // @ucXence1992
              // 671148125
            }
            if (fuser.providerData[0].providerId == 'phone') {
              print('yes man');
              return userStreamBuilder(dao);
            } else {
              // impossible scenario
              return Center(child: LinearProgressIndicator());
            }
          } else if (snap.hasError) {
            print(snap.error);
            return null;
          } else {
            // Spinning screens and login screens
            print('+++> ');
            bool auth = appstate.prefs.getBool('authenticated');
            if (auth == null)
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => PhoneAuthLogin()));
              return PhoneAuthLogin();
            else {
              return PhoneAuthLogin();
            }
          }
        },
      );
    });
  }
}
