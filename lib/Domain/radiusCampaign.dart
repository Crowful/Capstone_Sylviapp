import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapBackend extends ChangeNotifier {
  double valueRadius = 0;
  late LatLng latlngs;

  CampaignProcess(latlng) {
    latlngs = latlng;
  }

  RadiusAssign(radius) {
    valueRadius = radius;
    print(valueRadius);
    notifyListeners();
  }
}
