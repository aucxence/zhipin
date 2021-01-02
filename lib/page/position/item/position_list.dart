import 'package:my_zhipin_boss/models/user.dart';
import 'package:my_zhipin_boss/page/position/position_detail.dart';
import 'package:flutter/material.dart';
import 'package:collection/equality.dart';
import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/utils/image.dart';
import '../position_router.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:my_zhipin_boss/models/job.dart';

class PositionList extends StatefulWidget {
  bool isShowGrp = false;
  final Job job;
  final int index;
  final User user;

  PositionList(
      {Key key, this.isShowGrp = false, this.job, this.index, this.user})
      : super(key: key);

  _PositionListState createState() => _PositionListState();
}

class _PositionListState extends State<PositionList>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return GestureDetector(
      onTap: () {
        //NavigatorUtils.push(context, PositionRouter.positionDetail);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PositionDetail(job: widget.job, user: widget.user),
            ));
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(30.0)),
            margin: EdgeInsets.only(
                bottom: widget.isShowGrp ? ScreenUtil().setHeight(15.0) : 0.0,
                top: widget.index == 0 ? ScreenUtil().setHeight(80.0) : 0.0),
            color: Colours.text_white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.job.jobtitle,
                      style: TextStyle(
                          color: Color(0xFF434343),
                          fontSize: ScreenUtil().setSp(35),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.job.jobsalarymin}-${widget.job.jobsalarymax}k',
                      style: TextStyle(
                          color: Colours.app_main,
                          fontSize: ScreenUtil().setSp(40.0),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${widget.job.companyname} ${widget.job.companycategory}",
                      style: TextStyle(
                        color: Color(0xFF434343),
                        fontSize: ScreenUtil().setSp(25.0),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(15.0),
                ),
                Wrap(
                  runSpacing: 6.0,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setHeight(6.0))),
                        child: Container(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(10.0)),
                          margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(20.0)),
                          color: Color(0xFFF8F8F8),
                          child: Text(
                            "${widget.job.jobtown} ${widget.job.neighborhood}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFFAFAFAF),
                              fontSize: ScreenUtil().setSp(22.0),
                            ),
                          ),
                        )),
                    ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setHeight(6.0))),
                        child: Container(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(10.0)),
                          margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(20.0)),
                          color: Color(0xFFF8F8F8),
                          child: Text(
                            "${widget.job.experiencemin}-${widget.job.experiencemax}ans",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFFAFAFAF),
                              fontSize: ScreenUtil().setSp(22.0),
                            ),
                          ),
                        )),
                    ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setHeight(6.0))),
                        child: Container(
                          padding: EdgeInsets.all(ScreenUtil().setHeight(10.0)),
                          margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(20.0)),
                          color: Color(0xFFF8F8F8),
                          child: Text(
                            "${widget.job.degree}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFFAFAFAF),
                              fontSize: ScreenUtil().setSp(22.0),
                            ),
                          ),
                        )),
                    Row(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                "${widget.job.recruiterpic}",
                              ),
                              radius: ScreenUtil().setWidth(30.0),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: loadAssetImage(
                                "icon/ic_authenticated_tag",
                                width: ScreenUtil().setWidth(25.0),
                                height: ScreenUtil().setWidth(25.0),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(10.0)),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "${widget.job.recruitername}",
                                style: TextStyle(
                                  color: Color(0xFF585858),
                                  fontSize: ScreenUtil().setSp(22.0),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(5.0),
                              ),
                              Text(
                                "•",
                                style: TextStyle(
                                  color: Color(0xFF585858),
                                  fontSize: ScreenUtil().setSp(22.0),
                                ),
                              ),
                              SizedBox(
                                width: ScreenUtil().setWidth(5.0),
                              ),
                              Text(
                                "${widget.job.recruiterposition}",
                                style: TextStyle(
                                  color: Color(0xFF585858),
                                  fontSize: ScreenUtil().setSp(22.0),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
