import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/models/fieldareas.dart';
import 'package:my_zhipin_boss/models/specifics.dart';
import 'package:my_zhipin_boss/registration/utilities/item_tag_new.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../public.dart';

class AbilityFinder extends StatefulWidget {
  final String collection, index, field;

  AbilityFinder({Key key, this.collection, this.index, this.field})
      : super(key: key);

  @override
  AbilityFinderState createState() => AbilityFinderState();
}

class AbilityFinderState extends State<AbilityFinder> {
  int selectable = 3;
  var abilities = [];

  @override
  void initState() {
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
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text("Compétences " + widget.field,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(30), color: Colors.black)),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.done,
                    color:
                        (selectable < 3) ? Colours.app_main : Colors.black45),
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
                  future: dao.getDocsEqualCriteria(widget.collection,
                      index: widget.index, field: widget.field),
                  // Firestore.instance
                  //     .collection(widget.collection)
                  //     .where("field", isEqualTo: widget.field)
                  //     .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError)
                      return new Text('${snapshot.error}');
                    else if (!snapshot.hasData)
                      return new Center(child: new CircularProgressIndicator());
                    else {
                      List<DocumentSnapshot> docs = snapshot.data.documents;
                      List<Map<String, Object>> competences = docs.map((f) {
                        List<Specifics> specifics =
                            Fieldareas.fromJson(f.data()).specifics;
                        var compet = List<Map<String, Object>>();
                        for (var i = 0; i < specifics.length; i++) {
                          for (var j = 0; j < specifics[i].jobs.length; j++) {
                            compet.add({
                              "competence": specifics[i].jobs[j],
                              "selected":
                                  abilities.contains(specifics[i].jobs[j])
                            });
                          }
                        }
                        return compet;
                      }).toList()[0];
                      return SingleChildScrollView(
                          child: _wrappingpanelnew(competences, context));
                    }
                    // switch (snapshot.connectionState) {
                    //   case ConnectionState.waiting:
                    //     return new Center(
                    //         child: new CircularProgressIndicator());
                    //   default:

                    // }
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
                          child: Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            spacing: ScreenUtil().setWidth(4.0),
                            runSpacing: ScreenUtil().setHeight(10.0),
                            children: abilities.map((ability) {
                              return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectable += 1;
                                      abilities.removeWhere((item) {
                                        print(item);
                                        return item == ability;
                                      });
                                    });
                                    print(abilities.toString());
                                  },
                                  child: ItemTag(
                                      title: ability,
                                      selected: abilities.contains(ability)));
                            }).toList(),
                          )),
                      Divider(
                        height: 10,
                      ),
                      (abilities.length == 0)
                          ? Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setHeight(1)),
                              child: Text("Choisissez 3 compétences au maximum",
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
        ));
  }

  Widget _wrappingpanelnew(
      List<Map<String, Object>> competences, BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(20),
            horizontal: ScreenUtil().setWidth(15)),
        child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: ScreenUtil().setWidth(4.0),
            runSpacing: ScreenUtil().setHeight(10.0),
            //children: getTags(competences),
            children: competences.map((competence) {
              return GestureDetector(
                  onTap: () {
                    if (competence['selected']) {
                      /*widget.removeItem(widget);*/

                      setState(() {
                        selectable += 1;
                        abilities.removeWhere((item) {
                          print(item);
                          return item == competence['competence'];
                        });
                      });
                    } else {
                      if (selectable > 0) {
                        //widget.addItem(widget);
                        setState(() {
                          selectable -= 1;
                          abilities.add(competence['competence']);
                        });
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Choisissez 3 domaines de compétences'),
                          duration: Duration(seconds: 1),
                        ));
                      }
                    }
                    print(abilities.toString());
                  },
                  child: ItemTag(
                      title: competence['competence'],
                      selected: competence['selected'] && (selectable >= 0)));
            }).toList()));
  }

  Widget _wrappingpanel(List<String> competences) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(20),
            horizontal: ScreenUtil().setWidth(15)),
        child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: ScreenUtil().setWidth(4.0),
            runSpacing: ScreenUtil().setHeight(10.0),
            //children: getTags(competences),
            children: competences.map((competence) {
              return ItemTag(
                title: competence,
              );
            }).toList()));
  }

  /*List<Widget> getTags(List tags) {
    List<Widget> listtags = new List<Widget>();
    tags.forEach((f) => listtags.add(ItemTag(title: f, status: this, addItem: addItem, removeItem: removeItem)));
    return listtags;
  }*/

}
