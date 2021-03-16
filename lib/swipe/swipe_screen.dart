import 'package:my_zhipin_boss/app/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/login/ui/login.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwipeScreen extends StatefulWidget {
  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  String image = "assets/images/tutorial/bg_tutorial_";

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      body: Stack(children: <Widget>[
        new Swiper(
          autoplay: true,
          pagination: new SwiperPagination(),
          control: new SwiperControl(),
          itemCount: 3,
          duration: 15000,
          itemBuilder: (context, index) {
            int j = index + 1;
            return Image.asset(image + j.toString() + ".png", fit: BoxFit.fill);
          },
        ),
        Positioned(
            bottom: ScreenUtil().setHeight(100),
            right: ScreenUtil().setWidth(10),
            left: ScreenUtil().setWidth(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _customButton("Je recherche le travail", () async {
                  UserDaoService dao = ScopedModel.of<AppState>(context).dao;
                  await dao.updateUser({'type': true});
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // prefs.setBool('type', true);

                  // await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => new PhoneAuthLogin(),
                  //     ));
                }),
                _customButton("Je cherche à recruiter", () async {
                  UserDaoService dao = ScopedModel.of<AppState>(context).dao;
                  await dao.updateUser({'type': false});
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // prefs.setBool('type', false);

                  // await Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => new PhoneAuthLogin(),
                  //     ));
                })
              ],
            ))
      ]),
    );
  }

  Widget _customButton(String text, VoidCallback action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        //height: ScreenUtil().setHeight(150.0),
        alignment: Alignment.center,
        padding: new EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30.0),
            vertical: ScreenUtil().setHeight(20)),
        //margin: new EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(28.0),
        //horizontal: ScreenUtil().setWidth(120)),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5),
            color: Colours.app_main),
        child: new Text(text,
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(25))),
      ),
    );
  }
}
