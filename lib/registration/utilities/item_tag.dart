import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/utilities/ability_finder.dart';
import 'package:flutter/material.dart';

class ItemTag extends StatefulWidget {
  final String title;
  final AbilityFinderState status;
  final Function addItem, removeItem;

  ItemTag({Key key, this.title, this.status, this.addItem, this.removeItem})
      : super(key: key);

  @override
  _ItemTagState createState() => _ItemTagState();
}

class _ItemTagState extends State<ItemTag> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (selected) {
            widget.removeItem(widget);
            widget.status.abilities.removeWhere((item) {
              print(item);
              return item == widget.title;
            });
            setState(() {
              widget.status.selectable += 1;
              selected = !selected;
            });
          } else {
            if (widget.status.selectable > 0) {
              widget.addItem(widget);
              widget.status.abilities.add(widget.title);
              setState(() {
                widget.status.selectable -= 1;
                selected = !selected;
              });
            } else {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Choisissez 3 domaines de compétences'),
                duration: Duration(seconds: 1),
              ));
            }
          }
          //print(widget.status.selectedtags.toString());
        },
        child: ClipRRect(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setHeight(10.0))),
          child: Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(15.0)),
            margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(20.0),
                bottom: ScreenUtil().setWidth(3.0)),
            decoration: BoxDecoration(
                color: selected && (widget.status.selectable >= 0)
                    ? Colours.app_main
                    : Color(0XffFFFFFF),
                border: Border.all(color: Colours.app_main, width: 1.0),
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(10.0)))),
            child: Text(
              widget.title,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  color: selected && (widget.status.selectable >= 0)
                      ? Colors.black54
                      : Colours.app_main),
            ),
          ),
        ));
  }
}
