import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/public.dart';

class ShowMoreText extends StatefulWidget {
  final String text;
  final int maxlines;

  ShowMoreText({Key key, @required this.text, this.maxlines}) : super(key: key);

  @override
  _ShowMoreTextState createState() => new _ShowMoreTextState();
}

class _ShowMoreTextState extends State<ShowMoreText> {
  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
      //padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: new Column(
        children: <Widget>[
          new Text(
            widget.text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: Color(0xFF8F8F8F),
              height: 1.5,
            ),
            maxLines: flag ? widget.maxlines : null,
            overflow: TextOverflow.fade,
          ),
          new InkWell(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  flag ? "Dérouler" : "Réduire",
                  style: new TextStyle(color: Colours.app_main),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }
}
