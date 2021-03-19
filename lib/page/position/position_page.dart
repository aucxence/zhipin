import 'package:my_zhipin_boss/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './item/position_list.dart';
import 'position_router.dart';
import 'dart:async';
import 'package:my_zhipin_boss/models/job.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PositionPage extends StatefulWidget {
  final User user;
  PositionPage({Key key, this.user}) : super(key: key);

  _PositionPageState createState() => _PositionPageState();
}

class _PositionPageState extends State<PositionPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.user.fields[0].Position,
            style: TextStyle(color: Colours.text_white),
          ),
          backgroundColor: Colours.app_main,
          brightness: Brightness.dark,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                NavigatorUtils.push(context, PositionRouter.positionAdd);
              },
              icon: loadAssetImage(
                "icon/ic_filter_find_add",
                width: ScreenUtil().setWidth(40.0),
                height: ScreenUtil().setWidth(40.0),
              ),
            ),
            IconButton(
              onPressed: () {
                NavigatorUtils.push(context, PositionRouter.positionSearch);
              },
              icon: loadAssetImage(
                "icon/ic_action_company_search",
                width: ScreenUtil().setWidth(40.0),
                height: ScreenUtil().setWidth(40.0),
              ),
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("jobs").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) return new Text('${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Center(child: new CircularProgressIndicator());
                    default:
                      List<DocumentSnapshot> docs = snapshot.data.docs;
                      List<Job> jobs = docs.map((f) {
                        return Job.fromJson(f.data());
                      }).toList();
                      return ListView.builder(
                          itemCount: jobs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return PositionList(
                                isShowGrp: true,
                                job: jobs[index],
                                index: index,
                                user: widget.user);
                          });
                  }
                }),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: ScreenUtil().setHeight(80.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xFFF0F0F0),
                          width: ScreenUtil().setHeight(1.0))),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30.0),
                    right: ScreenUtil().setWidth(30.0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(30.0)),
                            child: Text("Recommendations",
                                style: TextStyle(color: Color(0xFF000000)),
                                overflow: TextOverflow.fade),
                          ),
                          Text(
                            "Nouveau",
                            style: TextStyle(color: Color(0xFF5D5D5D)),
                            overflow: TextOverflow.fade,
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(10.0)),
                                color: Color(0xffF6F6F6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        NavigatorUtils.push(context,
                                            PositionRouter.positionCity);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Yaoundé",
                                            style: TextStyle(
                                                color: Color(0xFF656565)),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down,
                                            color: Color(0xFFC3C3C3),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            width: ScreenUtil().setWidth(30.0),
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10.0)),
                                  color: Color(0xffF6F6F6),
                                  child: GestureDetector(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Filtres",
                                          style: TextStyle(
                                              color: Color(0xFF656565)),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xFFC3C3C3),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      NavigatorUtils.push(context,
                                          PositionRouter.positionFilter);
                                    },
                                  )))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
