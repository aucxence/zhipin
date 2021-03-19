import 'dart:convert';
import 'package:my_zhipin_boss/generated/i18n.dart';
import 'package:my_zhipin_boss/page/msg/msg_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:flutter/widgets.dart';
import 'package:my_zhipin_boss/page/msg/msg_router.dart';
import 'package:my_zhipin_boss/models/job.dart';
import 'package:my_zhipin_boss/utils/image.dart';
import 'package:my_zhipin_boss/models/jobdetails.dart';
import 'package:my_zhipin_boss/utils/text_readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_zhipin_boss/models/user.dart';

class PositionDetail extends StatefulWidget {
  final Job job;
  final User user;
  PositionDetail({Key key, this.job, this.user}) : super(key: key);

  @override
  _PositionDetailState createState() => _PositionDetailState();
}

class _PositionDetailState extends State<PositionDetail> {
  bool _isShow = false;
  bool _saving = false;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      if (offset > ScreenUtil().setHeight(50)) {
        setState(() {
          _isShow = true;
        });
      } else {
        setState(() {
          _isShow = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Jobdetails jobdetails;

  List<Widget> stackingwidget(BuildContext context) {
    CollectionReference jobdetailsref =
        FirebaseFirestore.instance.collection("jobdetails");
    List<Widget> temp = <Widget>[];

    var _streambuilder = StreamBuilder<QuerySnapshot>(
        stream: jobdetailsref
            .where("id", isEqualTo: int.parse(widget.job.jobdetailsid))
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          DocumentSnapshot doc = snapshot.data.docs.first;
          jobdetails = Jobdetails.fromJson(doc.data());
          return SingleChildScrollView(
            controller: _scrollController,
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
                      bottom: ScreenUtil().setHeight(30.0)),
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
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setHeight(10.0)),
                          ),
                          Text(
                            "${widget.job.jobtown} • ${widget.job.neighborhood}",
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
                            child: loadAssetImage("icon/ic_work_exp_black",
                                width: ScreenUtil().setWidth(25)),
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setHeight(10.0)),
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
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setHeight(10.0)),
                          ),
                          Text(
                            "${widget.job.degree}",
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
                _picText(
                    "${widget.job.recruitername}",
                    "${widget.job.companyname} • ${widget.job.recruiterposition}",
                    "${widget.job.recruiterpic}"),
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
                        child: Text(
                          "Details du travail",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(35.0)),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: ScreenUtil().setHeight(25.0)),
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.job.companyname +
                                    " " +
                                    widget.job.companycategory,
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(28),
                                    color: Color(0xFF8F8F8F)),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(25.0)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTasks(jobdetails.task),
                                  ]),
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
                  padding: EdgeInsets.all(ScreenUtil().setHeight(30.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Compétences Requises",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(35.0)),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(40.0)),
                      ),
                      Wrap(children: getTags(widget.job.technical))
                    ],
                  ),
                ),
                _picText(
                    "${widget.job.companyname}(${widget.job.jobtown})",
                    "${widget.job.companycategory}•{${jobdetails.staffrangemin}-${jobdetails.staffrangemax}} Employes • ${jobdetails.companyfield}",
                    "${widget.job.companyicon}",
                    isRadius: false),
                SizedBox(
                  height: ScreenUtil().setHeight(120),
                ),
              ],
            ),
          );
        });

    temp.add(_streambuilder);

    if (_saving) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      temp.add(modal);
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print("id du job " + widget.job.id);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: ScreenUtil().setWidth(250),
          alignment: Alignment.center,
          child: Text(
            _isShow ? widget.job.jobtitle : widget.job.companyname,
            overflow: TextOverflow.ellipsis,
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
              "icon/ic_action_favor_off_black",
              width: ScreenUtil().setWidth(40.0),
              height: ScreenUtil().setWidth(40.0),
            ),
          ),
          GestureDetector(
            child: Container(
              child: loadAssetImage(
                "icon/ic_action_report_black",
                width: ScreenUtil().setWidth(40.0),
                height: ScreenUtil().setWidth(40.0),
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: loadAssetImage(
                "icon/ic_action_share_black",
                width: ScreenUtil().setWidth(40.0),
                height: ScreenUtil().setWidth(40.0),
              )),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ...stackingwidget(context),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(ScreenUtil().setWidth(20.0)),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MsgDetail(
                            job: widget.job,
                            jobdetails: jobdetails,
                            user: widget.user),
                      ));
                  //NavigatorUtils.push(context, MsgRouter.msgDetail);
                },
                child: Container(
                  height: ScreenUtil().setHeight(100),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(10.0))),
                    color: Colours.app_main,
                  ),
                  child: Text("Entrer en contact",
                      style: TextStyle(fontSize: ScreenUtil().setSp(30))),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getTasks(String requirements) {
    LineSplitter split = new LineSplitter();
    List<Widget> itemlist = new List<Widget>();
    split.convert(requirements).forEach((f) => itemlist.add(_itemList(f)));

    return ShowMoreText(text: requirements, maxlines: 4);
  }

  List<Widget> getTags(List tags) {
    List<Widget> listtags = new List<Widget>();
    tags.forEach((f) => listtags.add(_itemTag(f)));
    return listtags;
  }

  Widget _itemList(title) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
      child: Text(
        "$title",
        style: TextStyle(
            fontSize: ScreenUtil().setSp(28), color: Color(0xFF8F8F8F)),
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
            bottom: ScreenUtil().setWidth(20.0)),
        decoration: BoxDecoration(
            color: Color(0XffFFFFFF),
            border: Border.all(color: Color(0XffD2D2D2), width: 1.0),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10.0)))),
        child: Text(
          "$title",
          style: TextStyle(color: Color(0Xff7B7B7B)),
        ),
      ),
    );
  }

  Widget _picText(title, sub, piclink, {isRadius = true}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(ScreenUtil().setHeight(30.0)),
      child: Row(
        children: <Widget>[
          isRadius
              ? CircleAvatar(
                  backgroundImage: NetworkImage(piclink),
                  radius: ScreenUtil().setWidth(isRadius ? 60.0 : 10.0),
                )
              : Container(
                  child: Image.network(piclink),
                  width: ScreenUtil().setWidth(120.0),
                  height: ScreenUtil().setWidth(120.0),
                ),
          Expanded(
            flex: 1,
            child: ListTile(
                title: Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text("$title"),
                        margin:
                            EdgeInsets.only(right: ScreenUtil().setWidth(10.0)),
                      ),
                      Text(
                        isRadius ? "active" : "",
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(25.0),
                          color: Color(0XffA0A0A0),
                        ),
                      )
                    ],
                  ),
                ),
                subtitle: Text("$sub"),
                trailing: Container(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: ScreenUtil().setSp(35.0),
                    color: Color(0xffC6C6C6),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
