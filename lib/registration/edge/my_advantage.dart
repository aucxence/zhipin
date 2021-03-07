import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_zhipin_boss/components/page_divider.dart';
import 'package:my_zhipin_boss/components/toaster.dart';
import 'package:my_zhipin_boss/components/valid_button.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:my_zhipin_boss/user.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/models/descriptiontemplate.dart';
import 'package:my_zhipin_boss/registration/expectations/step_four.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';

class AdvantageDescriptor extends StatefulWidget {
  @override
  _AdvantageDescriptorState createState() => _AdvantageDescriptorState();
}

class _AdvantageDescriptorState extends State<AdvantageDescriptor> {
  var textlength = 0, _modulo = 0;

  TextEditingController _textcontroller = TextEditingController();

  bool _showexemple = false;

  ScrollController _scrollcontroller = new ScrollController();

  // void scrollafterbuild(Duration d) async {
  //   await _scrollcontroller.animateTo(
  //     _scrollcontroller.position.maxScrollExtent + 1000,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeOut,
  //   );
  // }

  AppState appstate;

  FToast fToast;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    appstate = ScopedModel.of<AppState>(context, rebuildOnChange: true);
    appstate.updateLoading(false);

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
          "Vos points forts",
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
                    ? _validersuivant()
                    : Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Décrivez vos points forts'),
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
                          hintText: '''
1. Diplomé en ingénieurie informatique (BAC + 5) avec mention
2. 10 ans d'expérience dans le dévelopement mobile
3. Pilote des projets innovants tels que ...
4. Certifié dans les technologies ...
5. ...
                        ''',
                          hintStyle: TextStyle(
                              fontSize: ScreenUtil().setSp(30),
                              color: Colors.black38),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    pagedivider(ScreenUtil().setHeight(70)),
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
                                child: FutureBuilder<QuerySnapshot>(
                                    future: appstate.dao
                                        .getDocsArrayContainsCriteria(
                                            "advantagetemplate"),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError)
                                        return new Text('${snapshot.error}');
                                      else if (!snapshot.hasData)
                                        return new Center(
                                            child:
                                                new CircularProgressIndicator());
                                      else {
                                        List<DocumentSnapshot> docs =
                                            snapshot.data.documents;
                                        List<Descriptiontemplate>
                                            descriptiontemplate = docs.map((f) {
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
                                                            width: ScreenUtil()
                                                                .setWidth(25)),
                                                        Center(
                                                            child: Text(
                                                          descriptiontemplate[
                                                                  _modulo]
                                                              .position,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
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
                                                        padding: EdgeInsets.all(
                                                            ScreenUtil()
                                                                .setHeight(
                                                                    10.0)),
                                                        color: Colors.white,
                                                        //margin: EdgeInsets.only(right: ScreenUtil().setWidth(20.0)),
                                                        child: Text(
                                                          "Changer",
                                                          overflow: TextOverflow
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
                                      // switch (snapshot.connectionState) {
                                      //   case ConnectionState.waiting:
                                      //     return new Center(
                                      //         child:
                                      //             new CircularProgressIndicator());
                                      //   default:

                                      // }
                                    })))
                        : Container(),
                    SizedBox(
                      height: ScreenUtil().setHeight(500),
                    )
                  ],
                ))),
        validationButton(
            _textcontroller.text.split(" ").length > 5, _validersuivant)
      ]),
    );
  }

  _validersuivant() {
    appstate.updateLoading(true);
    if (_textcontroller.text.split(" ").length > 5) {
      User model = appstate.user;
      model.updateAdvantage(_textcontroller.text);
      appstate.updateUser(model);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StepFour()));
    } else {
      appstate.updateLoading(false);
      var errorMessage = 'Décrivez brièvement vos atouts';
      showToast(fToast, Icons.no_encryption, errorMessage, 10);
    }
    // Navigator.pop(context, _textcontroller.text);
  }
}
