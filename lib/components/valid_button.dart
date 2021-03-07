import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/app/app_color.dart';

Widget validationButton(bool suivant, VoidCallback validersuivant) {
  return Positioned(
    bottom: ScreenUtil().setHeight(1),
    right: ScreenUtil().setWidth(15),
    left: ScreenUtil().setWidth(15),
    child: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(05.0),
              color: suivant ? Colours.app_main : Colors.black45),
          child: Center(
              child: Text("Suivant",
                  style: TextStyle(fontSize: ScreenUtil().setSp(35)))),
          //color: Colours.app_main
        ),
        onTap: () => validersuivant()),
  );
}
