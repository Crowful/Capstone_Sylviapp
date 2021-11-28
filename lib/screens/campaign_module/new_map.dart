import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
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

  GlobalKey _toolTipKey = GlobalKey();
  bool showForest = false;
  bool showActive = false;
  bool showInProgress = false;
  bool showInactive = false;
  bool showLatLng = false;
  bool showLayers = false;
  bool shouldPop = true;
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
  bool focused = false;
  bool focused1 = false;
  bool camName = false;
  bool camDes = false;
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
  PageController pageController = PageController();
  TextEditingController campaignNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  bool isOrganizer = false;
  bool createMode = false;
  bool isOpened = false;
  bool isApplicable = false;
  List<Map<String, dynamic>> circleMarkersCampaigns =
      List.empty(growable: true);

  List<Map<String, dynamic>> existingCampaign = List.empty(growable: true);
  List<Map<String, dynamic>> getVolunteers = List.empty(growable: true);
  List<Map<String, dynamic>> getActive = List.empty(growable: true);
  List<Map<String, dynamic>> getProgress = List.empty(growable: true);
  List<Map<String, dynamic>> getDone = List.empty(growable: true);

  lt.LatLng? _initialCameraPosition = lt.LatLng(14.7452, 121.0984);

  void getBalance() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) {
      var balance = value.get('balance');
      if (balance > 50) {
        setState(() {
          isApplicable = true;
        });
      } else {
        setState(() {
          isApplicable = false;
        });
      }
    });
  }

  var selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now())
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();

    getBalance();
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) => usernames = AESCryptography()
            .decryptAES(enc.Encrypted.from64(value['username'])));

    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) => isVerified = value['isVerify']);
  }

  @override
  void dispose() {
    super.dispose();
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

              return KeyboardDismissOnTap(
                child: Scaffold(
                    resizeToAvoidBottomInset: true,
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
                                            latlngpolygonlistLamesa.add(
                                                lt.LatLng(pts["latitude"],
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
                                              builder:
                                                  (context, snapshotAngat) {
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
                                                        lt.LatLng(
                                                            pts["latitude"],
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
                                                          .collection(
                                                              'polygons')
                                                          .get(),
                                                      builder: (context,
                                                          snapshotPantabangan) {
                                                        if (!snapshotPantabangan
                                                            .hasData) {
                                                          return CircularProgressIndicator();
                                                        } else {
                                                          snapshotPantabangan
                                                              .data!.docs
                                                              .forEach(
                                                                  (element) {
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
                                                                      .data!
                                                                      .docs
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

                                                                  return Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.6,
                                                                        child: fmap.FlutterMap(
                                                                            mapController: cntrler,
                                                                            options: fmap.MapOptions(
                                                                                onTap: (tapPosition, latlngs) {},
                                                                                onLongPress: (tapPosition, latlng) {
                                                                                  if (createMode == true) {
                                                                                    if (status == "ECQ" || status == "MECQ" || status == "GCQ") {
                                                                                      Fluttertoast.showToast(msg: "The area is still in lockdown.");
                                                                                    } else {
                                                                                      if (isApplicable == true) {
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
                                                                                          pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                                                                                          print('gana e');
                                                                                          latitude = latlng.latitude;
                                                                                          longitude = latlng.longitude;
                                                                                          testlatlng = latlng;
                                                                                          controller.forward();
                                                                                          cntrler.move(lt.LatLng(latlng.latitude - 0.0050, latlng.longitude), 16);
                                                                                        } else if (isPointValid == false) {
                                                                                          print(isPointValid);
                                                                                          Fluttertoast.showToast(msg: "You cannot put campaign there");
                                                                                        }
                                                                                      } else {
                                                                                        Fluttertoast.showToast(msg: 'You do not have enough balance to create a campaign');
                                                                                      }
                                                                                    }
                                                                                  } else {
                                                                                    Fluttertoast.showToast(msg: "Please go into create mode before proceeding.");
                                                                                  }
                                                                                },
                                                                                center: _initialCameraPosition,
                                                                                zoom: 13),
                                                                            layers: [
                                                                              fmap.TileLayerOptions(
                                                                                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                                                subdomains: [
                                                                                  'a',
                                                                                  'b',
                                                                                  'c'
                                                                                ],
                                                                                attributionBuilder: (_) {
                                                                                  return const Text("");
                                                                                },
                                                                              ),
                                                                              fmap.PolygonLayerOptions(polygons: [
                                                                                fmap.Polygon(points: latlngpolygonlistLamesa, color: Colors.green.withOpacity(0.5), borderColor: Colors.green, borderStrokeWidth: 1),
                                                                              ]),
                                                                              fmap.PolygonLayerOptions(polygons: [
                                                                                fmap.Polygon(points: latlngpolygonlistPantabangan, color: Colors.green.withOpacity(0.5), borderColor: Colors.green, borderStrokeWidth: 1),
                                                                              ]),
                                                                              fmap.PolygonLayerOptions(polygons: [
                                                                                fmap.Polygon(points: latlngpolygonlistAngat, color: Colors.green.withOpacity(0.5), borderColor: Colors.green, borderStrokeWidth: 1),
                                                                              ]),
                                                                              for (var info in existingCampaign)
                                                                                fmap.CircleLayerOptions(circles: [
                                                                                  fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: double.parse(info.values.elementAt(2).toString()), borderColor: Colors.red, borderStrokeWidth: 1, color: Colors.red.withOpacity(0.2)),
                                                                                ]),
                                                                              for (var info in existingCampaign)
                                                                                fmap.MarkerLayerOptions(markers: [
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
                                                                                for (var info in getActive)
                                                                                  fmap.MarkerLayerOptions(markers: [
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
                                                                                for (var info in getVolunteers)
                                                                                  fmap.MarkerLayerOptions(markers: [
                                                                                    fmap.Marker(
                                                                                        width: 120,
                                                                                        point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                        builder: (context) {
                                                                                          return Text(info.values.elementAt(2).toString() + " Volunteers");
                                                                                        })
                                                                                  ]),
                                                                              ],
                                                                              for (var info in circleMarkersCampaigns)
                                                                                fmap.CircleLayerOptions(circles: [
                                                                                  fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: info.values.elementAt(2), borderColor: Colors.red, borderStrokeWidth: 1, color: Colors.red.withOpacity(0.2))
                                                                                ])
                                                                            ]),
                                                                      ),
                                                                      Expanded(
                                                                        child: Container(
                                                                            padding: EdgeInsets.all(15),
                                                                            child: Consumer(builder: (context, watch, child) {
                                                                              double radius = 0;
                                                                              double finalRadius = 0;
                                                                              double radiusTest = 0;
                                                                              final radiusProvider = watch(mapProvider);
                                                                              int finalVolunteers = radiusProvider.volunteersRequired;
                                                                              int finalSeeds = radiusProvider.seedsRequired;
                                                                              double finalFund = radiusProvider.fundRequired;
                                                                              finalRadius = radiusProvider.valueRadius;
                                                                              child:
                                                                              return PageView(
                                                                                controller: pageController,
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                children: [
                                                                                  firstPage(),
                                                                                  secondPage(finalFund: finalFund, finalRadius: finalRadius, finalSeeds: finalSeeds, finalVolunteers: finalVolunteers, radius: radius),
                                                                                  thirdPage(),
                                                                                  fourthPage(finalFund: finalFund, finalRadius: finalRadius, finalSeeds: finalSeeds, userUID: userUID, finalVolunteers: finalVolunteers)
                                                                                ],
                                                                              );
                                                                            })),
                                                                      )
                                                                    ],
                                                                  );
                                                                }
                                                              });
                                                        }
                                                      });
                                                }
                                              });
                                        }
                                      }),
                                  FadeAnimation(
                                    0.1,
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                0, 10, 0, 0),
                                            child: Card(
                                              elevation: 20,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Color(0xff65BFB8),
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                  FadeAnimation(
                                    0.2,
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: createMode
                                              ? Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 25),
                                                  child: Card(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              20, 20, 20, 20),
                                                      child: Text(
                                                        'Create Mode',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ))
                                              : Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 25),
                                                  child: Card(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              20, 20, 20, 20),
                                                      child: Text(
                                                        'View Mode',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ))),
                                    ),
                                  ),
                                  KeyboardVisibilityBuilder(
                                      builder: (context, visible) {
                                    return IgnorePointer(
                                      ignoring: true,
                                      child: AnimatedOpacity(
                                        opacity: visible ? 1 : 0,
                                        duration: Duration(milliseconds: 500),
                                        child: Opacity(
                                          opacity: camName ? 1 : 0,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              height: 200,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Campaign Name',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Card(
                                                    elevation: 10,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      width: double.infinity,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor),
                                                      child: Text(
                                                        context
                                                            .read(
                                                                campaignProvider)
                                                            .getCampaignName
                                                            .toString(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  KeyboardVisibilityBuilder(
                                      builder: (context, visible) {
                                    return IgnorePointer(
                                      ignoring: true,
                                      child: AnimatedOpacity(
                                        opacity: visible ? 1 : 0,
                                        duration: Duration(milliseconds: 500),
                                        child: Opacity(
                                          opacity: camDes ? 1 : 0,
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              height: 200,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Campaign Description',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(20),
                                                    width: double.infinity,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        color: Theme.of(context)
                                                            .cardColor),
                                                    child: Text(
                                                      context
                                                          .read(
                                                              campaignProvider)
                                                          .getDescription
                                                          .toString(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              );
                            }
                          }),
                    )),
              );
            }
          }),
    );
  }

  Widget firstPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeAnimation(
          0.2,
          Text(
            'Hello ' + 'Organizer',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        FadeAnimation(
          0.3,
          Text('Current Balance: ' + 'P1000',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 13)),
        ),
        Divider(
            height: 15,
            endIndent: 15,
            indent: 15,
            thickness: 0.5,
            color: Colors.grey),
        FadeAnimation(
          0.4,
          Text(
            'Layers and Stats',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),
        FadeAnimation(
          0.5,
          Text('Futher information in campaign... Click one to show in map.',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        FadeAnimation(
          0.6,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Row(
              children: [
                Container(
                    width: 150,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('Show Volunteers'))),
                Container(
                    width: 150,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('10 ' + 'Active Campaign'))),
                Container(
                    width: 150,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('10 ' + 'Active Campaign'))),
                Container(
                    width: 150,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(child: Text('10 ' + 'Active Campaign'))),
              ],
            ),
          ),
        ),
        Divider(
            height: 20,
            endIndent: 15,
            indent: 15,
            thickness: 0.5,
            color: Colors.grey),
        FadeAnimation(
          0.7,
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                return chooseForest();
              }));
            },
            child: Row(
              children: [
                Text('🌳 Choose Forest'),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        ),
        Divider(
            height: 20,
            endIndent: 15,
            indent: 15,
            thickness: 0.5,
            color: Colors.grey),
        FadeAnimation(
          0.8,
          GestureDetector(
            onTap: () {
              if (isVerified == true) {
                setState(() {
                  createMode = !createMode;
                });

                if (createMode == true) {
                  Fluttertoast.showToast(msg: "In create mode.");
                } else {
                  Fluttertoast.showToast(msg: "Disabled create mode.");
                }
              }
            },
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xff65BFB8)),
              child: Center(
                child: Text('Create Campaign'),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget secondPage(
      {required int finalVolunteers,
      required int finalSeeds,
      required double finalFund,
      required double finalRadius,
      required double radius}) {
    return Consumer(builder: (context, watch, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FadeAnimation(
                0.1,
                Text('Create Campaign',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: Color(0xff65BFB8))),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Slide to see the requirements of your desired campaign',
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: Colors.grey)),
              SizedBox(
                height: 20,
              ),
              FadeAnimation(
                0.2,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(children: [
                            Text(
                              "Volunteers:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              finalVolunteers.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 15),
                            )
                          ]),
                          SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            Text(
                              "Seeds:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(finalSeeds.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 15))
                          ]),
                          SizedBox(
                            width: 30,
                          ),
                          Column(children: [
                            Text(
                              "Fund Needed:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(finalFund.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 15))
                          ]),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                  ],
                ),
              ),
              FadeAnimation(
                0.3,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Number of Seeds'),
                          SizedBox(
                            width: 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              final dynamic _toolTip = _toolTipKey.currentState;
                              _toolTip.ensureTooltipVisible();
                            },
                            child: Tooltip(
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              key: _toolTipKey,
                              message:
                                  "Number of seeds will determine the radius of the Campaign.",
                              child: Icon(
                                Icons.help_rounded,
                                color: Colors.black.withOpacity(0.7),
                                size: 13,
                              ),
                            ),
                          )
                        ]),
                  ],
                ),
              ),
              FadeAnimation(
                0.4,
                Center(
                  child: Column(
                    children: [
                      Slider(
                        activeColor: Color(0xff65BFB8),
                        inactiveColor: Color(0xff65BFB8).withOpacity(0.4),
                        value: finalRadius,
                        min: 0,
                        max: 100,
                        onChanged: (newValue) {
                          setState(() {
                            radius = newValue;
                            context.read(mapProvider).RadiusAssign(radius);
                            finalRadius = newValue;
                          });

                          putCircle(finalRadius, latitude, longitude);

                          context
                              .read(mapProvider)
                              .checkVolunteersNeeded(finalRadius);

                          context
                              .read(mapProvider)
                              .checkseedsNeeded(finalRadius);

                          context
                              .read(mapProvider)
                              .checkFundRequired(finalRadius);
                        },
                      )
                    ],
                  ),
                ),
              ),
              FadeAnimation(
                0.5,
                Text(
                    'Your campaign will not go directly to the active campaigns, it wil review first by sylviapp. Enjoy creating campaign organizer !',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
              ),
              FadeAnimation(
                0.6,
                GestureDetector(
                  onTap: () {
                    pageController.animateToPage(2,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xff65BFB8)),
                    child: Center(
                      child: Text('Next'),
                    ),
                  ),
                ),
              )
            ]),
      );
    });
  }

  Widget thirdPage() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('About the Campaign',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color(0xff65BFB8))),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 5,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Campaign Name',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.299),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  height: 40,
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        focused = !focused;
                        if (focused == true) {
                          camName = true;
                        } else {
                          camName = false;
                        }
                      },
                      child: TextField(
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
                        controller: campaignNameController,
                        onChanged: (value) {
                          setState(() {
                            context
                                .read(campaignProvider)
                                .setCampaignName(value);
                          });
                        },
                        decoration: InputDecoration(
                            focusColor: Color(0xff65BFB8),
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.299),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus2) {
                        focused1 = !focused1;
                        if (focused1 == true) {
                          camDes = true;
                        } else {
                          camDes = false;
                        }
                      },
                      child: TextField(
                        maxLines: 5,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(150)
                        ],
                        controller: descriptionController,
                        onChanged: (value) {
                          setState(() {
                            context
                                .read(campaignProvider)
                                .setDescription(value);
                          });
                        },
                        decoration: InputDecoration(
                            focusColor: Color(0xff65BFB8),
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pageController.animateToPage(3,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                });
              },
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xff65BFB8),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget fourthPage(
      {required String userUID,
      required int finalSeeds,
      required double finalFund,
      required int finalVolunteers,
      required double finalRadius}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Campaign Information',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: Color(0xff65BFB8))),
          SizedBox(
            height: 10,
          ),
          Text(
              'Input the City of the campaign, the meetup address and the desired date you want the campaign to start',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.black54)),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('City'),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 200,
                height: 50,
                child: TextField(
                  controller: cityController,
                  onChanged: (value) =>
                      {context.read(campaignProvider).setCityName(value)},
                  decoration: InputDecoration(
                      focusColor: Color(0xff65BFB8),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Address'),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                width: 200,
                height: 50,
                child: TextField(
                  controller: addressController,
                  onChanged: (value) =>
                      {context.read(campaignProvider).setAddress(value)},
                  decoration: InputDecoration(
                      focusColor: Color(0xff65BFB8),
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date Start'),
              GestureDetector(
                onTap: () async {
                  await _selectDate(context).whenComplete(() {
                    if (selectedDate != null) {
                      context
                          .read(campaignProvider)
                          .setStartingDate(selectedDate.toString());
                    } else {
                      Fluttertoast.showToast(msg: 'you did not select a date');
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.orangeAccent.withOpacity(0.6),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  width: 200,
                  height: 50,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.date_range)),
                  ),
                  // child: TextField(
                  //   onChanged: (value) =>
                  //       {context.read(campaignProvider).setStartingDate(value)},
                  //   decoration: InputDecoration(
                  //       focusColor: Color(0xff65BFB8),
                  //       contentPadding: EdgeInsets.all(15),
                  //       border: InputBorder.none),
                  // ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              const _chars =
                  'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
              Random _rnd = Random();

              String getRandomString(int length) =>
                  String.fromCharCodes(Iterable.generate(length,
                      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
              String uniqueID = getRandomString(15);
              setState(() {
                dateCreated =
                    formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

                dateStart = formatDate(DateTime(2021, 10, 27, 2, 30, 50),
                    [yyyy, '-', mm, '-', dd]);

                dateEnded = formatDate(DateTime(2021, 10, 27, 2, 30, 50),
                    [yyyy, '-', mm, '-', dd]);

                time = formatDate(
                    DateTime(2021, 09, 27, 2, 30, 50), [HH, ':', nn, ':', ss]);
              });
              FirebaseMessaging.instance.getToken().then((value) {
                context
                    .read(authserviceProvider)
                    .createCampaign(
                        context.read(campaignProvider).getCampaignName,
                        context.read(campaignProvider).getDescription,
                        uniqueID,
                        dateCreated,
                        context.read(campaignProvider).getStartDate,
                        dateEnded,
                        context.read(campaignProvider).getAddress,
                        context.read(campaignProvider).getCity,
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
                    .whenComplete(() => controller.reverse());
              });
            },
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff65BFB8),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Center(
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget chooseForest() {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        height: 200,
        width: 100,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Select a Forest',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text('To view or create with...',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    cntrler.move(lt.LatLng(14.918990, 121.165563), 13);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff65BFB8), width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Text('🌳 Angat Forest',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    cntrler.move(lt.LatLng(14.7452, 121.0984), 13);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff65BFB8), width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Text('🌳 La Mesa Forest',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    cntrler.move(lt.LatLng(15.780574, 121.121838), 13);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff65BFB8), width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: Text('🌳 Pantabangan Forest',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
