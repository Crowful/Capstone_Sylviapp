import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBackend extends ChangeNotifier {
  double valueRadius = 0;
  late LatLng latlngs;
  int volunteersRequired = 0;
  int seedsRequired = 0;
  double fundRequired = 0;

  // ignore: non_constant_identifier_names
  CampaignProcess(latlng) {
    latlngs = latlng;
  }

  // ignore: non_constant_identifier_names
  RadiusAssign(radius) {
    valueRadius = radius;
    notifyListeners();
  }

  checkVolunteersNeeded(double valueRadius1) {
    int testCase = valueRadius1.round();
    if (testCase < 3) {
      volunteersRequired = 5;
    } else if (testCase < 10) {
      volunteersRequired = 25;
    } else if (testCase < 15) {
      volunteersRequired = 60;
    } else if (testCase < 20) {
      volunteersRequired = 60;
    } else if (testCase < 30) {
      volunteersRequired = 60;
    } else if (testCase < 40) {
      volunteersRequired = 75;
    }

    notifyListeners();
  }

  checkseedsNeeded(double valueRadius1) {
    int testCase = valueRadius1.round();
    if (testCase < 3) {
      seedsRequired = 20;
    } else if (testCase < 10) {
      seedsRequired = 50;
    } else if (testCase < 15) {
      seedsRequired = 80;
    } else if (testCase < 20) {
      seedsRequired = 120;
    } else if (testCase < 30) {
      seedsRequired = 170;
    } else if (testCase < 40) {
      seedsRequired = 200;
    }

    notifyListeners();
  }

  checkFundRequired(double valueRadius1) {
    int testCase = valueRadius1.round();
    if (testCase < 3) {
      fundRequired = 500;
    } else if (testCase < 10) {
      fundRequired = 1500;
    } else if (testCase < 15) {
      fundRequired = 2000;
    } else if (testCase < 20) {
      fundRequired = 4000;
    } else if (testCase < 30) {
      fundRequired = 8000;
    } else if (testCase < 40) {
      fundRequired = 10000;
    }

    notifyListeners();
  }
}
