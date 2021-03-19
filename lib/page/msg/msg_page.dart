import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/models/chat.dart';
import 'package:my_zhipin_boss/models/index.dart';
import 'package:my_zhipin_boss/page/msg/msg_detail.dart';
import 'package:my_zhipin_boss/page/msg/msg_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:my_zhipin_boss/utils/image.dart';

class MsgPage extends StatefulWidget {
  final User user;
  MsgPage({Key key, this.user}) : super(key: key);

  _MsgPageState createState() => _MsgPageState();
}

class _MsgPageState extends State<MsgPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var _list = [];

  final SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i <= 100; i++) {
      var str = {"title": '张三${i}'};
      setState(() {
        _list.add(str);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Conversations",
          style: TextStyle(color: Colours.text_white),
        ),
        backgroundColor: Colours.app_main,
        brightness: Brightness.light,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // NavigatorUtils.push(context, SettingRouter.settingPage);
            },
            icon: loadAssetImage(
              "icon/ic_action_notify",
              width: ScreenUtil().setWidth(43.0),
              height: ScreenUtil().setWidth(43.0),
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("chats").snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> chatsnapshot) {
            if (chatsnapshot.hasError) return new Text('${chatsnapshot.error}');
            switch (chatsnapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(child: new CircularProgressIndicator());
              default:
                List<DocumentSnapshot> chatdocs = chatsnapshot.data.docs;
                List<Chat> chats = chatdocs.map((f) {
                  return Chat.fromJson(f.data());
                }).toList();

                List<Chat> toremove = [];
                //-----------FAUDRA CREER UNE FONCTION NODE.JS POUR REGLER CE PROBLEME-----------
                for (var c in chats) {
                  if (widget.user.chats.indexOf(c.id) == -1) toremove.add(c);
                }

                chats.removeWhere((chat) {
                  return toremove.contains(chat);
                });
                //-------------------------------------------------------------------------------

                return ListView.separated(
                    itemCount: chats.length,
                    separatorBuilder: (_, index) => Divider(
                        height: ScreenUtil().setHeight(25),
                        color: Colors.white),
                    itemBuilder: (_, index) {
                      return InkWell(
                          // onTap: () {

                          // },
                          child: msgList(
                              isShowGrp:
                                  index == chats.length - 1 ? false : true,
                              userchat: chats[index],
                              index: index));
                    });
            }
          }),
    );
  }

  Widget msgList({isShowGrp = true, Chat userchat, index}) {
    var date = DateTime.parse(userchat.lasttime);
    var formatter = new DateFormat('MMMEd');
    var newdate = formatter.format(date);
    // initializeDateFormatting("fr_FR", null).then((value) {
    //   newdate = formatter.format(date);
    // });
    return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Color(0xFFF0F0F0),
                    width: ScreenUtil().setHeight(isShowGrp ? 1.0 : 0.0)))),
        child: Slidable(
          key: ValueKey(index),
          controller: slidableController,
          actionPane: SlidableDrawerActionPane(),
          child: Container(
              color: Colors.white,
              child: GestureDetector(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userchat.bosspic),
                    radius: ScreenUtil().setWidth(60.0),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "${userchat.bossname}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xFF222222),
                                  fontSize: ScreenUtil().setSp(32.0)),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(10.0)),
                            width: ScreenUtil().setWidth(180),
                            child: Text(
                              "${userchat.companyname}•${userchat.bossposition}",
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xFFAAAAAA),
                                  fontSize: ScreenUtil().setSp(20.0)),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "$newdate",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: ScreenUtil().setSp(20.0)),
                        ),
                      ))
                    ],
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(20.0)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${userchat.lastmsg}",
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: ScreenUtil().setSp(25.0),
                          letterSpacing: 1.0),
                    ),
                  ),
                ),
                onTap: () async {
                  Jobdetails jobdetails;
                  Job job;

                  DocumentReference jobdetailsref = FirebaseFirestore.instance
                      .collection("jobdetails")
                      .doc(index.toString());
                  DocumentReference jobref = FirebaseFirestore.instance
                      .collection("jobs")
                      .doc(index.toString());

                  await jobdetailsref.snapshots().first.then((details) {
                    jobdetails = Jobdetails.fromJson(details.data());
                    print("************* " + jobdetails.task);
                  });

                  await jobref.snapshots().first.then((details) {
                    job = Job.fromJson(details.data());
                    print("************* " + job.jobtitle);
                  });

                  print("--- " + jobdetails.task);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MsgDetail(
                            job: job,
                            jobdetails: jobdetails,
                            user: widget.user),
                      ));
                },
              )),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Appeler',
              color: Color(0xFFC9C6CD),
              foregroundColor: Colours.text_white,
              icon: Icons.call,
              onTap: () {},
            ),
            IconSlideAction(
              caption: 'Supprimer',
              color: Color(0xFFFF3B32),
              foregroundColor: Colours.text_white,
              icon: Icons.delete,
              onTap: () => _showDeleteBottomSheet(index),
            ),
          ],
        ));
  }

  _showDeleteBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: Container(
                height: 161.2,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 52.0,
                      child: Text(
                        "Etes-vous sur de vouloir supprimer ce contact?",
                        style: TextStyles.textDark16,
                      ),
                    ),
                    Gaps.line,
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Colours.text_red,
                        child: Text("Confirmer",
                            style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: () {
                          setState(() {
                            _list.removeAt(index);
                          });
                          NavigatorUtils.goBack(context);
                        },
                      ),
                    ),
                    Gaps.line,
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Colours.text_gray,
                        child: Text("Annuler",
                            style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: () {
                          NavigatorUtils.goBack(context);
                        },
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
