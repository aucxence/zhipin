import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/app/app_color.dart';

Widget basicdropdown(bool value, void Function(bool) onChanged) {
  return Column(
    children: <Widget>[
      Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10.0)),
          child: Text(
            "Etes-vous déjà entré dans le monde professionel?",
            style: TextStyle(color: Colors.black),
            overflow: TextOverflow.fade,
          )),
      DropdownButton<bool>(
          isExpanded: true,
          iconEnabledColor: Colors.black45,
          value: value,
          underline: Container(color: Colors.white),
          style: TextStyle(color: Colours.app_main),
          selectedItemBuilder: (BuildContext context) {
            return <bool>[false, true].map((bool value) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    value == true ? 'Oui' : 'Non',
                    style: TextStyle(color: Colours.app_main),
                  ),
                ],
              );
            }).toList();
          },
          onChanged: onChanged,
          items: <bool>[false, true].map<DropdownMenuItem<bool>>((bool value) {
            return DropdownMenuItem(
                value: value,
                child: Text(
                  value ? "Oui" : "Non",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: ScreenUtil().setSp(30),
                  ),
                ));
          }).toList())
    ],
  );
}
