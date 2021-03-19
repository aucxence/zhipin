import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_zhipin_boss/dao/firestore.dart';
import 'package:my_zhipin_boss/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';

class MailVerification extends StatefulWidget {
  final String email;

  const MailVerification({Key key, this.email}) : super(key: key);

  @override
  _MailVerificationState createState() => _MailVerificationState();
}

class _MailVerificationState extends State<MailVerification>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  UserDaoService dao;

  @override
  void initState() {
    super.initState();
    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation = Tween<double>(begin: -5, end: 1).animate(controller);
    // animation = CurvedAnimation(parent: animation, curve: Curves.bounceInOut);

    dao = new UserDaoService();
    controller.addListener(() {
      setState(() {});
    });

    controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    ScopedModel.of<AppState>(context).updateLoading(false);
    return Scaffold(
      body: Stack(children: <Widget>[
        Center(
          child: SvgPicture.asset('assets/images/login/message_sent.svg'),
        ),
        Positioned.fill(
          top: ScreenUtil().setHeight(25),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(70 + animation.value * 5)),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black45,
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '''1. Allez dans votre boite mail: ${widget.email}
2. Ouvrez le mail reçu de l'application
3. Cliquez sur le lien à l'intérieur pour confirmer votre compte''',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.left,
                )),
          ),
        ),
        Positioned.fill(
            bottom: 25,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  child: Text('Suivant'),
                  onPressed: () async {
                    print('alo');
                    await dao.signOut();
                    print('ola');
                  },
                  textColor: Colors.white,
                  color: Colors.green,
                )))
      ]),
    );
  }
}
