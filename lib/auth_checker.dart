import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/root_scene.dart';
import 'package:my_zhipin_boss/bossRegistration/boss_step_one.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/login/ui/email_verification.dart';
import 'package:my_zhipin_boss/login/ui/login.dart';
import 'package:my_zhipin_boss/models/boss.dart';
import 'package:my_zhipin_boss/registration/step_one.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/swipe/swipe_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthChecker extends StatelessWidget {
  Widget userStreamBuilder(UserDaoService dao) {
    return StreamBuilder<DocumentSnapshot>(
      stream: dao.getUser(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.exists) {
          var user = snapshot.data.data;

          if (user['completedSubscription'] == false) {
            print(user);
            try {
              if (user.containsKey('type')) {
                if (user['type'] == true) {
                  return new ScopedModel<User>(
                      child: StepOne(), model: new User());
                } else {
                  return new ScopedModel<Boss>(
                      child: BossStepOne(), model: new Boss());
                }
              } else {
                return new SwipeScreen();
              }
            } catch (e) {
              print(e);
              return new SwipeScreen();
            }
          } else {
            return RootScene();
          }
        } else if (snapshot.hasError) {
          print('-----');
          return PhoneAuthLogin();
        } else {
          print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
          print(dao.user.uid);
          print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
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
      return StreamBuilder<FirebaseUser>(
        stream: dao.getFirebaseUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snap) {
          if (snap.hasData) {
            var fuser = snap.data;
            if (fuser.providerData[1].providerId == 'password') {
              if (fuser.isEmailVerified) {
                return userStreamBuilder(dao);
              } else {
                return MailVerification(email: fuser.email);
              }
            }
            if (fuser.providerData[1].providerId == 'phone') {
              return userStreamBuilder(dao);
            } else {
              // impossible scenario
              return Center(child: LinearProgressIndicator());
            }
          } else {
            // print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~');
            return PhoneAuthLogin();
          }
        },
      );
    });
  }
}
