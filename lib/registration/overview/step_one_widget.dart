import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../user.dart';

Widget steponewidget(User user, callback) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: ListTile(
        onTap: callback,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
              child: Text(
                user.nom + ' ' + user.prenom,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(35),
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(width: ScreenUtil().setWidth(20)),
            Transform.scale(
                scale: 0.8,
                child:
                    Image.asset("assets/images/icon/ic_action_share_black.png"))
          ],
        ),
        subtitle: Text(
          user.degree +
              ' - ' +
              user.expectedstatus +
              ' - prospection salariale: ' +
              user.expectedmoney,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(25), color: Colors.black54),
        ),
        trailing: CircleAvatar(
          radius: ScreenUtil().setWidth(ScreenUtil().setHeight(150.0)),
          backgroundImage: AssetImage(user.pic),
        ),
      ));
}
