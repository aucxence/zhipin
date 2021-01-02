import 'package:my_zhipin_boss/models/simplifiedcompany.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/registration/currency_input_formatter.dart';

import '../public.dart';

class ItemCompleter extends StatefulWidget {
  final String title, hint, collection;

  ItemCompleter({Key key, this.title, this.hint, this.collection})
      : super(key: key);

  @override
  _ItemCompleterState createState() => _ItemCompleterState();
}

class _ItemCompleterState extends State<ItemCompleter> {
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
            Navigator.pop(context, 'No');
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
                          .orderBy("companyfullname")
                          .snapshots()
                      : Firestore.instance
                          .collection(widget.collection)
                          .where("searchindex",
                              arrayContains: textcontroller.text)
                          .orderBy("companyfullname")
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
                        /*where((DocumentSnapshot d) {
                      return d.data['companyfullname'].toString().contains(textcontroller.text)
                        || d.data['shortname'].toString().contains(textcontroller.text);
                    }).toList();*/
                        print("* " + docs.length.toString());
                        List<Simplifiedcompany> companies = docs.map((f) {
                          return Simplifiedcompany.fromJson(f.data);
                        }).toList();
                        return ListView.separated(
                            itemCount: companies.length,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                                      color: Colors.black45,
                                    ),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context,
                                      companies[index].companyfullname);
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
                                              text: companies[index]
                                                  .companyfullname
                                                  .substring(textcontroller
                                                      .text.length),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(30),
                                              ))
                                        ]),
                                  ),
                                  /*Text(
                              companies[index].companyfullname,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(22)
                              ),
                            ),*/
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: ScreenUtil().setHeight(-25)),
                                  /*subtitle: Text(
                              companies[index].shortname,
                              overflow: TextOverflow.ellipsis,
                            ),*/
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
