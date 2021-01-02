import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/ability_finder.dart';
import 'package:flutter/material.dart';

class ItemTag extends StatefulWidget {
  final String title;
  final bool selected;

  ItemTag({Key key, this.title, this.selected}) : super(key: key);

  @override
  _ItemTagState createState() => _ItemTagState();
}

class _ItemTagState extends State<ItemTag> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.all(Radius.circular(ScreenUtil().setHeight(10.0))),
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(15.0)),
        margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(20.0),
            bottom: ScreenUtil().setWidth(3.0)),
        decoration: BoxDecoration(
            color: widget.selected ? Colours.app_main : Color(0XffFFFFFF),
            border: Border.all(
                color: widget.selected ? Colours.app_main : Color(0XffD2D2D2),
                width: 1.0),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10.0)))),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(20),
            color: widget.selected ? Colors.black54 : Color(0Xff7B7B7B),
            //fontWeight: widget.selected ? FontWeight.bold: FontWeight.normal
          ),
        ),
      ),
    );
  }
}
