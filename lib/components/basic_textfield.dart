import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/app/app_color.dart';

Widget basictextfield(String hint, String label,
    TextEditingController controller, Function callback) {
  return TextField(
    controller: controller,
    autofocus: false,
    style: TextStyle(color: Colours.app_main),
    onChanged: callback,
    decoration: InputDecoration(
      //helperText: hint,
      hintText: hint,
      hintStyle:
          TextStyle(fontSize: ScreenUtil().setSp(30), color: Colors.black54),
      //labelText: label,
      labelStyle: TextStyle(color: Colors.black),
      border: InputBorder.none,
    ),
  );
}
