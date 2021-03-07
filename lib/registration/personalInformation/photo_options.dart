import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';

Widget photoOptions(List<Function> photocallbacks,
    List<String> photooptionsnames, Animation<Offset> offset) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
          position: offset,
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(475),
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(30),
                      horizontal: ScreenUtil().setWidth(20)),
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
                                    fontSize: ScreenUtil().setSp(30))),
                          ),
                        ),
                      );
                    },
                  )))));
}
