import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gasale/Models/Model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';

class MapView extends StatefulWidget {
  @override
  _MapView createState() => _MapView();
}

/*
Color(0xff6dd5ed),
                Color(0xff2193b0),
 */
class _MapView extends State<MapView> {
  Completer<GoogleMapController> googleMapController = Completer();
  List<GasStation> list = new List();
  Set<Marker> markers = new Set();
  LatLng temp;
  double div = 10;
  String json =
      "{\"0\":{\"latitude\":8.980603,\"longitude\":38.757759,\"Name\":\"Total\",\"RDG\":\"AUN\",\"Distance\":4},\"1\":{\"latitude\":8.980703,\"longitude\":38.757959,\"Name\":\"Shell\",\"RDG\":\"AAN\",\"Distance\":10},\"2\":{\"latitude\":8.988603,\"longitude\":38.758759,\"Name\":\"Total\",\"RDG\":\"UAN\",\"Distance\":12},   \"3\":{\"latitude\":8.998603,\"longitude\":38.458759,\"Name\":\"Total\",\"RDG\":\"NAN\",\"Distance\":18},   \"4\":{\"latitude\":8.928603,\"longitude\":38.958759,\"Name\":\"Total\",\"RDG\":\"NNN\",\"Distance\":52},\"5\":{\"latitude\":8.978603,\"longitude\":38.858759,\"Name\":\"Total\",\"RDG\":\"NNN\",\"Distance\":72}}";
  static const LatLng _center =
      const LatLng(8.980603, 38.757759); /*Remove Later*/
  GoogleMapController _controller;
  MapType _mapType = MapType.normal;
  // List _markers = <Marker>[];
  bool show = false;
  bool showinfo = false;
  Color color = Color(0xff6dd5ed),
      fontcolor = Colors.white,
      underlayColor = Color(0xff2193b0);
  double containerHeight = 0, containerWidth = 0, sizeDirection = 0;
  ScrollController ascrollController;
  TextStyle textstyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white);
  String gas = "Unknown";
  String diesel = "Unknown";
  String regular = "Unknown";

  void _onMapCreated(GoogleMapController controller) {
    googleMapController.complete(controller);
    _controller = controller;
  }

  void changeCamera(LatLng latlng) {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latlng,
          tilt: 11,
          bearing: 45.0,
          zoom: 19.0,
        ),
      ),
    );
    showinfo = true;
    containerHeight = 120;
    containerWidth = 220;
    sizeDirection = 60;
  }

  List<String> clean(String keys) {
    try {
      List<String> sln = keys.substring(1, keys.length - 1).split(", ");
      return sln;
    } catch (Exeception) {
      return [];
    }
  }

  void foo() {
    //http request here
    var jsonfile = jsonDecode(json);
    String key = jsonfile.keys.toString();
    List<String> keys = clean(key);

    for (int i = 0; i < keys.length; i++) {
      LatLng ltlng = new LatLng(
          jsonfile[keys[0]]['latitude'], jsonfile[keys[0]]['longitude']);
      String gasstation = jsonfile[keys[0]]['Name'];
      String rdg = jsonfile[keys[0]]['RDG'];
      String dis = jsonfile[keys[0]]['Distance'].toString();
      double distance = double.parse(dis);
      GasStation gs = new GasStation(ltlng, distance, gasstation, rdg);
      markers.add(Marker(
        markerId: MarkerId(gs.gasStation),
        onTap: () {
          display(gs);
          setState(() {
            containerHeight = 120;
            containerWidth = 220;
            showinfo = true;
          });
          print(temp);
        },
        position: gs.latlng,
        infoWindow: InfoWindow(
          onTap: () {
            setState(() {
              containerHeight = 120;
              containerWidth = 220;
              showinfo = true;
            });
          },
          title: gs.gasStation,
          snippet: "Distance " + gs.distance.toString() + " KM",
        ),
      ));
    }
  }

  @override
  void initState() {
    var jsonfile = jsonDecode(json);
    String key = jsonfile.keys.toString();
    List<String> keys = clean(key);

    for (int i = 0; i < keys.length; i++) {
      LatLng ltlng = new LatLng(
          jsonfile[keys[i]]['latitude'], jsonfile[keys[i]]['longitude']);
      String gasstation = jsonfile[keys[i]]['Name'];
      String rdg = jsonfile[keys[i]]['RDG'];
      String dis = jsonfile[keys[i]]['Distance'].toString();
      double distance = double.parse(dis);
      GasStation gs = new GasStation(ltlng, distance, gasstation, rdg);
      markers.add(Marker(
        markerId: MarkerId(gs.gasStation),
        onTap: () {
          display(gs);
          setState(() {
            containerHeight = 120;
            containerWidth = 220;
            showinfo = true;
          });
          print(temp);
        },
        position: gs.latlng,
        infoWindow: InfoWindow(
          onTap: () {
            setState(() {
              containerHeight = 120;
              containerWidth = 220;
              showinfo = true;
            });
          },
          title: gs.gasStation,
          snippet: "Distance " + gs.distance.toString() + " KM",
        ),
      ));
      list.add(gs);
    }
    print(list);
    super.initState();
  }

  Widget detailList() {
    if (1 == 1) {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top: 30, left: 30),
          child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
              height: containerHeight,
              width: containerWidth,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20),
                color: color,
                child: Stack(
                  children: [
                    ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: OverflowBox(
                        alignment: AlignmentDirectional(1, 3),
                        maxHeight: 150,
                        maxWidth: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: underlayColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: OverflowBox(
                        alignment: AlignmentDirectional(-1, -3),
                        maxHeight: 150,
                        maxWidth: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: underlayColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(6),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Regular: $regular",
                                style: textstyle,
                              ),
                              SizedBox(
                                height: div,
                              ),
                              Text(
                                "Diesel: $diesel",
                                style: textstyle,
                              ),
                              SizedBox(
                                height: div,
                              ),
                              Text(
                                "Gas: $gas",
                                style: textstyle,
                              ),
                              SizedBox(
                                height: div,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget directionButton() {
    if (1 == 1) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            height: sizeDirection,
            width: sizeDirection,
            child: Material(
              color: color,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: () {
                  MapsLauncher.launchCoordinates(temp.latitude, temp.longitude);
                },
                child: Center(
                  child: Icon(
                    Icons.directions,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }

  String identify(String rdg) {
    if (rdg == "A") {
      return "Available";
    } else if (rdg == "N") {
      return "Not Available";
    } else {
      return "Unknown";
    }
  }

  void display(GasStation gasstation) {
    String rdg = gasstation.rdg;
    setState(() {
      temp = gasstation.latlng;
      regular = identify(rdg[0]);
      diesel = identify(rdg[1]);
      gas = identify(rdg[2]);

      show = true;
      sizeDirection = 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
          drawer: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width * 0.8,
            color: Color(0xff2193b0),
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      // color: Colors.red,
                      child: Image.asset('assets/images/Gas.png'),
                    )),
                Expanded(
                    flex: 2,
                    child: Container(
                      color: Color(0xff6dd5ed),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 60,
                              child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    child: ListTile(
                                      title: Center(child: Text("About Us")),
                                      trailing: Icon(Icons.person),
                                    )),
                              ),
                            ),
                            Divider(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 60,
                              child: Material(
                                child: InkWell(
                                    onTap: () {},
                                    child: ListTile(
                                      title: Center(child: Text("Contact Us")),
                                      trailing: Icon(Icons.contacts),
                                    )),
                              ),
                            ),
                            Divider(),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 60,
                              child: Material(
                                child: InkWell(
                                    onTap: () {
                                      AboutDialog();
                                    },
                                    child: ListTile(
                                      title: Center(child: Text("About")),
                                      trailing: Icon(Icons.info),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ),
          drawerEnableOpenDragGesture: true,
          appBar: AppBar(
            title: Text("Home"),
          ),
          body: Stack(
            children: [
              Container(
                height: (MediaQuery.of(context).size.height * 86) / 100,
                child: GoogleMap(
                  mapToolbarEnabled: true,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  compassEnabled: false,

                  onTap: (argument) {
                    print(argument);
                    setState(() {
                      containerHeight = 0;
                      containerWidth = 0;
                      sizeDirection = 0;
                      showinfo = false;
                      show = false;
                    });
                  },
                  myLocationButtonEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.5,
                  ),
                  mapType: _mapType,
                  markers: markers,
                  // onCameraMove: _onCameraMove,
                  rotateGesturesEnabled: true,
                ),
              ),
              DraggableScrollableSheet(
                minChildSize: 0.1,
                initialChildSize: 0.1,
                maxChildSize: 0.4,
                expand: true,
                builder: (BuildContext context, myscrollController) {
                  return Container(
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                      child: ListView.builder(
                        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                        controller: myscrollController,
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    changeCamera(list[index].latlng);
                                    display(list[index]);

                                    print(temp);
                                  },
                                  child: ListTile(
                                    title: Text(list[index].gasStation),
                                    subtitle: Text("Distance: " +
                                        list[index].distance.toString() +
                                        " Km Away"),
                                    trailing: Icon(Icons.local_gas_station),
                                  ),
                                ),
                              ),
                              Divider()
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              directionButton(),
              detailList(),
            ],
          )),
    );
  }
}
