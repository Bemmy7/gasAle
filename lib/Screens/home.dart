import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gasale/Routes/RouteConstants.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  bool isenabled,
      x,
      found,
      goToLocation = false,
      canPass = false,
      canMoveOn = false,
      internet = false,
      goToInternet = false;
  LocationPermission permission, per, req;
  Position position;
  String input;
  final controller = TextEditingController();
  Future<Position> bar() async {
    found = false;
    Position pos =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .whenComplete(() {
      print("Location doen");
    });
    setState(() {
      position = pos;
    });
    return position;
  }

  void quitApplication() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  void location() async {
    checkinternet().then((value) {
      setState(() {
        internet = value;
        if (value == false) {
          goToInternet = true;
        }
      });
    }).timeout(Duration(seconds: 30), onTimeout: () {
      setState(() {
        internet = false;
      });
    });
    if (internet) {
      x = await isLocationServiceEnabled().then((value) {
        if (!value) {
          setState(() {
            goToLocation = true;
          });
        } else {
          setState(() {
            goToLocation = false;
          });
        }
        return value;
      });
      if (!goToLocation) {
        if (per == LocationPermission.denied ||
            per == LocationPermission.deniedForever) {
          print("in?");
          per = await checkPermission().whenComplete(() async => {
                if (per == LocationPermission.denied ||
                    per == LocationPermission.deniedForever)
                  {req = await requestPermission()}
              });
          print(per);
        } else {
          canMoveOn = true;
        }
      }
    }
  }

  void foo() async {
    x = await isLocationServiceEnabled().then((value) {
      if (!value) {
        setState(() {
          goToLocation = true;
        });
      }
      return value;
    });

    per = await checkPermission().whenComplete(() async => {
          if (per == LocationPermission.denied ||
              per == LocationPermission.deniedForever)
            {req = await requestPermission()}
        });
    setState(() {
      isenabled = x;
      permission = per;
    });
    //if not go and enable location services
  }

  void moveon() {
    Navigator.pushReplacementNamed(context, HomeRoute);
  }

  Future<bool> checkinternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    // foo();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      location();

      if (canMoveOn) {
        timer.cancel();
        //Check INternet connection too
        Timer(Duration(seconds: 2), () {
          moveon();
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget actionButton(String string, Function function) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Center(
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: Color(0xff6dd5ed),
            child: InkWell(
              onTap: function,
              child: Container(
                  padding: EdgeInsets.all(6),
                  child: Center(
                      child: Text(
                    string,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),
                  ))),
            ),
          ),
        ),
      ),
    );
  }

  Widget locationAlert() {
    if (goToLocation) {
      return AlertDialog(
        title: Text("EnableLocationServices"),
        content:
            Text("Location Services Must Be Enabled In order To Continue."),
        actions: [
          actionButton("Enable Location Services", () {
            AppSettings.openLocationSettings();
          }),
          actionButton("Quit Application", () {
            quitApplication();
          }),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget internetAlert() {
    if (goToInternet) {
      return AlertDialog(
        title: Text("No Internet Connection"),
        content: Text("You are Offline, Please connect to the internet."),
        actions: [
          actionButton("Try Again", () {
            setState(() {
              goToInternet = false;
            });
          }),
          actionButton("Quit Application", () {
            quitApplication();
          }),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xff6dd5ee),
                Color(0xff2193b0),
              ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: Image.asset('assets/images/Gas.png'),
                    ),
                  ),
                  SpinKitThreeBounce(
                    duration: Duration(seconds: 1),
                    color: Color(0xff6dd5ed),
                    size: 50,
                  ),
                ],
              ),
            ),
            locationAlert(),
            internetAlert()
          ],
        ),
      ),
    );
  }
}
