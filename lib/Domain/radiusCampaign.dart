import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapBackend extends ChangeNotifier {
  double valueRadius = 0;
  late LatLng latlngs;
  int volunteersRequired = 0;
  int seedsRequired = 0;
  int fundRequired = 0;

  CampaignProcess(latlng) {
    latlngs = latlng;
  }

  // ignore: non_constant_identifier_names
  RadiusAssign(radius) {
    valueRadius = radius * 100;
    notifyListeners();
  }

  checkVolunteersNeeded(double valueRadius1) {
    int testCase = valueRadius1.round();
    if (testCase < 10) {
      volunteersRequired = 5;
    } else if (testCase < 30) {
      volunteersRequired = 25;
    } else if (testCase < 50) {
      volunteersRequired = 60;
    } else if (testCase < 70) {
      volunteersRequired = 60;
    } else if (testCase < 80) {
      volunteersRequired = 60;
    } else if (testCase < 100) {
      volunteersRequired = 75;
    }

    notifyListeners();
  }

  checkseedsNeeded(double valueRadius1) {
    int testCase = valueRadius1.round();
    if (testCase < 10) {
      seedsRequired = 20;
    } else if (testCase < 30) {
      seedsRequired = 50;
    } else if (testCase < 50) {
      seedsRequired = 80;
    } else if (testCase < 70) {
      seedsRequired = 120;
    } else if (testCase < 80) {
      seedsRequired = 170;
    } else if (testCase < 100) {
      seedsRequired = 200;
    }

    notifyListeners();
  }

  checkFundRequired(double valueRadius1) {
    int testCase = valueRadius1.round();
    if (testCase < 10) {
      fundRequired = 500;
    } else if (testCase < 30) {
      fundRequired = 1500;
    } else if (testCase < 50) {
      fundRequired = 2000;
    } else if (testCase < 70) {
      fundRequired = 4000;
    } else if (testCase < 80) {
      fundRequired = 8000;
    } else if (testCase < 100) {
      fundRequired = 10000;
    }

    notifyListeners();
  }
}
