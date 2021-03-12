import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';

Widget photoOptions(
    List<Function> photocallbacks, List<String> photooptionsnames) {
  return Container(
      width: double.infinity,
      alignment: Alignment.center,
      height: ScreenUtil().setHeight(475),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(50),
          horizontal: ScreenUtil().setWidth(20)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: ListView.separated(
        itemCount: photocallbacks.length,
        separatorBuilder: (context, index) {
          return pagedivider(ScreenUtil().setHeight(30));
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(20),
            ),
            child: GestureDetector(
              onTap: photocallbacks[index],
              child: Center(
                child: Text(photooptionsnames[index],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: ScreenUtil().setSp(30),
                        decoration: TextDecoration.none)),
              ),
            ),
          );
        },
      ));
}
