import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget scrollingComponent(List<Widget> child, ScrollController controller) {
  return Container(
    padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(40),
        right: ScreenUtil().setWidth(40),
        top: ScreenUtil().setHeight(20),
        bottom: ScreenUtil().setHeight(150)),
    margin: EdgeInsets.symmetric(vertical: 0),
    child: SingleChildScrollView(
        controller: controller,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: child,
        )),
  );
}
