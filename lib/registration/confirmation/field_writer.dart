import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/registration/utilities/currency_input_formatter.dart';

class FieldWriter extends StatefulWidget {
  final String title, hint;
  final bool inputformatter;
  final bool Function(String) validateFn;

  FieldWriter(
      {Key key, this.title, this.hint, this.inputformatter, this.validateFn})
      : super(key: key);

  @override
  _FieldWriterState createState() => _FieldWriterState();
}

class _FieldWriterState extends State<FieldWriter> {
  String namelength = "";
  TextEditingController textcontroller = new TextEditingController();

  bool suivant = false;

  var textlength = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black45,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(35), color: Colours.app_main),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: textcontroller.text.length == 0
                  ? Colors.black
                  : Colours.app_main,
            ),
            onPressed: () {
              if (textcontroller.text.length >= 0) {
                if (widget.validateFn != null) {
                  if (widget.validateFn(textcontroller.text)) {
                    Navigator.pop(context, textcontroller.text);
                  } else {}
                } else {
                  Navigator.pop(context, textcontroller.text);
                }
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(50),
            vertical: ScreenUtil().setHeight(20)),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                TextField(
                  controller: textcontroller,
                  autofocus: true,
                  onChanged: (value) {
                    print("---- " + textcontroller.text);
                    setState(() {
                      if (widget.validateFn != null) {
                        suivant = widget.validateFn(value);
                      }
                      textlength = value.length;
                    });
                    //textcontroller.text = textcontroller.text.toUpperCase();
                  },
                  inputFormatters: [
                    if (widget.inputformatter == null)
                      new CurrencyInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    //helperText: hint,
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        color: Colors.black38),
                    //labelText: label,
                    labelStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                  ),
                ),
                _pagedivider(),
                Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colours.app_main),
                          text: "$textlength",
                          children: <TextSpan>[
                            TextSpan(
                                text: '/60',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(30),
                                ))
                          ]),
                    )),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagedivider() {
    return new Divider(
      color: Colors.black45,
    );
  }
}
