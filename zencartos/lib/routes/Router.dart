import 'package:flutter/cupertino.dart';

import 'Routes.dart';


class RouterMode{
  static const String REPLACE = 'PUSH REPLACE',
      PUSH = 'PUSH',
      POP = 'POP',
      STAY = 'STAY',
      EMPTY = 'EMPTY';
  static const String ROUTE_404 = "/404";
}

class Router{
  static goto(BuildContext context, String routeName, String mode, {dynamic parameter}){
    switch(mode){
      case RouterMode.REPLACE:
        Navigator.pushReplacementNamed(context, routeName, arguments: parameter);
        break;
      case RouterMode.POP:
        Navigator.of(context).pop(routeName);
        break;
      case RouterMode.PUSH:
        Navigator.of(context).pushNamed(routeName,arguments: parameter);
        break;
      case RouterMode.EMPTY:
        Navigator.of(context).pushNamedAndRemoveUntil(routeName, (_)=>false, arguments: parameter);
        break;
      default: Navigator.of(context).pop(false);
    }
  }


  static get getRouter => (RouteSettings rs) => appRoute(rs);

  static Route<dynamic> appRoute(RouteSettings settings){
    try{
      return new RouteTransition(builder: (_)=>routes[settings.name], settings: settings);
    }catch(e){
      print('No component for route ${settings.name}');
      return new RouteTransition(builder: (_)=>routes[RouterMode.ROUTE_404], settings: settings);
    }
  }

  static Widget componentForRouteName(String s) => routes[s];

  static goBack(BuildContext context){
    Navigator.of(context).pop(true);
  }
}


class RouteTransition<T> extends CupertinoPageRoute<T>{
  RouteTransition({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings, maintainState: true);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {

    return new CupertinoPageTransition(child: child, linearTransition: false, primaryRouteAnimation: animation, secondaryRouteAnimation: secondaryAnimation);
  }
}