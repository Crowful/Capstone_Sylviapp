import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:latlong2/latlong.dart' as lt;
import 'package:sylviapp_project/widgets/campaign_module/slidable.dart';

class MapCampaign extends StatefulWidget {
  const MapCampaign({Key? key}) : super(key: key);

  @override
  _MapCampaignState createState() => _MapCampaignState();
}

class _MapCampaignState extends State<MapCampaign>
    with TickerProviderStateMixin {
  late AnimationController controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  double radius = 0;
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

  bool showLatLng = false;
  bool showLayers = false;
  int numSeeds = 0;
  double currentDonations = 10000.00;
  double maxDonations = 10000.00;
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

  lt.LatLng? _initialCameraPosition = lt.LatLng(14.7452, 121.0984);
  double finalRadius = 0;

  @override
  void initState() {
    super.initState();
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
    dynamic userUID = context.read(authserviceProvider).getCurrentUserUID();
    return SafeArea(child: Consumer(builder: (context, watch, child) {
      final radiusProvider = watch(mapProvider);
      int finalVolunteers = radiusProvider.volunteersRequired;
      int finalSeeds = radiusProvider.seedsRequired;
      int finalFund = radiusProvider.fundRequired;
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
              var data = snapshot.data!.data();
              bool isVerified = data!['isVerify'];
              Widget add() {
                return SizedBox(
                  child: AbsorbPointer(
                    absorbing: false,
                    child: FloatingActionButton(
                      heroTag: "herotag1",
                      backgroundColor:
                          createMode ? Color(0xff65BFB8) : Colors.grey,
                      onPressed: () {
                        print(createMode);
                        setState(() {
                          createMode = !createMode;
                        });
                      },
                      child: Icon(Icons.add),
                    ),
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
                          print(isVerified);
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
                  body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('quarantineStatus')
                        .doc('status')
                        .snapshots(),
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
                                      pointlist =
                                          List<dynamic>.from(element['points']);
                                    });

                                    for (var pts in pointlist) {
                                      latlngpolygonlistLamesa.add(lt.LatLng(
                                          pts["latitude"], pts["longitude"]));
                                    }

                                    for (var pts in latlngpolygonlistLamesa) {
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
                                              pointlist = List<dynamic>.from(
                                                  element['points']);
                                            });

                                            for (var pts in pointlist) {
                                              latlngpolygonlistAngat.add(
                                                  lt.LatLng(pts["latitude"],
                                                      pts["longitude"]));
                                            }

                                            for (var pts
                                                in latlngpolygonlistAngat) {
                                              mtkPolygonAngat.add(mtk.LatLng(
                                                  pts.latitude, pts.longitude));
                                            }
                                            return FutureBuilder<QuerySnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('polygon')
                                                    .doc('Pantabangan_Forest')
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
                                                      pointlist =
                                                          List<dynamic>.from(
                                                              element[
                                                                  'points']);
                                                    });

                                                    for (var pts in pointlist) {
                                                      latlngpolygonlistPantabangan
                                                          .add(lt.LatLng(
                                                              pts["latitude"],
                                                              pts["longitude"]));
                                                    }

                                                    for (var pts
                                                        in latlngpolygonlistPantabangan) {
                                                      mtkPolygonPantabangan.add(
                                                          mtk.LatLng(
                                                              pts.latitude,
                                                              pts.longitude));
                                                    }
                                                    return FutureBuilder<
                                                            QuerySnapshot>(
                                                        future:
                                                            FirebaseFirestore
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
                                                            snapshotCampaigns
                                                                .data!.docs
                                                                .forEach(
                                                                    (element) {
                                                              existingCampaign
                                                                  .add({
                                                                "latitude": element[
                                                                    'latitude'],
                                                                "longitude":
                                                                    element[
                                                                        'longitude'],
                                                                "radius": element[
                                                                        'radius'] *
                                                                    10,
                                                                "uid": element[
                                                                    'campaignID']
                                                              });
                                                            });

                                                            return fmap.FlutterMap(
                                                                mapController: cntrler,
                                                                options: fmap.MapOptions(
                                                                    onLongPress: (tapPosition, latlng) {
                                                                      if (createMode ==
                                                                          true) {
                                                                        if (status == "ECQ" ||
                                                                            status ==
                                                                                "MECQ" ||
                                                                            status ==
                                                                                "GCQ") {
                                                                          Fluttertoast.showToast(
                                                                              msg: "The area is still in lockdown.");
                                                                        } else {
                                                                          mtk.LatLng
                                                                              latlngtoMTK =
                                                                              mtk.LatLng(latlng.latitude, latlng.longitude);

                                                                          List<mtk.LatLng>
                                                                              mtkPolygonAngat =
                                                                              List.empty(growable: true);
                                                                          latlngpolygonlistAngat
                                                                              .forEach((element) {
                                                                            mtkPolygonAngat.add(mtk.LatLng(element.latitude,
                                                                                element.longitude));
                                                                          });

                                                                          List<mtk.LatLng>
                                                                              mtkPolygonPanbatanbangan =
                                                                              List.empty(growable: true);
                                                                          latlngpolygonlistPantabangan
                                                                              .forEach((element) {
                                                                            mtkPolygonPanbatanbangan.add(mtk.LatLng(element.latitude,
                                                                                element.longitude));
                                                                          });

                                                                          isPointValid =
                                                                              mtk.PolygonUtil.containsLocation(latlngtoMTK, mtkPolygonLamesa, false) || mtk.PolygonUtil.containsLocation(latlngtoMTK, mtkPolygonAngat, false);

                                                                          if (isPointValid ==
                                                                              true) {
                                                                            setState(() {
                                                                              print('gana e');
                                                                              latitude = latlng.latitude;

                                                                              longitude = latlng.longitude;
                                                                              testlatlng = latlng;
                                                                              putCircle(finalRadius, latitude, longitude);
                                                                              cntrler.move(lt.LatLng(latlng.latitude - 0.0050, latlng.longitude), 16);
                                                                            });
                                                                          } else if (isPointValid ==
                                                                              false) {
                                                                            print('ayaw e');
                                                                            Fluttertoast.showToast(msg: "You cannot put campaign there");
                                                                          }
                                                                        }
                                                                      } else {
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                                "You are not verified yet, please submit application first.");
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
                                                                            points:
                                                                                latlngpolygonlistLamesa,
                                                                            color:
                                                                                Colors.green.withOpacity(0.5),
                                                                            borderColor: Colors.green,
                                                                            borderStrokeWidth: 1),
                                                                      ]),
                                                                  fmap.PolygonLayerOptions(
                                                                      polygons: [
                                                                        fmap.Polygon(
                                                                            points:
                                                                                latlngpolygonlistPantabangan,
                                                                            color:
                                                                                Colors.green.withOpacity(0.5),
                                                                            borderColor: Colors.green,
                                                                            borderStrokeWidth: 1),
                                                                      ]),
                                                                  fmap.PolygonLayerOptions(
                                                                      polygons: [
                                                                        fmap.Polygon(
                                                                            points:
                                                                                latlngpolygonlistAngat,
                                                                            color:
                                                                                Colors.green.withOpacity(0.5),
                                                                            borderColor: Colors.green,
                                                                            borderStrokeWidth: 1),
                                                                      ]),
                                                                  for (var info
                                                                      in existingCampaign)
                                                                    fmap.CircleLayerOptions(
                                                                        circles: [
                                                                          fmap.CircleMarker(
                                                                              point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                              radius: info.values.elementAt(2),
                                                                              borderColor: Colors.red,
                                                                              borderStrokeWidth: 1,
                                                                              color: Colors.red.withOpacity(0.2))
                                                                        ]),
                                                                  if (showLatLng) ...[
                                                                    for (var info
                                                                        in existingCampaign)
                                                                      fmap.MarkerLayerOptions(
                                                                          markers: [
                                                                            fmap.Marker(
                                                                                point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                builder: (context) {
                                                                                  return Text(info.values.elementAt(0).toString());
                                                                                })
                                                                          ]),
                                                                  ],
                                                                  for (var info
                                                                      in circleMarkersCampaigns)
                                                                    fmap.CircleLayerOptions(
                                                                        circles: [
                                                                          fmap.CircleMarker(
                                                                              point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                              radius: info.values.elementAt(2),
                                                                              color: Colors.red)
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
                                padding: EdgeInsets.all(10),
                                child: Column(
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
                                        )),
                                    AnimatedOpacity(
                                        opacity: showLayers ? 1 : 0,
                                        duration: Duration(milliseconds: 300),
                                        child: Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showLatLng = !showLatLng;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.trip_origin_sharp,
                                                  size: 30,
                                                )),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.layers,
                                                  size: 30,
                                                )),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          width: 50,
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                  0.0,
                                                  _translateButton.value * 3.0,
                                                  0.0,
                                                ),
                                                child: add(),
                                              ),
                                              Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                  0.0,
                                                  _translateButton.value * 2.0,
                                                  0.0,
                                                ),
                                                child: image(),
                                              ),
                                              toggle(),
                                            ],
                                          ))
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
                                        dateCreated = formatDate(DateTime.now(),
                                            [yyyy, '-', mm, '-', dd]);

                                        dateStart = formatDate(
                                            DateTime(2021, 10, 27, 2, 30, 50),
                                            [yyyy, '-', mm, '-', dd]);

                                        dateEnded = formatDate(
                                            DateTime(2021, 10, 27, 2, 30, 50),
                                            [yyyy, '-', mm, '-', dd]);

                                        time = formatDate(
                                            DateTime(2021, 09, 27, 2, 30, 50),
                                            [HH, ':', nn, ':', ss]);

                                        context
                                            .read(authserviceProvider)
                                            .createCampaign(
                                                context
                                                    .read(campaignProvider)
                                                    .getCampaignName,
                                                context
                                                    .read(campaignProvider)
                                                    .getDescription,
                                                uniqueID,
                                                dateCreated,
                                                context
                                                    .read(campaignProvider)
                                                    .getStartDate,
                                                dateEnded,
                                                context
                                                    .read(campaignProvider)
                                                    .getAddress,
                                                context
                                                    .read(campaignProvider)
                                                    .getCity,
                                                time,
                                                userUID,
                                                usernames,
                                                latitude,
                                                longitude,
                                                finalSeeds,
                                                currentDonations,
                                                maxDonations,
                                                currentVolunteers,
                                                finalVolunteers,
                                                radius)
                                            .whenComplete(
                                                () => controller.reverse());
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
                                    children: [
                                      Text("Volunteers: " +
                                          finalVolunteers.toString()),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text("Seeds: " + finalSeeds.toString()),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Expanded(
                                          child: Text("Fund Needed: " +
                                              finalFund.toString() +
                                              "pesos")),
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
                                              putCircle(finalRadius, latitude,
                                                  longitude);

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
