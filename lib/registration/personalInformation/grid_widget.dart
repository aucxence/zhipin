import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget gridwidget(Function gridwidgetcallback, Animation<Offset> offset) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
          position: offset,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: double.infinity,
                height: ScreenUtil().setHeight(400),
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(30),
                    horizontal: ScreenUtil().setWidth(20)),
                child: GridView.builder(
                  itemCount: 8,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    var j = index + 1;
                    return GestureDetector(
                      onTap: gridwidgetcallback(j),
                      child: Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: ScreenUtil()
                              .setWidth(ScreenUtil().setHeight(150.0)),
                          backgroundImage: AssetImage(
                              "assets/images/avatars/avatar" +
                                  j.toString() +
                                  ".png"),
                        ),
                      ),
                    );
                  },
                ),
              ))));
}
