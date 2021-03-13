import 'package:flutter/material.dart';

class AxRoute<T> extends PopupRoute<T> {
  final String label;
  final Widget child;

  AxRoute({this.child, this.label});

  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black26;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => label;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return Align(
        alignment: Alignment.bottomCenter,
        child: MediaQuery.removePadding(
            context: context, removeTop: true, child: child));
  }

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: animation.drive(new Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      )),
      child: child,
    );
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
