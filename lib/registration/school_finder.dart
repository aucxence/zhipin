import 'package:my_zhipin_boss/models/simplifiedschool.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/registration/currency_input_formatter.dart';

import '../public.dart';

class SchoolFinder extends StatefulWidget {
  final String title, hint, collection, ordering;

  SchoolFinder({Key key, this.title, this.hint, this.collection, this.ordering})
      : super(key: key);

  @override
  _SchoolFinderState createState() => _SchoolFinderState();
}

class _SchoolFinderState extends State<SchoolFinder> {
  String namelength = "";
  TextEditingController textcontroller = new TextEditingController();

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
            onPressed: () {},
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
                      textlength = value.length;
                    });
                    //textcontroller.text = textcontroller.text.toUpperCase();
                  },
                  inputFormatters: [
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
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(200),
              ),
              //color: Colors.blueGrey,
              child: StreamBuilder<QuerySnapshot>(
                  stream: textcontroller.text.length == 0
                      ? Firestore.instance
                          .collection(widget.collection)
                          .orderBy(widget.ordering)
                          .snapshots()
                      : Firestore.instance
                          .collection(widget.collection)
                          .where("searchindex",
                              arrayContains: textcontroller.text)
                          .orderBy(widget.ordering)
                          .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return new Text('${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Center(
                            child: new CircularProgressIndicator());
                      default:
                        List<DocumentSnapshot> docs = snapshot.data.documents;
                        print("* " + docs.length.toString());
                        List<Simplifiedschool> schools = docs.map((f) {
                          return Simplifiedschool.fromJson(f.data);
                        }).toList();
                        print(schools.toString());
                        return ListView.separated(
                            itemCount: schools.length,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                                      color: Colors.black45,
                                    ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(
                                      context, schools[index].schoolfullname);
                                },
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(35),
                                            color: Colours.app_main),
                                        text: textcontroller.text,
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: schools[index]
                                                  .schoolfullname
                                                  .substring(textcontroller
                                                      .text.length),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                              ))
                                        ]),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(-25)),
                                ),
                              );
                            });
                    }
                  }),
            )
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
