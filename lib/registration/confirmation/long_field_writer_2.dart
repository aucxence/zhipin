import 'package:my_zhipin_boss/models/boss.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/models/descriptiontemplate.dart';
import 'package:my_zhipin_boss/registration/step_four.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';

class LongFieldWriter extends StatefulWidget {
  final String advantage, hinttext, topic, collection;

  LongFieldWriter(
      {key, this.advantage, this.hinttext, this.topic, this.collection})
      : super(key: key);

  @override
  _LongFieldWriterState createState() => _LongFieldWriterState();
}

class _LongFieldWriterState extends State<LongFieldWriter> {
  var textlength, _modulo = 0;

  TextEditingController _textcontroller = TextEditingController();

  bool _showexemple = false;

  ScrollController _scrollcontroller = new ScrollController();

  @override
  void initState() {
    textlength = widget.advantage.split(" ").length;
    _textcontroller.text = widget.advantage;
    super.initState();
  }

  void scrollafterbuild(Duration d) async {
    await _scrollcontroller.animateTo(
      _scrollcontroller.position.maxScrollExtent + 1000,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    // return ScopedModelDescendant<BossRegistrationModel>(
    //     builder: (context, child, model) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black45,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.topic,
          style:
              TextStyle(fontSize: ScreenUtil().setSp(35), color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done,
                  color: (_textcontroller.text.split(" ").length > 5)
                      ? Colours.app_main
                      : Colors.black45),
              onPressed: () {
                _textcontroller.text.split(" ").length > 5
                    ? _validersuivant(context)
                    : Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Décrivez ' + widget.topic),
                        duration: Duration(seconds: 1),
                      ));
              })
        ],
      ),
      body: Stack(children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(30),
                vertical: ScreenUtil().setHeight(30)),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _scrollcontroller,
                child: Column(
                  children: <Widget>[
                    Text(
                        "Les descriptions énumérées et concises seront mieux notées",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.black45,
                            fontWeight: FontWeight.bold)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(40)),
                      child: TextField(
                        controller: _textcontroller,
                        maxLines: 8,
                        onChanged: (value) {
                          setState(() {
                            textlength =
                                _textcontroller.text.split(" ").length - 1;
                            if (_showexemple) _showexemple = !_showexemple;
                          });
                        },
                        decoration: InputDecoration(
                          //helperText: hint,
                          hintText: widget.hinttext,
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.black38),
                          border: InputBorder.none,
                        ),
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
                                    text: '/1000',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(30),
                                    ))
                              ]),
                        )),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setHeight(10)),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showexemple = !_showexemple;
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.remove_red_eye,
                              color: _showexemple
                                  ? Colours.app_main
                                  : Colors.black,
                              size: ScreenUtil().setSp(35),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(25)),
                            Text(
                                _showexemple
                                    ? "Cacher l'exemple"
                                    : "Regarder des exemples",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    color: Colors.black))
                          ],
                        ),
                      ),
                    ),
                    _showexemple
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(15),
                                vertical: ScreenUtil().setHeight(15)),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Colors.white,
                                elevation: 10,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance
                                        .collection(widget.collection)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError)
                                        return new Text('${snapshot.error}');
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return new Center(
                                              child:
                                                  new CircularProgressIndicator());
                                        default:
                                          List<DocumentSnapshot> docs =
                                              snapshot.data.documents;
                                          List<Descriptiontemplate>
                                              descriptiontemplate =
                                              docs.map((f) {
                                            return Descriptiontemplate.fromJson(
                                                f.data);
                                          }).toList();
                                          SchedulerBinding.instance
                                              .addPostFrameCallback((_) {
                                            _scrollcontroller.animateTo(
                                              _scrollcontroller
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 1000),
                                              curve: Curves.easeOut,
                                            );
                                          });
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          child: Row(
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                              descriptiontemplate[
                                                                      _modulo]
                                                                  .userpics,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          25)),
                                                          Center(
                                                              child: Text(
                                                            descriptiontemplate[
                                                                    _modulo]
                                                                .position,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ))
                                                        ],
                                                      )),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _modulo = (_modulo +
                                                                    1) %
                                                                descriptiontemplate
                                                                    .length;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .all(ScreenUtil()
                                                                  .setHeight(
                                                                      10.0)),
                                                          color: Colors.white,
                                                          //margin: EdgeInsets.only(right: ScreenUtil().setWidth(20.0)),
                                                          child: Text(
                                                            "Changer",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color: Colours
                                                                  .app_main,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          30.0),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                    child: Text(
                                                  descriptiontemplate[_modulo]
                                                      .description,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                              ],
                                            ),
                                          );
                                      }
                                    })))
                        : Container(),
                    SizedBox(
                      height: ScreenUtil().setHeight(500),
                    )
                  ],
                ))),
        Positioned(
          bottom: ScreenUtil().setHeight(20),
          right: ScreenUtil().setWidth(20),
          left: ScreenUtil().setWidth(20),
          child: GestureDetector(
              child: Container(
                padding:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05.0),
                    color: _textcontroller.text.split(" ").length > 5
                        ? Colours.app_main
                        : Colors.black45),
                child: Center(
                    child: Text("Suivant",
                        style: TextStyle(fontSize: ScreenUtil().setSp(35)))),
                //color: Colours.app_main
              ),
              onTap: () => _validersuivant(context)),
        )
      ]),
    );
    //   });
  }

  _validersuivant(BuildContext context) {
    // model.updateAdvantage(_textcontroller.text);
    Navigator.pop(context, _textcontroller.text);
    // Navigator.pop(context, _textcontroller.text);
  }

  Widget _pagedivider() {
    return new Divider(
      color: Colors.black45,
      height: ScreenUtil().setHeight(70),
    );
  }
}
