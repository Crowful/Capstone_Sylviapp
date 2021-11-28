import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:sylviapp_project/screens/campaign_module/join_donate.dart';
import 'package:sylviapp_project/widgets/campaign_module/slidable.dart';

class MapViewOnly extends StatefulWidget {
  const MapViewOnly({Key? key}) : super(key: key);

  @override
  _MapViewOnlyState createState() => _MapViewOnlyState();
}

class _MapViewOnlyState extends State<MapViewOnly>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _keyMap = GlobalKey<ScaffoldState>();

  late AnimationController controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  String uid = "";
  double radius = 0;
  bool isVerified = false;
  late String userHolder;
  late AnimationController _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500))
        ..addListener(() {
          setState(() {});
        });

  
  bool clicked = false;
  bool showForest = false;
  bool showActive = true;
  bool showInProgress = false;
  bool showCompleted = false;
  bool showLatLng = false;
  bool showLayers = false;
  int numSeeds = 0;
  double currentDonations = 0.00;
  double maxDonations = 0.00;
  int currentVolunteers = 0;
  int numberVolunteers = 0;
  String title = "title test";
  String description = " description test";
  late String dateCreated;
  late String dateStart;
  late String dateEnded;
  String address = "address test";
  String city = "city test";
  late String time;
  var usernames;
  late lt.LatLng testlatlng;
  double latitude = 0;
  double longitude = 0;
  bool isPointValid = false;
  List<lt.LatLng> latlngpolygonlistLamesa = List.empty(growable: true);
  List<lt.LatLng> latlngpolygonlistAngat = List.empty(growable: true);
  List<lt.LatLng> latlngpolygonlistPantabangan = List.empty(growable: true);
  late List<dynamic> pointlist = List.empty(growable: true);
  List<mtk.LatLng> mtkPolygonLamesa = List.empty(growable: true);
  List<mtk.LatLng> mtkPolygonAngat = List.empty(growable: true);
  List<mtk.LatLng> mtkPolygonPantabangan = List.empty(growable: true);
  fmap.MapController cntrler = fmap.MapController();
  bool isOrganizer = false;
  bool createMode = false;
  bool isOpened = false;
  List<Map<String, dynamic>> circleMarkersCampaigns =
      List.empty(growable: true);

  List<Map<String, dynamic>> existingCampaign = List.empty(growable: true);

  List<Map<String, dynamic>> getIsCompleted = List.empty(growable: true);
  List<Map<String, dynamic>> getVolunteers = List.empty(growable: true);
  List<Map<String, dynamic>> getInProgress = List.empty(growable: true);
  List<Map<String, dynamic>> getProgress = List.empty(growable: true);
  List<Map<String, dynamic>> getDone = List.empty(growable: true);

  lt.LatLng? _initialCameraPosition = lt.LatLng(14.7452, 121.0984);
  double finalRadius = 0;

  @override
  void initState() {
    super.initState();
    showActive = true;
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) => usernames = AESCryptography()
            .decryptAES(enc.Encrypted.from64(value['username'])));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  void putCircle(double radius1, double latitude, double longitude) {
    controller.forward();

    circleMarkersCampaigns.add({
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius1,
      "uid": 'campaignUid'
    });
  }

  @override
  Widget build(BuildContext context) {
    showActive = true;
    dynamic userUID = context.read(authserviceProvider).getCurrentUserUID();
    return SafeArea(child: Consumer(builder: (context, watch, child) {
      final radiusProvider = watch(mapProvider);
      int finalVolunteers = radiusProvider.volunteersRequired;
      int finalSeeds = radiusProvider.seedsRequired;
      double finalFund = radiusProvider.fundRequired;
      finalRadius = radiusProvider.valueRadius;
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future:
              FirebaseFirestore.instance.collection('users').doc(userUID).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
            


              return Scaffold(
                  key: _keyMap,
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('quarantineStatus')
                            .doc('status')
                            .get(),
                        builder: (context, statusSnapshot) {
                          if (!statusSnapshot.hasData) {
                            return CircularProgressIndicator();
                          } else {
                            return Stack(
                              children: [
                                FutureBuilder<QuerySnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('polygon')
                                        .doc('Lamesa_Forest')
                                        .collection('polygons')
                                        .get(),
                                    builder: (context, snapshotLamesa) {
                                      if (!snapshotLamesa.hasData) {
                                        return CircularProgressIndicator();
                                      } else {
                                        snapshotLamesa.data!.docs
                                            .forEach((element) {
                                          pointlist = List<dynamic>.from(
                                              element['points']);
                                        });

                                        for (var pts in pointlist) {
                                          latlngpolygonlistLamesa.add(lt.LatLng(
                                              pts["latitude"],
                                              pts["longitude"]));
                                        }

                                        for (var pts
                                            in latlngpolygonlistLamesa) {
                                          mtkPolygonLamesa.add(mtk.LatLng(
                                              pts.latitude, pts.longitude));
                                        }
                                        return FutureBuilder<QuerySnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('polygon')
                                                .doc('Angat_Forest')
                                                .collection('polygons')
                                                .get(),
                                            builder: (context, snapshotAngat) {
                                              if (!snapshotAngat.hasData) {
                                                return CircularProgressIndicator();
                                              } else {
                                                snapshotAngat.data!.docs
                                                    .forEach((element) {
                                                  pointlist =
                                                      List<dynamic>.from(
                                                          element['points']);
                                                });

                                                for (var pts in pointlist) {
                                                  latlngpolygonlistAngat.add(
                                                      lt.LatLng(pts["latitude"],
                                                          pts["longitude"]));
                                                }

                                                for (var pts
                                                    in latlngpolygonlistAngat) {
                                                  mtkPolygonAngat.add(
                                                      mtk.LatLng(pts.latitude,
                                                          pts.longitude));
                                                }
                                                return FutureBuilder<
                                                        QuerySnapshot>(
                                                    future: FirebaseFirestore
                                                        .instance
                                                        .collection('polygon')
                                                        .doc(
                                                            'Pantabangan_Forest')
                                                        .collection('polygons')
                                                        .get(),
                                                    builder: (context,
                                                        snapshotPantabangan) {
                                                      if (!snapshotPantabangan
                                                          .hasData) {
                                                        return CircularProgressIndicator();
                                                      } else {
                                                        snapshotAngat.data!.docs
                                                            .forEach((element) {
                                                          pointlist = List<
                                                                  dynamic>.from(
                                                              element[
                                                                  'points']);
                                                        });

                                                        for (var pts
                                                            in pointlist) {
                                                          latlngpolygonlistPantabangan
                                                              .add(lt.LatLng(
                                                                  pts["latitude"],
                                                                  pts["longitude"]));
                                                        }

                                                        for (var pts
                                                            in latlngpolygonlistPantabangan) {
                                                          mtkPolygonPantabangan
                                                              .add(mtk.LatLng(
                                                                  pts.latitude,
                                                                  pts.longitude));
                                                        }
                                                        return FutureBuilder<
                                                                QuerySnapshot>(
                                                            future: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'campaigns')
                                                                .where(
                                                                    'isActive',
                                                                    isEqualTo:
                                                                        true)
                                                                .get(),
                                                            builder: (context,
                                                                snapshotCampaigns) {
                                                              if (!snapshotCampaigns
                                                                  .hasData) {
                                                                return CircularProgressIndicator();
                                                              } else {
                                                                snapshotCampaigns
                                                                    .data!.docs
                                                                    .forEach(
                                                                        (element) {
                                                                  existingCampaign
                                                                      .add({
                                                                    "latitude":
                                                                        element[
                                                                            'latitude'],
                                                                    "longitude":
                                                                        element[
                                                                            'longitude'],
                                                                    "radius":
                                                                        element[
                                                                            'radius'],
                                                                    "campaignUid":
                                                                        element[
                                                                            'campaignID'],
                                                                    "uid": element[
                                                                        'uid'],
                                                                    "address":
                                                                        element[
                                                                            'address'],
                                                                    "nameOfCampaign":
                                                                        element[
                                                                            'campaign_name'],
                                                                    "city": element[
                                                                        'city'],
                                                                    "current_donations":
                                                                        element[
                                                                            'current_donations'],
                                                                    "current_volunteers":
                                                                        element[
                                                                            'current_volunteers'],
                                                                    "max_donation":
                                                                        element[
                                                                            'max_donation'],
                                                                    "number_volunteers":
                                                                        element[
                                                                            'number_volunteers'],
                                                                    "description":
                                                                        element[
                                                                            'description']
                                                                  });
                                                                });

                                                                return fmap.FlutterMap(
                                                                    mapController:
                                                                        cntrler,
                                                                    options: fmap.MapOptions(
                                                                        center:
                                                                            _initialCameraPosition,
                                                                        zoom:
                                                                            13),
                                                                    children: [
                                                                      fmap.TileLayerWidget(
                                                                          options: fmap.TileLayerOptions(
                                                                        urlTemplate:
                                                                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                                        subdomains: [
                                                                          'a',
                                                                          'b',
                                                                          'c'
                                                                        ],
                                                                        attributionBuilder:
                                                                            (_) {
                                                                          return const Text(
                                                                              "© OpenStreetMap contributors");
                                                                        },
                                                                      )),
                                                                    ],
                                                                    layers: [
                                                                      fmap.TileLayerOptions(
                                                                        urlTemplate:
                                                                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                                        subdomains: [
                                                                          'a',
                                                                          'b',
                                                                          'c'
                                                                        ],
                                                                        attributionBuilder:
                                                                            (_) {
                                                                          return const Text(
                                                                              "© OpenStreetMap contributors");
                                                                        },
                                                                      ),
                                                                      fmap.PolygonLayerOptions(
                                                                          polygons: [
                                                                            fmap.Polygon(
                                                                                points: latlngpolygonlistLamesa,
                                                                                color: Colors.green.withOpacity(0.5),
                                                                                borderColor: Colors.green,
                                                                                borderStrokeWidth: 1),
                                                                          ]),
                                                                      fmap.PolygonLayerOptions(
                                                                          polygons: [
                                                                            fmap.Polygon(
                                                                                points: latlngpolygonlistPantabangan,
                                                                                color: Colors.green.withOpacity(0.5),
                                                                                borderColor: Colors.green,
                                                                                borderStrokeWidth: 1),
                                                                          ]),
                                                                      fmap.PolygonLayerOptions(
                                                                          polygons: [
                                                                            fmap.Polygon(
                                                                                points: latlngpolygonlistAngat,
                                                                                color: Colors.green.withOpacity(0.5),
                                                                                borderColor: Colors.green,
                                                                                borderStrokeWidth: 1),
                                                                          ]),
                                                                      if (showActive) ...[
                                                                        for (var info
                                                                            in existingCampaign)
                                                                          fmap.CircleLayerOptions(
                                                                              circles: [
                                                                                fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: double.parse(info.values.elementAt(2).toString()), borderColor: Colors.red, borderStrokeWidth: 1, color: Colors.red.withOpacity(0.2)),
                                                                              ]),
                                                                        for (var info
                                                                            in existingCampaign)
                                                                          fmap.MarkerLayerOptions(
                                                                              markers: [
                                                                                fmap.Marker(
                                                                                    width: 120,
                                                                                    point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                    builder: (context) {
                                                                                      return GestureDetector(
                                                                                          onTap: () {
                                                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => JoinDonateCampaign(uidOfCampaign: info.values.elementAt(3), uidOfOrganizer: info.values.elementAt(4), nameOfCampaign: info.values.elementAt(6), city: info.values.elementAt(7), currentFund: info.values.elementAt(8), currentVolunteer: info.values.elementAt(9), maxFund: info.values.elementAt(10), totalVolunteer: info.values.elementAt(11), address: info.values.elementAt(5), description: info.values.elementAt(12))));
                                                                                          },
                                                                                          child: Icon(
                                                                                            Icons.ac_unit,
                                                                                            color: Colors.transparent,
                                                                                          ));
                                                                                    })
                                                                              ]),
                                                                      ],
                                                                      if (showInProgress) ...[
                                                                        for (var info
                                                                            in getInProgress)
                                                                          fmap.CircleLayerOptions(
                                                                              circles: [
                                                                                fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: double.parse(info.values.elementAt(2).toString()), borderColor: Colors.red, borderStrokeWidth: 1, color: Colors.red.withOpacity(0.2)),
                                                                              ]),
                                                                        for (var info
                                                                            in getInProgress)
                                                                          fmap.MarkerLayerOptions(
                                                                              markers: [
                                                                                fmap.Marker(
                                                                                    width: 120,
                                                                                    point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                    builder: (context) {
                                                                                      return GestureDetector(
                                                                                          onTap: () {},
                                                                                          child: Icon(
                                                                                            Icons.ac_unit,
                                                                                            color: Colors.transparent,
                                                                                          ));
                                                                                    })
                                                                              ]),
                                                                      ],
                                                                      if (showCompleted) ...[
                                                                        for (var info
                                                                            in getIsCompleted)
                                                                          fmap.CircleLayerOptions(
                                                                              circles: [
                                                                                fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: double.parse(info.values.elementAt(2).toString()), borderColor: Colors.red, borderStrokeWidth: 1, color: Colors.red.withOpacity(0.2)),
                                                                              ]),
                                                                        for (var info
                                                                            in getIsCompleted)
                                                                          fmap.MarkerLayerOptions(
                                                                              markers: [
                                                                                fmap.Marker(
                                                                                    width: 120,
                                                                                    point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                    builder: (context) {
                                                                                      return GestureDetector(
                                                                                          onTap: () {},
                                                                                          child: Icon(
                                                                                            Icons.ac_unit,
                                                                                            color: Colors.transparent,
                                                                                          ));
                                                                                    })
                                                                              ]),
                                                                      ],
                                                                      if (showLatLng) ...[
                                                                        for (var info
                                                                            in getVolunteers)
                                                                          fmap.MarkerLayerOptions(
                                                                              markers: [
                                                                                fmap.Marker(
                                                                                    width: 120,
                                                                                    point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                    builder: (context) {
                                                                                      return Text(info.values.elementAt(3).toString() + "/" + info.values.elementAt(2).toString() + " Volunteers");
                                                                                    })
                                                                              ]),
                                                                      ],
                                                                      for (var info
                                                                          in circleMarkersCampaigns)
                                                                        fmap.CircleLayerOptions(
                                                                            circles: [
                                                                              fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: info.values.elementAt(2), color: Colors.red)
                                                                            ])
                                                                    ]);
                                                              }
                                                            });
                                                      }
                                                    });
                                              }
                                            });
                                      }
                                    }),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showLayers = !showLayers;
                                              });
                                            },
                                            icon: Icon(
                                              Icons.layers,
                                              size: 30,
                                              color: Color(0xff65BFB8),
                                            )),
                                        AnimatedOpacity(
                                            opacity: showLayers ? 1 : 0,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (showActive == true) {
                                                        showLatLng =
                                                            !showLatLng;
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'campaigns')
                                                            .where('isActive',
                                                                isEqualTo: true)
                                                            .get()
                                                            .then((element) {
                                                          element.docs.forEach(
                                                              (elements) {
                                                            getVolunteers.add({
                                                              "latitude":
                                                                  elements[
                                                                      'latitude'],
                                                              "longitude":
                                                                  elements[
                                                                      'longitude'],
                                                              "volunteer": elements[
                                                                      'number_volunteers']
                                                                  as int,
                                                              "current": elements[
                                                                      'current_volunteers']
                                                                  as int,
                                                              "campaignID":
                                                                  elements[
                                                                      'campaignID']
                                                            });
                                                          });
                                                        });
                                                      }
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff65BFB8),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Text('Volunteers',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      showInProgress =
                                                          !showInProgress;

                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'campaigns')
                                                          .where('inProgress',
                                                              isEqualTo: true)
                                                          .get()
                                                          .then((element) {
                                                        element.docs.forEach(
                                                            (elements) {
                                                          getInProgress.add({
                                                            "latitude":
                                                                elements[
                                                                    'latitude'],
                                                            "longitude":
                                                                elements[
                                                                    'longitude'],
                                                            "radius": elements[
                                                                'radius'],
                                                            "campaignID":
                                                                elements[
                                                                    'campaignID']
                                                          });
                                                        });
                                                      });
                                                      showLatLng = !showLatLng;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff65BFB8),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Text('In Progress',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      showCompleted =
                                                          !showCompleted;
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'campaigns')
                                                          .where('isCompleted',
                                                              isEqualTo: true)
                                                          .get()
                                                          .then((element) {
                                                        element.docs.forEach(
                                                            (elements) {
                                                          getIsCompleted.add({
                                                            "latitude":
                                                                elements[
                                                                    'latitude'],
                                                            "longitude":
                                                                elements[
                                                                    'longitude'],
                                                            "radius": elements[
                                                                'radius'],
                                                            "campaignID":
                                                                elements[
                                                                    'campaignID']
                                                          });
                                                        });
                                                      });
                                                      showLatLng = !showLatLng;
                                                    });
                                                  },
                                                  child: Container(
                                                    width: 100,
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff65BFB8),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Text('Completed',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor)),
                                                  ),
                                                )
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Color(0xff65BFB8),
                                          size: 30,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          AnimatedOpacity(
                                            duration:
                                                Duration(milliseconds: 500),
                                            opacity: clicked ? 1 : 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.transparent),
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          cntrler.move(
                                                              lt.LatLng(
                                                                  14.918990,
                                                                  121.165563),
                                                              13);
                                                          clicked = false;
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 50,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          child: Center(
                                                              child: Text(
                                                                  'Angat\nWatershed')))),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          cntrler.move(
                                                              lt.LatLng(14.7452,
                                                                  121.0984),
                                                              13);

                                                          clicked = false;
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 50,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          child: Center(
                                                              child: Text(
                                                                  'La Mesa \nWatershed')))),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          cntrler.move(
                                                              lt.LatLng(
                                                                  15.780574,
                                                                  121.121838),
                                                              13);
                                                          clicked = false;
                                                        });
                                                      },
                                                      child: Container(
                                                          height: 50,
                                                          width: 100,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                          child: Center(
                                                              child: Text(
                                                                  'Pantabangan \nWatershed')))),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                clicked = true;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                  color: Color(0xff65BFB8)),
                                              height: 50,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Center(
                                                child: Text(
                                                  'Choose Forest',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                SlideTransition(
                                    position: Tween<Offset>(
                                            begin: Offset(0, 1.2),
                                            end: Offset(0, 0.4))
                                        .animate(
                                      new CurvedAnimation(
                                          parent: controller,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                    child: SliderWidget(
                                      done: GestureDetector(
                                        onTap: () async {
                                          const _chars =
                                              'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                          Random _rnd = Random();

                                          String getRandomString(int length) =>
                                              String.fromCharCodes(
                                                  Iterable.generate(
                                                      length,
                                                      (_) => _chars.codeUnitAt(
                                                          _rnd.nextInt(
                                                              _chars.length))));
                                          String uniqueID = getRandomString(15);
                                          setState(() {
                                            dateCreated = formatDate(
                                                DateTime.now(),
                                                [yyyy, '-', mm, '-', dd]);

                                            dateStart = formatDate(
                                                DateTime(
                                                    2021, 10, 27, 2, 30, 50),
                                                [yyyy, '-', mm, '-', dd]);

                                            dateEnded = formatDate(
                                                DateTime(
                                                    2021, 10, 27, 2, 30, 50),
                                                [yyyy, '-', mm, '-', dd]);

                                            time = formatDate(
                                                DateTime(
                                                    2021, 09, 27, 2, 30, 50),
                                                [HH, ':', nn, ':', ss]);

                                            FirebaseMessaging.instance
                                                .getToken()
                                                .then((value) {
                                              context
                                                  .read(authserviceProvider)
                                                  .createCampaign(
                                                      context
                                                          .read(
                                                              campaignProvider)
                                                          .getCampaignName,
                                                      context
                                                          .read(
                                                              campaignProvider)
                                                          .getDescription,
                                                      uniqueID,
                                                      dateCreated,
                                                      context
                                                          .read(
                                                              campaignProvider)
                                                          .getStartDate,
                                                      dateEnded,
                                                      context
                                                          .read(
                                                              campaignProvider)
                                                          .getAddress,
                                                      context
                                                          .read(
                                                              campaignProvider)
                                                          .getCity,
                                                      time,
                                                      userUID,
                                                      usernames,
                                                      latitude,
                                                      longitude,
                                                      finalSeeds,
                                                      currentDonations,
                                                      finalFund,
                                                      currentVolunteers,
                                                      finalVolunteers,
                                                      value!,
                                                      finalRadius)
                                                  .whenComplete(() =>
                                                      controller.reverse());
                                            });
                                          });
                                        },
                                        child: Container(
                                            height: 55,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Color(0xff65BFB8),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Center(
                                              child: Text(
                                                'Done',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                              ),
                                            )),
                                      ),
                                      status: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(children: [
                                            Text(
                                              "Volunteers:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              finalVolunteers.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 25),
                                            )
                                          ]),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Column(children: [
                                            Text(
                                              "Seeds:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(finalSeeds.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 25))
                                          ]),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Column(children: [
                                            Text(
                                              "Fund Needed:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(finalFund.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 25))
                                          ]),
                                        ],
                                      ),
                                      radius: radius,
                                      back: IconButton(
                                        icon: Icon(Icons.arrow_back_ios),
                                        onPressed: () {
                                          setState(() {
                                            controller.reverse();
                                          });
                                        },
                                      ),
                                      slide: Center(
                                        child: Column(
                                          children: [
                                            Slider(
                                              activeColor: Colors.green,
                                              inactiveColor: Colors.red,
                                              value: radius,
                                              min: 0,
                                              max: 0.10,
                                              onChanged: (radius1) {
                                                setState(() {
                                                  radius = radius1;

                                                  context
                                                      .read(mapProvider)
                                                      .RadiusAssign(radius);
                                                  putCircle(finalRadius,
                                                      latitude, longitude);

                                                  context
                                                      .read(mapProvider)
                                                      .checkVolunteersNeeded(
                                                          finalRadius);
                                                  context
                                                      .read(mapProvider)
                                                      .checkseedsNeeded(
                                                          finalRadius);
                                                  context
                                                      .read(mapProvider)
                                                      .checkFundRequired(
                                                          finalRadius);
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            );
                          }
                        }),
                  ));
            }
          });
    }));
  }
}
