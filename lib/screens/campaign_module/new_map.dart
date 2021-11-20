import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:sylviapp_project/screens/campaign_module/join_donate.dart';
import 'package:sylviapp_project/widgets/campaign_module/slidable.dart';

class MapCampaign extends StatefulWidget {
  const MapCampaign({Key? key}) : super(key: key);

  @override
  _MapCampaignState createState() => _MapCampaignState();
}

class _MapCampaignState extends State<MapCampaign>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _keyMap = GlobalKey<ScaffoldState>();

  late AnimationController controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  String uid = "";

  bool isVerified = false;
  late String userHolder;
  late AnimationController _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500))
        ..addListener(() {
          setState(() {});
        });
  late Animation<Color?> _buttonColor = ColorTween(
    begin: Colors.blue,
    end: Colors.red,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(
      0.00,
      1.00,
      curve: Curves.linear,
    ),
  ));
  late Animation<double> _animateIcon =
      Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  late Animation<double> _translateButton = Tween<double>(
    begin: _fabHeight,
    end: -14.0,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Interval(
      0.0,
      0.75,
      curve: _curve,
    ),
  ));
  bool showForest = false;
  bool showActive = false;
  bool showInProgress = false;
  bool showInactive = false;
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
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
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
  List<Map<String, dynamic>> getVolunteers = List.empty(growable: true);
  List<Map<String, dynamic>> getActive = List.empty(growable: true);
  List<Map<String, dynamic>> getProgress = List.empty(growable: true);
  List<Map<String, dynamic>> getDone = List.empty(growable: true);

  lt.LatLng? _initialCameraPosition = lt.LatLng(14.7452, 121.0984);
  double finalRadius = 0;

  @override
  void initState() {
    super.initState();
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
    circleMarkersCampaigns.clear();
    circleMarkersCampaigns.add({
      "latitude": latitude,
      "longitude": longitude,
      "radius": radius1,
      "uid": 'campaignUid'
    });
  }

  @override
  Widget build(BuildContext context) {
    dynamic userUID = context.read(authserviceProvider).getCurrentUserUID();
    return SafeArea(
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future:
              FirebaseFirestore.instance.collection('users').doc(userUID).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var data = snapshot.data!.data();
              bool isVerified = data!['isVerify'];
              Widget add() {
                return SizedBox(
                  child: FloatingActionButton(
                    heroTag: "herotag1",
                    backgroundColor:
                        isVerified ? Color(0xff65BFB8) : Colors.grey,
                    onPressed: () {
                      if (isVerified == true) {
                        createMode = !createMode;

                        if (createMode == true) {
                          Fluttertoast.showToast(msg: "In create mode.");
                        } else {
                          Fluttertoast.showToast(msg: "Disabled create mode.");
                        }
                      }
                    },
                    child: Icon(Icons.add),
                  ),
                );
              }

              Widget image() {
                return Container(
                  child: FittedBox(
                    child: AbsorbPointer(
                      absorbing: isVerified ? false : true,
                      child: FloatingActionButton(
                        heroTag: "herotag2",
                        backgroundColor: Color(0xff65BFB8),
                        onPressed: () {
                          setState(() {
                            print(isVerified);
                            showForest = !showForest;
                          });
                        },
                        tooltip: 'Image',
                        child: Icon(Icons.location_searching),
                      ),
                    ),
                  ),
                );
              }

              Widget toggle() {
                return Container(
                  child: FittedBox(
                    child: FloatingActionButton(
                      heroTag: "herotag3",
                      backgroundColor: _buttonColor.value,
                      onPressed: animate,
                      tooltip: 'Toggle',
                      child: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: _animateIcon,
                      ),
                    ),
                  ),
                );
              }

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
                            var status = statusSnapshot.data!.get('status');
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
                                                        snapshotPantabangan
                                                            .data!.docs
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
                                                                .get(),
                                                            builder: (context,
                                                                snapshotCampaigns) {
                                                              if (!snapshotCampaigns
                                                                  .hasData) {
                                                                return CircularProgressIndicator();
                                                              } else {
                                                                existingCampaign
                                                                    .clear();
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
                                                                    mapController: cntrler,
                                                                    options: fmap.MapOptions(
                                                                        onTap: (tapPosition, latlngs) {},
                                                                        onLongPress: (tapPosition, latlng) {
                                                                          if (createMode ==
                                                                              true) {
                                                                            if (status == "ECQ" ||
                                                                                status == "MECQ" ||
                                                                                status == "GCQ") {
                                                                              Fluttertoast.showToast(msg: "The area is still in lockdown.");
                                                                            } else {
                                                                              mtk.LatLng latlngtoMTK = mtk.LatLng(latlng.latitude, latlng.longitude);

                                                                              List<mtk.LatLng> mtkPolygonAngat = List.empty(growable: true);
                                                                              latlngpolygonlistAngat.forEach((element) {
                                                                                mtkPolygonAngat.add(mtk.LatLng(element.latitude, element.longitude));
                                                                              });

                                                                              List<mtk.LatLng> mtkPolygonPanbatanbangan = List.empty(growable: true);
                                                                              latlngpolygonlistPantabangan.forEach((element) {
                                                                                mtkPolygonPanbatanbangan.add(mtk.LatLng(element.latitude, element.longitude));
                                                                              });

                                                                              List<mtk.LatLng> mtkPolygonLamesa = List.empty(growable: true);
                                                                              latlngpolygonlistLamesa.forEach((element) {
                                                                                mtkPolygonLamesa.add(mtk.LatLng(element.latitude, element.longitude));
                                                                              });
                                                                              setState(() {
                                                                                isPointValid = mtk.PolygonUtil.containsLocation(latlngtoMTK, mtkPolygonLamesa, false) || mtk.PolygonUtil.containsLocation(latlngtoMTK, mtkPolygonAngat, false) || mtk.PolygonUtil.containsLocation(latlngtoMTK, mtkPolygonPantabangan, false);
                                                                              });

                                                                              if (isPointValid == true) {
                                                                                print('gana e');
                                                                                latitude = latlng.latitude;
                                                                                longitude = latlng.longitude;
                                                                                testlatlng = latlng;
                                                                                putCircle(finalRadius, latitude, longitude);
                                                                                cntrler.move(lt.LatLng(latlng.latitude - 0.0050, latlng.longitude), 16);
                                                                              } else if (isPointValid == false) {
                                                                                print(isPointValid);
                                                                                Fluttertoast.showToast(msg: "You cannot put campaign there");
                                                                              }
                                                                            }
                                                                          } else {
                                                                            Fluttertoast.showToast(msg: "Please go into create mode before proceeding.");
                                                                          }
                                                                        },
                                                                        center: _initialCameraPosition,
                                                                        zoom: 13),
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
                                                                      if (showActive) ...[
                                                                        for (var info
                                                                            in getActive)
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
                                                                      if (showLatLng) ...[
                                                                        for (var info
                                                                            in getVolunteers)
                                                                          fmap.MarkerLayerOptions(
                                                                              markers: [
                                                                                fmap.Marker(
                                                                                    width: 120,
                                                                                    point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                    builder: (context) {
                                                                                      return Text(info.values.elementAt(2).toString() + " Volunteers");
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
                                              if (isVerified == true) {
                                                setState(() {
                                                  createMode = !createMode;
                                                });

                                                if (createMode == true) {
                                                  Fluttertoast.showToast(
                                                      msg: "In create mode.");
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Disabled create mode.");
                                                }
                                              }
                                            },
                                            icon: Icon(
                                              Icons.person_add_sharp,
                                              size: 30,
                                              color: Colors.grey,
                                            )),
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
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'campaigns')
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
                                                              "campaignID":
                                                                  elements[
                                                                      'campaignID']
                                                            });
                                                          });
                                                        });
                                                        showLatLng =
                                                            !showLatLng;
                                                      });
                                                    },
                                                    child: Text(
                                                        'Show Volunteers',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 17,
                                                            color: Theme.of(
                                                                    context)
                                                                .cardColor))),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'campaigns')
                                                          .where('isActive',
                                                              isEqualTo: true)
                                                          .get()
                                                          .then((element) {
                                                        element.docs.forEach(
                                                            (elements) {
                                                          getActive.add({
                                                            "latitude":
                                                                elements[
                                                                    'latitude'],
                                                            "longitude":
                                                                elements[
                                                                    'longitude'],
                                                            "volunteer": elements[
                                                                    'number_volunteers']
                                                                as int,
                                                            "campaignID":
                                                                elements[
                                                                    'campaignID']
                                                          });
                                                        });
                                                      });
                                                      showLatLng = !showLatLng;
                                                    });
                                                  },
                                                  child: Text(
                                                      'Active Campaigns',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 17,
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor)),
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
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: createMode
                                          ? Text('Create Mode')
                                          : Text('View Mode')),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      child: Card(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 20, 20, 20),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  cntrler.move(
                                                      lt.LatLng(14.918990,
                                                          121.165563),
                                                      13);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                    height: 50,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff65BFB8)),
                                                    child: Center(
                                                        child: Text(
                                                      "Angat Forest",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  cntrler.move(
                                                      lt.LatLng(
                                                          14.7452, 121.0984),
                                                      13);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                    height: 50,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff65BFB8)),
                                                    child: Center(
                                                        child: Text(
                                                      "Lamesa Forest",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  cntrler.move(
                                                      lt.LatLng(15.780574,
                                                          121.121838),
                                                      13);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    height: 50,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    2)),
                                                        color:
                                                            Color(0xff65BFB8)),
                                                    child: Center(
                                                        child: Text(
                                                            "Pantabangan Forest",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .visible)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
                                    child: Consumer(
                                        builder: (context, watch, child) {
                                      double radius = 0;
                                      double radiusTest = 0;
                                      final radiusProvider = watch(mapProvider);
                                      int finalVolunteers =
                                          radiusProvider.volunteersRequired;
                                      int finalSeeds =
                                          radiusProvider.seedsRequired;
                                      double finalFund =
                                          radiusProvider.fundRequired;
                                      finalRadius = radiusProvider.valueRadius;
                                      return SliderWidget(
                                        done: GestureDetector(
                                          onTap: () async {
                                            const _chars =
                                                'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                            Random _rnd = Random();

                                            String getRandomString(
                                                    int length) =>
                                                String.fromCharCodes(
                                                    Iterable.generate(
                                                        length,
                                                        (_) => _chars
                                                            .codeUnitAt(_rnd
                                                                .nextInt(_chars
                                                                    .length))));
                                            String uniqueID =
                                                getRandomString(15);
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Center(
                                                child: Text(
                                                  'Done',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 25))
                                            ]),
                                          ],
                                        ),
                                        radius: radius,
                                        back: IconButton(
                                          icon: Icon(Icons.arrow_back_ios,
                                              color: Colors.black),
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
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    radius = newValue;
                                                  });
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
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })),
                              ],
                            );
                          }
                        }),
                  ));
            }
          }),
    );
  }
}
