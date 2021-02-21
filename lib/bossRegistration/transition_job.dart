import 'package:flutter/material.dart';
import 'package:my_zhipin_boss/JobRegistrationModel.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/bossRegistration/boss_step_two.dart';
import 'package:scoped_model/scoped_model.dart';

class TransitionToJob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/assistant-1-0-0.3.gif'),
                fit: BoxFit.contain),
            color: Colours.app_main),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BossStepTwo(),
                  ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.yellow),
                child: Text(
                  'Poster l\'offre d\'emploi',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
          ),
        ),
      ),
    );
  }
}
