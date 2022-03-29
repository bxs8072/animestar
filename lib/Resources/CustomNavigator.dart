import 'package:flutter/material.dart';

customNavigator({BuildContext context, Widget widget}) {
  return Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, _, __) {
      return widget;
    },
    transitionDuration: Duration(milliseconds: 400),
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: child,
        ),
      );
    },
  ));
}

customHeroNavigator({BuildContext context, Widget widget}) {
  return Navigator.of(context).push(PageRouteBuilder(
    pageBuilder: (context, _, __) {
      return widget;
    },
    transitionDuration: Duration(milliseconds: 400),
  ));
}

customNavigatorAndReplacement({BuildContext context, Widget widget}) {
  return Navigator.of(context).pushReplacement(PageRouteBuilder(
    pageBuilder: (context, _, __) {
      return widget;
    },
    transitionDuration: Duration(milliseconds: 400),
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: child,
        ),
      );
    },
  ));
}
