import 'package:my_zhipin_boss/models/chatline.dart';
import 'package:my_zhipin_boss/models/chatmessage.dart';
import 'package:my_zhipin_boss/models/job.dart';
import 'package:my_zhipin_boss/models/jobdetails.dart';
import 'package:my_zhipin_boss/models/user.dart';
import 'package:my_zhipin_boss/utils/text_readmore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:my_zhipin_boss/public.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/utils/image.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/scheduler.dart';

class MsgDetail extends StatefulWidget {
  //MsgDetail({Key key}) : super(key: key);
  final Jobdetails jobdetails;
  final Job job;
  final User user;

  MsgDetail({Key key, this.job, this.jobdetails, this.user}) : super(key: key);

  _MsgDetailState createState() => _MsgDetailState();
}

class _MsgDetailState extends State<MsgDetail>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollcontroller =
      ScrollController(initialScrollOffset: 10);
  Animation<double> animationTalk;
  AnimationController controller;
  TextEditingController _textInputController = new TextEditingController();

  var _suggestedphrases = [
    'Bonjour. S\'il vous plait, puis-je vous envoyer mon CV ?',
    'Excusez-moi, je pense que cette position ne me convient pas vraiment. Je vous souhaite de vite trouver la bonne personne',
    'Puis-je venir dans votre entreprise pour une interview ?',
  ];

  bool talkFOT = false;
  bool otherFOT = false;
  bool onstage = false;
  bool emojiboard = false;
  CollectionReference colref;

  var fsNode1 = new FocusNode();

  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    controller = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    //animation = new Tween(begin: 0.0, end: 100.0).animate(controller)
    //..addListener(() {
    // setState(() {
    //_controller.jumpTo(_controller.position.maxScrollExtent);
    //   });
    //  });
    //controller.forward();
    animationTalk = new Tween(begin: 1.0, end: 1.5).animate(controller)
      ..addStatusListener((state) {
        //_//scrollcontroller.jumpTo(_scrollcontroller.position.maxScrollExtent + 300.0);
        if (state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    fsNode1.addListener(_focusListener);
    super.initState();

    colref = _firestore.collection("chatlines");

    _scrollcontroller.addListener(() async {
      print("offset = " + _scrollcontroller.offset.toString());
    });

    /*WidgetsBinding.instance.addPostFrameCallback ((_) async {
      _scrollcontroller.animateTo(
        _scrollcontroller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    });*/

    /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(_scrollcontroller.offset == _scrollcontroller.position.maxScrollExtent)
      _scrollcontroller.jumpTo(_scrollcontroller.offset - 10);
      _scrollcontroller.animateTo(
        _scrollcontroller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    });*/
  }

  Future<void> scrolldown() async {
    try {
      Future.delayed(const Duration(milliseconds: 0), () async {
        _scrollcontroller.animateTo(
          _scrollcontroller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 0), () async {
        _scrollcontroller.animateTo(
          _scrollcontroller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> quickscrolldown() async {
    try {
      Future.delayed(const Duration(milliseconds: 100), () async {
        _scrollcontroller.animateTo(
          _scrollcontroller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });
    } catch (e) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        _scrollcontroller.animateTo(
          _scrollcontroller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      });
    }
  }

  _focusListener() async {
    if (fsNode1.hasFocus) {
      setState(() {
        talkFOT = false;
        otherFOT = false;
        onstage = false;
        emojiboard = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollcontroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Container(
            width: ScreenUtil().setWidth(250),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    widget.job.recruitername.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(32.0)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(10.0)),
                  child: Text(
                    widget.job.companyname +
                        " • " +
                        widget.job.recruiterposition,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(22.0)),
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: GestureDetector(
            child: Image.asset("assets/images/icon/ic_back_arrow.png"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: loadAssetImage(
                "icon/ic_chat_more",
                width: ScreenUtil().setWidth(40.0),
                height: ScreenUtil().setWidth(40.0),
              ),
            ),
          ],
        ),
        body: Stack(children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
              stream: colref.document(widget.job.id).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                Chatline line = Chatline.fromJson(snapshot.data.data);
                //print("ID : " + snapshot.data.data.toString());
                List<Widget> messages = <Widget>[];
                for (Chatmessage msg in line.messages) {
                  String content = msg.message['content'];
                  //print("${msg.from} == ${widget.user.id}");
                  messages.add(msg.from.toString() == widget.user.id.toString()
                      ? _chatSend(content, widget.user.userpics[0])
                      : _chatReceive(content, widget.job.recruiterpic));
                }
                scrolldown();
                return ListView(controller: _scrollcontroller,
                    //reverse: true,
                    //shrinkWrap: true,
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setHeight(120),
                      ),
                      _job_box(),
                      ...messages,
                      SizedBox(
                        height: ScreenUtil().setHeight(110),
                      ),
                    ]);
              }),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            //height: ScreenUtil().setHeight(125),
            child: _typebar(),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: ScreenUtil().setHeight(120),
              child: Container(
                color: Colours.text_white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _menuItem('icon/ic_phone', '换电话'),
                    _menuItem('icon/ic_wechat_display', '换微信'),
                    _menuItem('icon/ic_resume_send', '发简历'),
                    _menuItem('icon/ic_reject_disable', '不感兴趣'),
                  ],
                ),
              )),
        ]));
  }

  Widget _customTypingBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
      child: Row(children: <Widget>[
        GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10.0)),
            child: Container(
              height: ScreenUtil().setHeight(60),
              width: ScreenUtil().setWidth(130),
              color: Colours.app_main,
              alignment: Alignment.center,
              child: Text(
                "Tips",
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              fsNode1.unfocus();
              onstage = !onstage;
              otherFOT = false;
              talkFOT = false;
              emojiboard = false;
            });
          },
        ),
        Expanded(
          flex: 1,
          child: Container(
            //color: Colors.blue,
            alignment: Alignment.centerLeft,
            child: TextField(
              //autofocus: true,
              maxLines: null,
              focusNode: fsNode1,
              controller: _textInputController,
              onSubmitted: (value) {
                if (value.length > 0) {
                  DocumentReference submitsend = colref.document(widget.job.id);
                  var now = new DateTime.now().toString();
                  setState(() {
                    Map<String, dynamic> msg = {
                      "fromid": widget.user.id,
                      "message": {
                        "content": _textInputController.text,
                        "datetime": now
                      },
                      "toid": widget.job.recruiterId
                    };
                    submitsend.updateData({
                      'messages': FieldValue.arrayUnion([msg])
                    });
                  });
                }
                _textInputController.clear();
                quickscrolldown();
              },
              cursorColor: Colours.app_main,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Votre message...",
                contentPadding:
                    const EdgeInsets.only(top: 0.0, left: 8.0, right: 0.0),
              ),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Transform.scale(
                scale: 0.9,
                child: CircleAvatar(
                  backgroundColor: Colours.app_main,
                  foregroundColor: Colors.black38,
                  child: IconButton(
                    icon: Icon(
                      Icons.insert_emoticon,
                    ),
                    //iconSize: ScreenUtil().setHeight(30),
                    onPressed: () {
                      setState(() {
                        fsNode1.unfocus();
                        emojiboard = !emojiboard;
                        talkFOT = false;
                        otherFOT = false;
                        onstage = false;
                      });
                    },
                  ),
                )),
            SizedBox(
              width: ScreenUtil().setWidth(10.0),
            ),
            Transform.scale(
                scale: 0.9,
                child: CircleAvatar(
                  backgroundColor: Colours.app_main,
                  foregroundColor: Colors.black38,
                  child: IconButton(
                    icon: Icon(
                      Icons.message,
                    ),
                    //iconSize: ScreenUtil().setHeight(30),
                    onPressed: () {
                      if (_textInputController.text.length > 0) {
                        DocumentReference iconsend =
                            colref.document(widget.job.id);
                        var now = new DateTime.now().toString();
                        setState(() {
                          Map<String, dynamic> msg = {
                            "fromid": widget.user.id,
                            "message": {
                              "content": _textInputController.text,
                              "datetime": now
                            },
                            "toid": widget.job.recruitername
                          };
                          iconsend.updateData({
                            'messages': FieldValue.arrayUnion([msg])
                          });
                          onstage = false;
                          talkFOT = false;
                          otherFOT = false;
                          emojiboard = false;
                          fsNode1.unfocus();
                        });
                      }
                      _textInputController.clear();
                      quickscrolldown();
                    },
                  ),
                ))
            /*GestureDetector(
                onTap: () {
                  setState(() {
                    fsNode1.unfocus();               
                    otherFOT = !otherFOT;
                    talkFOT = false;
                    onstage = false;
                  });
                },
                child: loadAssetImage(
                  "icon/ic_gallery_add",
                  width: ScreenUtil().setWidth(70.0)
                )
              ),*/
          ],
        ),
      ]),
    );
  }

  Widget _typebar() {
    return Container(
      color: Color(0xFFebebf3),
      child: new Column(
        children: <Widget>[
          new Offstage(offstage: talkFOT, child: _customTypingBar()),
          new Offstage(
            offstage: !emojiboard,
            child: EmojiPicker(
                rows: 3,
                columns: 7,
                //recommendKeywords: ["Handshake", "Grinning Face With Big Eyes",
                //  "Grinning Face"],
                numRecommended: 10,
                onEmojiSelected: (emoji, category) {
                  _textInputController.text =
                      '${_textInputController.text}${emoji.emoji}';
                }),
          ),
          new Offstage(
              // 录音按钮
              offstage: !talkFOT,
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: 30.0,
                    color: Color(0xFFededed),
                    alignment: Alignment.centerLeft,
                    child: new IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        controller.reset();
                        controller.stop();
                        setState(() {
                          talkFOT = !talkFOT;
                          otherFOT = false;
                          onstage = false;
                          emojiboard = false;
                        });
                      },
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170.0,
                    color: Color(0xFFededed),
                    child: new Center(
                        child: new AnimatedBuilder(
                      animation: animationTalk,
                      builder: (_, child) {
                        return new GestureDetector(
                          child: new CircleAvatar(
                            radius: animationTalk.value * 30,
                            backgroundColor: Color(0x306b6aba),
                            child: new Center(
                              child: Icon(Icons.keyboard_voice,
                                  size: 30.0, color: Color(0xFF6b6aba)),
                            ),
                          ),
                          onLongPress: () {
                            controller.forward();
                          },
                          onLongPressUp: () {
                            controller.reset();
                            controller.stop();
                          },
                        );
                      },
                    )),
                  ),
                ],
              )),
          new Offstage(
            offstage: !onstage,
            child: Container(
              color: Colors.white,
              height: ScreenUtil().setHeight(1334) / 3,
              width: ScreenUtil().setWidth(750),
              child: ListView.separated(
                itemCount: _suggestedphrases.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black45,
                    height: 1.0,
                  );
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        DocumentReference suggestsend =
                            colref.document(widget.job.id);
                        var now = new DateTime.now().toString();
                        Map<String, dynamic> msg = {
                          "fromid": widget.user.id,
                          "message": {
                            "content": _suggestedphrases[index],
                            "datetime": now
                          },
                          "toid": widget.job.recruitername
                        };
                        suggestsend.updateData({
                          'messages': FieldValue.arrayUnion([msg])
                        });
                        onstage = false;
                        otherFOT = false;
                        talkFOT = false;
                        emojiboard = false;
                        fsNode1.unfocus();
                      });

                      quickscrolldown();
                    },
                    child: Container(
                      color: Colours.text_white,
                      padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              _suggestedphrases[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(30.0),
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          new Offstage(
              // 图片选择
              offstage: !otherFOT,
              child: new Padding(
                  padding: new EdgeInsets.all(10.0),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                          width: MediaQuery.of(context).size.width,
                          height: 170.0,
                          color: Color(0xFFededed),
                          child: Wrap(
                            spacing: 25.0,
                            runSpacing: 10.0,
                            children: <Widget>[
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.photo_size_select_actual,
                                      color: Colors.black38),
                                  onPressed: () {
                                    //getImage();
                                  },
                                ),
                              ),
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.videocam,
                                      color: Colors.black38),
                                  onPressed: () {},
                                ),
                              ),
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.linked_camera,
                                      color: Colors.black38),
                                  onPressed: () {},
                                ),
                              ),
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.add_location,
                                      color: Colors.black38),
                                  onPressed: () {},
                                ),
                              ),
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.library_music,
                                      color: Colors.black38),
                                  onPressed: () {},
                                ),
                              ),
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.library_books,
                                      color: Colors.black38),
                                  onPressed: () {},
                                ),
                              ),
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.video_library,
                                      color: Colors.black38),
                                  onPressed: () {},
                                ),
                              ),
                              new Container(
                                width:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 100) /
                                        4,
                                color: Color(0xFFffffff),
                                child: new IconButton(
                                  iconSize: 50.0,
                                  icon: Icon(Icons.local_activity,
                                      color: Colors.black38),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          )),
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _job_box() {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20.0))),
        color: Colors.white,
      ),
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(40.0),
          ScreenUtil().setHeight(40.0),
          ScreenUtil().setWidth(40.0),
          ScreenUtil().setHeight(40.0)),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(ScreenUtil().setHeight(30.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    widget.job.jobtitle,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(35.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                  child: Text(
                    '${widget.job.jobsalarymin}-${widget.job.jobsalarymax}k',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(28.0),
                        color: Colours.app_main),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: ScreenUtil().setHeight(30.0),
              right: ScreenUtil().setHeight(30.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: loadAssetImage("icon/ic_location_black",
                          width: ScreenUtil().setWidth(25)),
                      margin:
                          EdgeInsets.only(right: ScreenUtil().setHeight(10.0)),
                    ),
                    SizedBox(
                        width: ScreenUtil().setWidth(150),
                        child: Text(
                          widget.job.jobtown + " • " + widget.job.neighborhood,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: loadAssetImage("icon/ic_work_exp_black",
                          width: ScreenUtil().setWidth(25)),
                      margin:
                          EdgeInsets.only(right: ScreenUtil().setHeight(10.0)),
                    ),
                    Text(
                      "${widget.job.experiencemin}-${widget.job.experiencemax}ans",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: loadAssetImage("icon/ic_resume_degree_black",
                          width: ScreenUtil().setWidth(25)),
                      margin:
                          EdgeInsets.only(right: ScreenUtil().setHeight(10.0)),
                    ),
                    Text(
                      widget.job.degree,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: Color(0XffF4F4F4),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(ScreenUtil().setHeight(30.0)),
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[getTasks(widget.jobdetails.task)],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: Color(0XffF4F4F4),
          ),
          Container(
            color: Colors.white,
            //padding: EdgeInsets.all(ScreenUtil().setHeight(30.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  children: getTags(widget.job.technical),
                )
              ],
            ),
          ),
          _picText(
              "${widget.job.recruitername} • ${widget.job.recruiterposition}",
              "${widget.job.recruiterpic}",
              isRadius: true),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15.0)),
            child: Divider(
              height: 1.0,
              color: Color(0xff8f8f8f),
            ),
          ),
          Container(
              padding: EdgeInsets.all(ScreenUtil().setHeight(15.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${widget.job.createdAt}",
                    style: TextStyle(
                        color: Color(0xff8f8f8f),
                        fontSize: ScreenUtil().setSp(20)),
                  ),
                  Text("${widget.job.companyname}",
                      style: TextStyle(
                        color: Color(0xff8f8f8f),
                        fontSize: ScreenUtil().setSp(20),
                        fontWeight: FontWeight.bold,
                      ))
                ],
              )),
        ],
      ),
    );
  }

  List<Widget> getTags(List tags) {
    List<Widget> listtags = new List<Widget>();
    tags.forEach((f) => listtags.add(_itemTag(f)));
    return listtags;
  }

  Widget getTasks(String requirements) {
    return ShowMoreText(text: requirements, maxlines: 4);
  }

  Widget _picText(title, piclink, {isRadius = true}) {
    //String pic = "assets/images/avatar.jpg";
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(30.0),
          ScreenUtil().setHeight(20.0),
          ScreenUtil().setWidth(30.0),
          ScreenUtil().setHeight(20.0)),
      child: Row(
        children: <Widget>[
          isRadius
              ? CircleAvatar(
                  backgroundImage: NetworkImage(piclink),
                  radius: ScreenUtil().setWidth(isRadius ? 30.0 : 10.0),
                )
              : Container(
                  child: Image.network(piclink),
                  width: ScreenUtil().setWidth(120.0),
                  height: ScreenUtil().setWidth(120.0),
                ),
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "$title",
                overflow: TextOverflow.fade,
                style: TextStyle(
                  color: Color(0xffA0A0A0),
                  fontSize: ScreenUtil().setSp(25),
                ),
              ),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(50.0),
                  right: ScreenUtil().setWidth(10.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTag(title) {
    return ClipRRect(
      borderRadius:
          BorderRadius.all(Radius.circular(ScreenUtil().setHeight(10.0))),
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(15.0)),
        margin: EdgeInsets.only(
            right: ScreenUtil().setWidth(20.0),
            bottom: ScreenUtil().setWidth(3.0)),
        decoration: BoxDecoration(
            color: Color(0XffFFFFFF),
            border: Border.all(color: Color(0XffD2D2D2), width: 1.0),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10.0)))),
        child: Text(
          "$title",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(20), color: Color(0Xff7B7B7B)),
        ),
      ),
    );
  }

  Widget _chatReceive(title, img) {
    return Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
        padding: EdgeInsets.only(
          right: ScreenUtil().setWidth(120),
          top: ScreenUtil().setHeight(20.0),
          bottom: ScreenUtil().setHeight(20.0),
          left: ScreenUtil().setHeight(20.0),
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(img),
                radius: ScreenUtil().setWidth(50.0),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ScreenUtil().setWidth(460),
                  minWidth: ScreenUtil().setWidth(230),
                ),
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(20.0)),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20.0)),
                  decoration: BoxDecoration(
                      color: Colours.text_white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(10.0)),
                          topRight:
                              Radius.circular(ScreenUtil().setWidth(10.0)),
                          bottomLeft:
                              Radius.circular(ScreenUtil().setWidth(10.0)))),
                  child: Text(
                    "$title",
                    style: TextStyle(
                        color: Colors.black,
                        height: ScreenUtil().setHeight(2.35)),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _menuItem(icon, title) {
    return Container(
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(750) / 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          loadAssetImage("$icon", width: ScreenUtil().setWidth(60.0)),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10.0)),
            child: Text(
              "$title",
              style: TextStyle(color: Color(0xFF646464)),
            ),
          )
        ],
      ),
    );
  }

  Widget _chatSend(title, img) {
    return Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(120),
          top: ScreenUtil().setHeight(20.0),
          bottom: ScreenUtil().setHeight(20.0),
          right: ScreenUtil().setHeight(20.0),
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ScreenUtil().setWidth(460),
                  minWidth: ScreenUtil().setWidth(230),
                ),
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(20.0)),
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20.0)),
                  decoration: BoxDecoration(
                      color: Colours.app_main,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(10.0)),
                          topRight:
                              Radius.circular(ScreenUtil().setWidth(10.0)),
                          bottomLeft:
                              Radius.circular(ScreenUtil().setWidth(10.0)))),
                  child: Text(
                    "$title",
                    style: TextStyle(height: ScreenUtil().setHeight(2.35)),
                  ),
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(img),
                radius: ScreenUtil().setWidth(50.0),
              )
            ],
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
