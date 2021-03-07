import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget pagedivider([num height]) {
  return new Divider(
    color: Colors.black45,
    height: height ?? ScreenUtil().setHeight(0),
  );
}
