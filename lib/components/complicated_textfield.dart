import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/app/app_color.dart';

Widget complicatedTextField(
    String label, String hint, bool changecolor, VoidCallback callback) {
  return GestureDetector(
      onTap: callback,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(25), color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  hint,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(30),
                      color: changecolor ? Colours.app_main : Colors.black54),
                  overflow: TextOverflow.ellipsis,
                )),
                GestureDetector(
                  onTap: callback,
                  child: Transform.scale(
                      scale: 0.5,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: changecolor ? Colors.black45 : Colours.app_main,
                      )),
                ),
              ],
            )
          ],
        ),
      ));
}
