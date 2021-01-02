import 'dart:convert';

import 'package:my_zhipin_boss/models/fieldareas.dart';
import 'package:my_zhipin_boss/models/specifics.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/registration/currency_input_formatter.dart';
import 'package:my_zhipin_boss/registration/sliding_panel.dart';
import 'package:my_zhipin_boss/registration/step_two.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class CategoryFinder extends StatefulWidget {
  final String title, hint, collection;
  final BuildContext context;

  CategoryFinder(
      {Key key, this.title, this.hint, this.collection, this.context})
      : super(key: key);

  @override
  _CategoryFinderState createState() => _CategoryFinderState();
}

class _CategoryFinderState extends State<CategoryFinder>
    with SingleTickerProviderStateMixin {
  String namelength = "", chosenfield = "";
  Specifics _chosenspecifics;
  TextEditingController textcontroller = new TextEditingController();
  var _selectedindex = [null, 0];

  VoidCallback exitcallback;

  static AnimationController control;
  static Animation<Offset> offset;

  bool _more = false;

  @override
  void dispose() {
    super.dispose();
  }

  /*@override
  void didChangeDependencies() {
    widget.context.inheritFromWidgetOfExactType(StepTwo);
    super.didChangeDependencies();
  }*/

  @override
  void initState() {
    control = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    var statuslistener = (status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _more = false;
        });
      }
    };

    control.addStatusListener(statuslistener);

    offset = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(control);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    exitcallback = () {
      print("alright - at least");
      setState(() {
        _selectedindex[0] = null;
      });
      return Future.value(true);
    };
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
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            //horizontal: ScreenUtil().setWidth(50),
            vertical: ScreenUtil().setHeight(20)),
        child: Stack(
          children: stackmanager(context),
        ),
      ),
    );
  }

  List<Widget> stackmanager(context) {
    var e = <Widget>[];

    /** ******************************  **/

    e.addAll([
      Positioned(
        top: 0,
        right: 0,
        left: 0,
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          TextField(
            controller: textcontroller,
            //autofocus: true,
            onChanged: (value) {
              print("---- " + textcontroller.text);

              //textcontroller.text = textcontroller.text.toUpperCase();
            },
            inputFormatters: [
              new CurrencyInputFormatter(),
            ],
            decoration: InputDecoration(
              //helperText: hint,
              hintText: widget.hint,
              hintStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(30), color: Colors.black38),
              //labelText: label,
              labelStyle: TextStyle(color: Colors.black),
              border: InputBorder.none,
            ),
          ),
          _pagedivider(),
        ]),
      ),
      Container(
        margin: EdgeInsets.only(
          top: ScreenUtil().setHeight(200),
        ),
        //color: Colors.blueGrey,
        child: StreamBuilder(
          stream: Firestore.instance.collection(widget.collection).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) return new Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(child: new CircularProgressIndicator());
              default:
                List<DocumentSnapshot> docs = snapshot.data.documents;
                List<Fieldareas> fieldareas = docs.map((f) {
                  return Fieldareas.fromJson(f.data);
                }).toList();
                return ListView.separated(
                    itemCount: fieldareas.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          color: Colors.black45,
                        ),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(fieldareas[index].field,
                            style: TextStyle(
                                color: _selectedindex[0] == index
                                    ? Colours.app_main
                                    : Colors.black45,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: _selectedindex[0] == index
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(0),
                            horizontal: ScreenUtil().setWidth(50)),
                        onTap: () async {
                          setState(() {
                            chosenfield = fieldareas[index].field;
                            _chosenspecifics = fieldareas[index].specifics[0];
                            //_more = true;
                            _selectedindex[0] = index;
                          });
                          final result = await Navigator.push(
                              context,
                              SlidingPanel(
                                  collection: "fieldareas",
                                  chosenfield: chosenfield));
                          print("_________________----------------- " +
                              chosenfield +
                              "-" +
                              result);

                          Navigator.pop(
                              widget.context, chosenfield + "-" + result);
                          //control.forward();
                        },
                      );
                    });
            }
          },
        ),
      )
    ]);

    return e;
  }

  Widget _pagedivider() {
    return new Divider(
      color: Colors.black45,
    );
  }
}
