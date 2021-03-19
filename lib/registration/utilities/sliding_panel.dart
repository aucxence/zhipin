import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/models/fieldareas.dart';
import 'package:my_zhipin_boss/models/specifics.dart';
import 'package:my_zhipin_boss/public.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';

class SlidingPanel<T> extends PopupRoute<T> {
  final String collection, chosenfield, index;

  SlidingPanel({Key key, this.chosenfield, this.collection, this.index});

  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black54;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return MediaQuery.removePadding(
      context: context,
      removeRight: true,
      child: StfSlidingPanel(route: this),
    );
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 200);
}

class StfSlidingPanel extends StatefulWidget {
  final SlidingPanel route;

  StfSlidingPanel({Key key, this.route});

  @override
  _StfSlidingPanelState createState() => _StfSlidingPanelState();
}

class _StfSlidingPanelState extends State<StfSlidingPanel>
    with SingleTickerProviderStateMixin {
  int selectedindex = 0;
  Specifics _chosenspecifics;

  static AnimationController control;
  static Animation<Offset> offset;

  @override
  void initState() {
    control = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    offset = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(control);
    control.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: offset,
        child: new ClipRect(
          child: AnimatedBuilder(
            animation: widget.route.animation,
            builder: (BuildContext context, Widget child) {
              return new ClipRect(
                child: new CustomSingleChildLayout(
                  delegate: new _LayoutManager(widget.route.animation.value,
                      contentHeight: ScreenUtil().setHeight(1334 * 0.86),
                      contentWidth: ScreenUtil().setWidth(750 * 0.9)),
                  child: _slidingpanel(),
                ),
              );
            },
          ),
        ));
  }

  Widget _slidingpanel() {
    UserDaoService dao = ScopedModel.of<AppState>(context).dao;
    var c = Container(
        color: Colors.white,
        child: FutureBuilder(
            future: dao.getDocsEqualCriteria(widget.route.collection,
                index: widget.route.index, field: widget.route.chosenfield),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError)
                return new Text('${snapshot.error}');
              else if (!snapshot.hasData) {
                return new Center(child: new CircularProgressIndicator());
              } else {
                List<DocumentSnapshot> docs = snapshot.data.documents;
                List<Fieldareas> fieldareas = docs.map((f) {
                  return Fieldareas.fromJson(f.data());
                }).toList();
                return Material(
                    child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(750 * 0.45),
                        color: Color(0xFFF5F5F6),
                        child: ListView.separated(
                            itemCount: fieldareas[0].specifics.length,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                                      color: Colors.white,
                                      height: 10,
                                    ),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  decoration: BoxDecoration(
                                      color: selectedindex == index
                                          ? Colours.text_white
                                          : Color(0xFFF5F5F6)),
                                  child: ListTile(
                                    title: Center(
                                      child: Text(
                                          fieldareas[0].specifics[index].area,
                                          style: TextStyle(
                                              color: selectedindex == index
                                                  ? Colours.app_main
                                                  : Colors.black45,
                                              fontSize: ScreenUtil().setSp(25),
                                              fontWeight: selectedindex == index
                                                  ? FontWeight.bold
                                                  : FontWeight.normal)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: ScreenUtil().setHeight(0),
                                        horizontal: ScreenUtil().setWidth(50)),
                                    onTap: () {
                                      print("alright: " +
                                          index.toString() +
                                          " - " +
                                          fieldareas[0].specifics[index].area);
                                      setState(() {
                                        _chosenspecifics =
                                            fieldareas[0].specifics[index];
                                        selectedindex = index;
                                      });
                                    },
                                  ));
                            })),
                    Container(
                        width: ScreenUtil().setWidth(750 * 0.45),
                        color: Colors.white,
                        child: ListView.separated(
                            itemCount: (_chosenspecifics == null)
                                ? fieldareas[0].specifics[0].jobs.length
                                : _chosenspecifics.jobs.length,
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                                      color: Colors.white,
                                      height: 0,
                                    ),
                            itemBuilder: (BuildContext context, int index) {
                              if (_chosenspecifics == null)
                                _chosenspecifics = fieldareas[0].specifics[0];
                              return ListTile(
                                title: Center(
                                    child: Text(_chosenspecifics.jobs[index],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: ScreenUtil().setSp(23),
                                        ))),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(0),
                                    horizontal: ScreenUtil().setWidth(50)),
                                onTap: () {
                                  Navigator.pop(
                                      context, _chosenspecifics.jobs[index]);
                                },
                              );
                            }))
                  ],
                ));
              }
              // switch (snapshot.connectionState) {
              //   case ConnectionState.waiting:
              //     return new Center(child: new CircularProgressIndicator());
              //   default:

              // }
            }));
    return c;
  }
}

class _LayoutManager extends SingleChildLayoutDelegate {
  _LayoutManager(this.progress, {this.contentWidth, this.contentHeight});

  final double progress;
  final double contentWidth, contentHeight;

  @override
  bool shouldRelayout(_LayoutManager oldDelegate) {
    return progress != oldDelegate.progress;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return new BoxConstraints(
      minWidth: 0.0,
      maxWidth: contentWidth,
      minHeight: 0.0,
      maxHeight: contentHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    //double height = size.height - childSize.height * progress;
    double width = size.width - childSize.width;
    return new Offset(ScreenUtil().setWidth(75), ScreenUtil().setWidth(180));
  }
}
