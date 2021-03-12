import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:math' as math;

Widget frameComponent(context, validersuivant, child, suivant,
    {validationlabel}) {
  return Scaffold(
    appBar: AppBar(
      leading: Transform.rotate(
          angle: math.pi,
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.redAccent,
            onPressed: () {
              UserDaoService dao = ScopedModel.of<AppState>(context).dao;
              dao.signOut();
            },
          )),
      actions: <Widget>[
        GestureDetector(
            onTap: () => validersuivant(),
            child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: Center(
                    child: Text(validationlabel ?? "Suivant",
                        style: TextStyle(
                          color: suivant ? Colours.app_main : Colors.black45,
                          fontSize: ScreenUtil().setSp(30),
                        )))))
      ],
    ),
    body: Stack(
      children: child,
    ),
  );
}
