import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/models/career.dart';
import 'package:my_zhipin_boss/registration/utilities/item_tag_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';

class DesiredAreas extends StatefulWidget {
  final String collection;
  final int selectable;

  DesiredAreas({Key key, this.collection, this.selectable}) : super(key: key);

  @override
  _DesiredAreasState createState() => _DesiredAreasState();
}

class _DesiredAreasState extends State<DesiredAreas> {
  int selectable = 3; // le nombre de choix restant
  var abilities = []; // la liste des choix
  List<int> sltedlist = []; // la liste du nombre de choix par carrière
  List<int> sltedcareers =
      []; // les carrières dans lesquelles les choix sont fait.

  List<Map<String, Object>> choices;

  double position = 0.0;

  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    selectable = widget.selectable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    UserDaoService dao = ScopedModel.of<AppState>(context).dao;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black45,
          onPressed: () {
            abilities.length > 0
                ? Navigator.pop(context, abilities.join(" - "))
                : Navigator.pop(context, null);
          },
        ),
        // centerTitle: true,
        // title: Text(
        //   "Compétences " + widget.field,
        //   style: TextStyle(
        //     fontSize: ScreenUtil().setSp(30),
        //     color: Colors.black
        //   )
        // ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done,
                  color: (selectable < widget.selectable)
                      ? Colours.app_main
                      : Colors.black45),
              onPressed: () {
                Navigator.pop(context, abilities.join(" - "));
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(120)),
              child: FutureBuilder(
                future: dao.getDocsEqualCriteria(widget.collection),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('${snapshot.error}');
                  else if (!snapshot.hasData) {
                    return new Center(child: new CircularProgressIndicator());
                  } else {
                    List<DocumentSnapshot> docs = snapshot.data.documents;
                    List<Career> careers = docs.map((career) {
                      return Career.fromJson(career.data);
                    }).toList();
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      /*_controller.animateTo(
                        position,
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOut,);*/
                      _controller.jumpTo(position);
                    });

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        position = scrollNotification.metrics.pixels;
                        // print("-- ** ++ " + position.toString());
                      },
                      child: ListView.separated(
                        controller: _controller,
                        itemCount: careers.length,
                        separatorBuilder: (context, index) => _pagedivider(),
                        itemBuilder: (context, index) {
                          choices = careers[index].choices.map((choice) {
                            return {
                              "choice": choice,
                              "selected": abilities.contains(choice)
                            };
                          }).toList();
                          var collapsed = true;
                          var slted =
                              0; //les items choisis pour cet expansiontile
                          // sltedlist.replaceRange(index, index, [slted]);
                          if (!(sltedlist.length > index)) sltedlist.add(slted);
                          return ExpansionTile(
                            // onExpansionChanged: (value) {
                            //   setState(() {
                            //     collapsed = value;
                            //   });
                            // },
                            initiallyExpanded: sltedcareers.contains(index),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(careers[index].career,
                                    style: TextStyle(
                                        color: collapsed
                                            ? Colours.app_main
                                            : Colors.black45,
                                        fontSize: ScreenUtil().setSp(30),
                                        fontWeight: collapsed
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                sltedlist[index] > 0
                                    ? CircleAvatar(
                                        backgroundColor: Colours.app_main,
                                        radius: ScreenUtil().setSp(20),
                                        child: Text(sltedlist[index].toString(),
                                            style: TextStyle(
                                                color: collapsed
                                                    ? Colours.text_white
                                                    : Colors.black45,
                                                fontSize:
                                                    ScreenUtil().setSp(20),
                                                fontWeight: collapsed
                                                    ? FontWeight.bold
                                                    : FontWeight.normal)),
                                      )
                                    : Container()
                              ],
                            ),
                            children: <Widget>[
                              _wrappingpanelnew(choices, context, index)
                            ],
                          );
                        },
                      ),
                    );
                  }
                  // switch (snapshot.connectionState) {
                  //   case ConnectionState.waiting:
                  //     return new Center(child: new CircularProgressIndicator());
                  //   default:
                  //     }
                },
              )),
          Positioned(
              top: 0,
              left: ScreenUtil().setWidth(5),
              right: ScreenUtil().setWidth(5),
              child: Container(
                height: ScreenUtil().setHeight(150),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    Container(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setHeight(25)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Wrap(
                                alignment: WrapAlignment.spaceEvenly,
                                spacing: ScreenUtil().setWidth(4.0),
                                runSpacing: ScreenUtil().setHeight(10.0),
                                children: abilities.map((ability) {
                                  return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectable += 1;

                                          var x = sltedcareers[
                                              abilities.indexOf(ability)];
                                          sltedlist[x]--;

                                          // print("Entête+- ${abilities.indexOf(ability)}");

                                          // print("Entête-- ${sltedcareers.contains(abilities.indexOf(ability))}");

                                          sltedcareers.remove(sltedcareers[
                                              abilities.indexOf(ability)]);

                                          abilities.removeWhere((item) {
                                            // print(item);
                                            return item == ability;
                                          });
                                          // print("() -> " + sltedlist]);
                                          // print(abilities.indexOf(ability));

                                          //sltedlist[int.parse(ability['matching_career'])]--;
                                        });
                                        print(sltedcareers);
                                        // print(abilities.toString());
                                      },
                                      child: ItemTag(
                                          title: ability,
                                          selected:
                                              abilities.contains(ability)));
                                }).toList(),
                              ),
                              (abilities.length > 0)
                                  ? RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: ScreenUtil().setSp(35),
                                              color: Colours.app_main),
                                          text: abilities.length.toString(),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: "/3",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                ))
                                          ]),
                                    )
                                  : Container()
                            ])),
                    Divider(
                      height: 10,
                    ),
                    (abilities.length == 0)
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(1)),
                            child: Text(
                                "Choisissez en ${widget.selectable} au maximum",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(25),
                                    color: Colors.black)))
                        : SizedBox(
                            height: 0,
                          ),
                  ],
                )),
              ))
        ],
      ),
    );
  }

  Widget _wrappingpanelnew(
      List<Map<String, Object>> careers, BuildContext context, int index) {
    //sltedlist[index] = 3 - selectable;

    //print("encore possible pour ceci: " + sltedlist.toString() + " = " + sltedlist.length.toString());

    return Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(20),
            horizontal: ScreenUtil().setWidth(15)),
        child: Wrap(
            alignment: WrapAlignment.start,
            spacing: ScreenUtil().setWidth(4.0),
            runSpacing: ScreenUtil().setHeight(10.0),
            //children: getTags(careers),
            children: careers.map((career) {
              return GestureDetector(
                  onTap: () {
                    if (career['selected']) {
                      /*widget.removeItem(widget);*/

                      setState(() {
                        selectable += 1;
                        abilities.removeWhere((item) {
                          // print(item);
                          return item == career['choice'];
                        });
                        sltedlist[index] = sltedlist[index] - 1;
                        print(sltedcareers.contains(index));
                        sltedcareers.remove(index);
                      });
                      print(sltedcareers);
                    } else {
                      if (selectable > 0) {
                        //widget.addItem(widget);
                        setState(() {
                          selectable -= 1;
                          abilities.add(career['choice']);
                          var x = sltedlist[index];
                          sltedlist[index] = x + 1;
                          // print("index $index: " + sltedlist[index].toString());
                          sltedcareers.add(index);
                        });
                        print(sltedcareers);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Choisissez en ${widget.selectable} au maximum'),
                          duration: Duration(seconds: 1),
                        ));
                      }
                    }
                    // print(abilities.toString());
                  },
                  child: ItemTag(
                      title: career['choice'],
                      selected: career['selected'] && (selectable >= 0)));
            }).toList()));
  }

  Widget _pagedivider() {
    return new Divider(
      color: Colors.black45,
      height: ScreenUtil().setHeight(70),
    );
  }
}
