import 'package:flutter/cupertino.dart';

class NavigationAnimation extends CupertinoPageRoute {
  final Widget nextScreen;
  NavigationAnimation({required this.nextScreen})
      : super(builder: (BuildContext context) => nextScreen);

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: nextScreen);
  }
}
