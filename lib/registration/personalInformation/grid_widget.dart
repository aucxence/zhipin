import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget gridwidget(Function gridwidgetcallback) {
  return Container(
    width: double.infinity,
    height: ScreenUtil().setHeight(400),
    padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(30),
        horizontal: ScreenUtil().setWidth(20)),
    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white),
    child: GridView.builder(
      itemCount: 8,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        var j = index + 1;
        return GestureDetector(
          onTap: gridwidgetcallback(j),
          child: Container(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: ScreenUtil().setWidth(ScreenUtil().setHeight(150.0)),
              backgroundImage: AssetImage(
                  "assets/images/avatars/avatar" + j.toString() + ".png"),
            ),
          ),
        );
      },
    ),
  );
}
