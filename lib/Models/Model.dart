import 'package:google_maps_flutter/google_maps_flutter.dart';

class GasStation {
  final LatLng latlng;
  final double distance;
  final String gasStation;
  final String rdg;
  bool description = false;
  GasStation(this.latlng, this.distance, this.gasStation, this.rdg);
}

class TestS {
  String json =
      "{\"0\":{\"latitude\":8.980603,\"longitude\":38.757759,\"Name\":\"Total\",\"RDG\":\"AUN\",\"Distance\":69},\"1\":{\"latitude\":8.980703,\"longitude\":38.757959,\"Name\":\"Shell\",\"RDG\":\"AAN\",\"Distance\":420},\"2\":{\"latitude\":8.988603,\"longitude\":38.758759,\"Name\":\"Total\",\"RDG\":\"UAN\",\"Distance\":12},   \"3\":{\"latitude\":8.998603,\"longitude\":38.458759,\"Name\":\"Total\",\"RDG\":\"NAN\",\"Distance\":112},   \"4\":{\"latitude\":8.928603,\"longitude\":38.958759,\"Name\":\"Total\",\"RDG\":\"NNN\",\"Distance\":52},\"5\":{\"latitude\":8.978603,\"longitude\":38.858759,\"Name\":\"Total\",\"RDG\":\"NNN\",\"Distance\":72}}\"";
}
