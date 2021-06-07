import 'package:gasale/Routes/RouteConstants.dart';
import 'package:gasale/Routes/Routes.dart' as router;
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        accentColor: Color(0xff2193b0),
        appBarTheme: AppBarTheme(
            color: Color(0xff2193b0),
            elevation: 4,
            shadowColor: Color(0xff6dd5ed),
            brightness: Brightness.dark),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: SplashScreenRoute,
    );
  }
}
