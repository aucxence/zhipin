import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget stepwidget(var context, var step, var firstinfo, var secondinfo,
    var thirdinfo, var fourthinfo) {
  ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  return Container(
    margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(10)),
          child: Text(
            step,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(35),
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        (firstinfo != null)
            ? Container(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(0)),
                child: ListTile(
                  title: (firstinfo != null)
                      ? Text(
                          firstinfo,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(25),
                              color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        )
                      : SizedBox.shrink(),
                  subtitle: (secondinfo != null)
                      ? Text(
                          secondinfo,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(25),
                              color: Colors.black54),
                        )
                      : SizedBox.shrink(),
                  trailing: (thirdinfo != null)
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(15.0)),
                              width: ScreenUtil().setWidth(250),
                              child: Text(
                                thirdinfo,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    color: Colors.black54),
                              ),
                            ),
                            Transform.scale(
                                scale: 0.5,
                                child: Icon(Icons.arrow_forward_ios,
                                    color: Colors.black54)),
                          ],
                        )
                      : SizedBox.shrink(),
                ),
              )
            : Container(),
        (fourthinfo != null)
            ? ListTile(
                // padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                // alignment: Alignment.left,
                title: Text(
                  fourthinfo,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(25), color: Colors.black54),
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : SizedBox.shrink(),
        SizedBox(
          height: ScreenUtil().setHeight(25),
        ),
        OutlineButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(05)),
          onPressed: () {},
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Text(
                "Changer " + step,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(30), color: Colors.black45),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          borderSide:
              BorderSide(color: Colors.black12, style: BorderStyle.solid),
        )
      ],
    ),
  );
}
