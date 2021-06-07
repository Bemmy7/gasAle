import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gasale/Routes/RouteConstants.dart';
import 'package:gasale/Screens/home.dart';
import 'package:gasale/Screens/map.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // var arg = settings.arguments;
  switch (settings.name) {
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => MapView());
    case SplashScreenRoute:
      return MaterialPageRoute(builder: (context) => Home());
    default:
      return MaterialPageRoute(builder: (context) => MapView());
  }
}
