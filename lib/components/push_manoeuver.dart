import 'package:flutter/material.dart';

PageRouteBuilder pushManoeuver(Widget widget) {
  return PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return widget;
      },
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: new SlideTransition(
            position: new Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(1.0, 0.0),
            ).animate(secondaryAnimation),
            child: child,
          ),
        );
      });
}
