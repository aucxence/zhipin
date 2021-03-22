import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/app/app_color.dart';

Widget datepicker(
    String label, String hint, bool changecolor, VoidCallback callback) {
  return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10.0)),
        //color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(25),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(hint,
                    style: TextStyle(
                      color: changecolor ? Colours.app_main : Colors.black54,
                      fontSize: ScreenUtil().setSp(30),
                    )),
                GestureDetector(
                  onTap: callback,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: ScreenUtil().setSp(25),
                    color: changecolor ? Colors.black45 : Colours.app_main,
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}
