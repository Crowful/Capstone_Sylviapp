import 'dart:async';
import 'package:flutter_map/plugin_api.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
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

class MapCampaign extends StatefulWidget {
  const MapCampaign({Key? key}) : super(key: key);

  @override
  _MapCampaignState createState() => _MapCampaignState();
}

class _MapCampaignState extends State<MapCampaign>
    with TickerProviderStateMixin {
  //Keys
  GlobalKey _toolTipKey = GlobalKey();

  //doubles
  double latitude = 0;
  double longitude = 0;
  double currentDonations = 0.00;
  double maxDonations = 0.00;

  //integers
  int currentVolunteers = 0;
  int numberVolunteers = 0;
  int numSeeds = 0;
  int numberActive = 0;
  int numberOngoing = 0;
  int numberCompleted = 0;
  var balanse;
  double mainZoom = 13.0;
  double toBeDeduct = 13;

  //Strings
  String title = "title test";
  String description = " description test";
  late DateTime dateCreated;
  late String dateStart;
  late String dateEnded;
  String uid = "";
  String address = "address test";
  String city = "city test";
  late String time;
  var usernames;
  late lt.LatLng testlatlng;
  late String userHolder;

  //booleans
  bool isVerified = false;
  bool showForest = false;
  bool showActive = true;
  bool showInProgress = false;
  bool showInactive = false;
  bool showDone = false;
  bool showLatLng = false;
  bool showLayers = false;
  bool shouldPop = true;
  bool focused = false;
  bool focused1 = false;
  bool focused2 = false;
  bool focused3 = false;
  bool camName = false;
  bool camDes = false;
  bool camCity = false;
  bool camAddress = false;
  bool isPointValid = false;
  bool isOrganizer = false;
  bool createMode = false;
  bool isOpened = false;
  bool isApplicable = false;
  bool showVolunteers = false;

  //Lists
  List<lt.LatLng> latlngpolygonlistLamesa = List.empty(growable: true);
  List<lt.LatLng> latlngpolygonlistAngat = List.empty(growable: true);
  List<lt.LatLng> latlngpolygonlistPantabangan = List.empty(growable: true);
  late List<dynamic> pointlist = List.empty(growable: true);
  List<mtk.LatLng> mtkPolygonLamesa = List.empty(growable: true);
  List<mtk.LatLng> mtkPolygonAngat = List.empty(growable: true);
  List<mtk.LatLng> mtkPolygonPantabangan = List.empty(growable: true);
  List<Map<String, dynamic>> existingCampaign = List.empty(growable: true);
  List<Map<String, dynamic>> getVolunteers = List.empty(growable: true);
  List<Map<String, dynamic>> getProgress = List.empty(growable: true);
  List<Map<String, dynamic>> getDone = List.empty(growable: true);
  lt.LatLng? _initialCameraPosition = lt.LatLng(14.7452, 121.0984);
  List<Map<String, dynamic>> circleMarkersCampaigns =
      List.empty(growable: true);

  //Controllers
  fmap.MapController cntrler = fmap.MapController();
  PageController pageController = PageController();
  TextEditingController campaignNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final _streamController = StreamController<double>();
  Stream<double> get onZoomChanged => _streamController.stream;

  // ignore: close_sinks
  final _streamControllered = StreamController<double>();
  Stream<double> get onZoomChangeded => _streamControllered.stream;

  void getBalance() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) {
      var balance = value.get('balance');
      if (balance > 500) {
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

  DateTime selectedDate = new DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 15)));
    if (picked != null && picked != DateTime.now())
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) {
      balanse = value.get('balance');
    });
    getBalance();
    //get user's username
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) => usernames = AESCryptography()
            .decryptAES(enc.Encrypted.from64(value['username'])));
    //get user's balance

    //Is the user verified
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) => isVerified = value['isVerify']);

    //Get sizes campaigns
    FirebaseFirestore.instance
        .collection('campaigns')
        .where('isActive', isEqualTo: true)
        .get()
        .then((value) => numberActive = value.size);

    FirebaseFirestore.instance
        .collection('campaigns')
        .where('isCompleted', isEqualTo: true)
        .get()
        .then((value) => numberCompleted = value.size);

    FirebaseFirestore.instance
        .collection('campaigns')
        .where('inProgress', isEqualTo: true)
        .get()
        .then((value) => numberOngoing = value.size);

    //Get layers stats
    //get volunteers
    FirebaseFirestore.instance
        .collection('campaigns')
        .where('isActive', isEqualTo: true)
        .get()
        .then((element) {
      element.docs.forEach((elements) {
        getVolunteers.add({
          "latitude": elements['latitude'],
          "longitude": elements['longitude'],
          "volunteer": elements['number_volunteers'] as int,
          "current_volunteer": elements['current_volunteers'] as int,
          "campaignID": elements['campaignID']
        });
      });
    });

    //get inprogress
    FirebaseFirestore.instance
        .collection('campaigns')
        .where('inProgress', isEqualTo: true)
        .get()
        .then((element) {
      element.docs.forEach((elements) {
        getProgress.add({
          "latitude": elements['latitude'],
          "longitude": elements['longitude'],
          "volunteer": elements['number_volunteers'] as int,
          "campaignID": elements['campaignID']
        });
      });
    });

    //get completed
    FirebaseFirestore.instance
        .collection('campaigns')
        .where('isCompleted', isEqualTo: true)
        .get()
        .then((element) {
      element.docs.forEach((elements) {
        getDone.add({
          "latitude": elements['latitude'],
          "longitude": elements['longitude'],
          "volunteer": elements['number_volunteers'] as int,
          "campaignID": elements['campaignID']
        });
      });
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void putCircle(double radius1, double latitude, double longitude) {
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
    var formatter = new DateFormat('MM-dd-yyyy');
    String formattedDate = formatter.format(selectedDate);
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
              return KeyboardDismissOnTap(
                child: Scaffold(
                    resizeToAvoidBottomInset: true,
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
                              return Center(child: CircularProgressIndicator());
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
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
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
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
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
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator());
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
                                                                  .where(
                                                                      'isActive',
                                                                      isEqualTo:
                                                                          true)
                                                                  .get(),
                                                              builder: (context,
                                                                  snapshotCampaigns) {
                                                                if (!snapshotCampaigns
                                                                    .hasData) {
                                                                  return Center(
                                                                      child:
                                                                          CircularProgressIndicator());
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
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            fmap.FlutterMap(
                                                                                mapController: cntrler,
                                                                                options: fmap.MapOptions(
                                                                                    interactiveFlags: InteractiveFlag.drag | InteractiveFlag.pinchMove | InteractiveFlag.flingAnimation | InteractiveFlag.rotate,
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
                                                                                              latitude = latlng.latitude;
                                                                                              longitude = latlng.longitude;
                                                                                              testlatlng = latlng;

                                                                                              cntrler.move(lt.LatLng(latlng.latitude - 0.000, latlng.longitude), 16);
                                                                                            } else if (isPointValid == false) {
                                                                                              print(isPointValid);
                                                                                              Fluttertoast.showToast(msg: "You cannot put campaign there");
                                                                                            }
                                                                                          } else {
                                                                                            Fluttertoast.showToast(msg: 'You need 500 pesos as initial fund to the campaign');
                                                                                          }
                                                                                        }
                                                                                      } else {
                                                                                        Fluttertoast.showToast(msg: "Please go into create mode before proceeding.");
                                                                                      }
                                                                                    },
                                                                                    center: _initialCameraPosition,
                                                                                    zoom: mainZoom),
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
                                                                                  if (showActive == true) ...[
                                                                                    for (var info in existingCampaign)
                                                                                      fmap.CircleLayerOptions(circles: [
                                                                                        fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: double.parse(info.values.elementAt(2).toString()) - toBeDeduct.toDouble(), borderColor: Colors.red, borderStrokeWidth: 1, color: Colors.red.withOpacity(0.2)),
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
                                                                                  ],
                                                                                  if (showInProgress == true) ...[
                                                                                    for (var info in getProgress)
                                                                                      fmap.CircleLayerOptions(circles: [
                                                                                        fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: double.parse(info.values.elementAt(2).toString()) - toBeDeduct.toDouble(), borderColor: Colors.blue, borderStrokeWidth: 1, color: Colors.blue.withOpacity(0.2)),
                                                                                      ]),
                                                                                  ],
                                                                                  if (showDone == true) ...[
                                                                                    for (var info in getDone)
                                                                                      fmap.CircleLayerOptions(circles: [
                                                                                        fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: double.parse(info.values.elementAt(2).toString()) - toBeDeduct.toDouble(), borderColor: Colors.amber, borderStrokeWidth: 1, color: Colors.amber.withOpacity(0.2)),
                                                                                      ]),
                                                                                  ],
                                                                                  if (showVolunteers) ...[
                                                                                    for (var info in getVolunteers)
                                                                                      fmap.MarkerLayerOptions(markers: [
                                                                                        fmap.Marker(
                                                                                            width: 120,
                                                                                            point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)),
                                                                                            builder: (context) {
                                                                                              return Text(
                                                                                                info.values.elementAt(3).toString() + " / " + info.values.elementAt(2).toString() + " Volunteers",
                                                                                                style: TextStyle(color: Color(0xff2b2b2b)),
                                                                                              );
                                                                                            })
                                                                                      ]),
                                                                                  ],
                                                                                  for (var info in circleMarkersCampaigns)
                                                                                    fmap.CircleLayerOptions(circles: [
                                                                                      fmap.CircleMarker(point: lt.LatLng(info.values.elementAt(0), info.values.elementAt(1)), radius: info.values.elementAt(2) - toBeDeduct.toDouble(), borderColor: Colors.red, borderStrokeWidth: 1, color: Colors.red.withOpacity(0.2))
                                                                                    ])
                                                                                ]),
                                                                            Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        mainZoom = mainZoom - 0.2;
                                                                                        toBeDeduct = toBeDeduct + 1;
                                                                                      });
                                                                                      cntrler.move(cntrler.center, mainZoom);
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 40,
                                                                                      height: 40,
                                                                                      child: Card(
                                                                                        elevation: 10,
                                                                                        child: Center(child: Text('-')),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        mainZoom = mainZoom + 0.2;
                                                                                        toBeDeduct = toBeDeduct - 1;
                                                                                      });
                                                                                      cntrler.move(cntrler.center, mainZoom);
                                                                                    },
                                                                                    child: Container(
                                                                                      width: 40,
                                                                                      height: 40,
                                                                                      child: Card(
                                                                                        elevation: 10,
                                                                                        child: Center(child: Text('+')),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Container(
                                                                            padding: EdgeInsets.all(15),
                                                                            child: Consumer(builder: (context, watch, child) {
                                                                              double radius = 0;
                                                                              double finalRadius = 0;
                                                                              final radiusProvider = watch(mapProvider);
                                                                              int finalVolunteers = radiusProvider.volunteersRequired;
                                                                              int finalSeeds = radiusProvider.seedsRequired;
                                                                              double finalFund = radiusProvider.fundRequired;
                                                                              finalRadius = radiusProvider.valueRadius;

                                                                              return PageView(
                                                                                controller: pageController,
                                                                                physics: NeverScrollableScrollPhysics(),
                                                                                children: [
                                                                                  firstPage(),
                                                                                  secondPage(finalFund: finalFund, finalRadius: finalRadius, finalSeeds: finalSeeds, finalVolunteers: finalVolunteers, radius: radius),
                                                                                  thirdPage(),
                                                                                  fourthPage(date: formattedDate, finalFund: finalFund, finalRadius: finalRadius, finalSeeds: finalSeeds, userUID: userUID, finalVolunteers: finalVolunteers)
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
                                                  Navigator.pushNamed(
                                                      context, '/home');
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
                                                  Card(
                                                    elevation: 10,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      width: double.infinity,
                                                      height: 100,
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
                                                            .getDescription
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
                                          opacity: camCity ? 1 : 0,
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
                                                    'City',
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
                                                            .getCity
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
                                          opacity: camAddress ? 1 : 0,
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
                                                    'Address',
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
                                                            .getAddress
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
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeAnimation(
                  0.2,
                  Text(
                    'Hello, ' + usernames,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                FadeAnimation(
                  0.2,
                  Text(
                    'Current Balance: ' + balanse.toString(),
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showVolunteers = !showVolunteers;
                    });
                  },
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          color: Color(0xff65BFB8),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(child: Text('Show Volunteers'))),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print(showActive);
                      showActive = !showActive;
                    });
                  },
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          color: Color(0xff65BFB8),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Text(
                              numberActive.toString() + ' Active Campaign'))),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showInProgress = !showInProgress;
                    });
                  },
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          color: Color(0xff65BFB8),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Text(
                              numberOngoing.toString() + ' Ongoing Campaign'))),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showDone = !showDone;
                    });
                  },
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          color: Color(0xff65BFB8),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                          child: Text(numberCompleted.toString() +
                              ' Completed Campaign'))),
                ),
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
                  Fluttertoast.showToast(
                      msg: "In create mode.", toastLength: Toast.LENGTH_SHORT);
                } else {
                  Fluttertoast.showToast(
                      msg: "Disabled create mode.",
                      toastLength: Toast.LENGTH_SHORT);
                }
              } else {
                Fluttertoast.showToast(
                    msg: 'You are not an organizer, be an organizer first');
              }
            },
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color(0xff65BFB8)),
              child: Center(
                child: createMode
                    ? Text('Exit Create Mode')
                    : Text('Enter Create Mode'),
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
                        max: 20,
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
            FadeAnimation(
              0.1,
              Text('About the Campaign',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Color(0xff65BFB8))),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 5,
            ),
            FadeAnimation(
              0.2,
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20)
                          ],
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
            ),
            SizedBox(
              height: 15,
            ),
            FadeAnimation(
              0.3,
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
            ),
            SizedBox(
              height: 15,
            ),
            FadeAnimation(
              0.4,
              GestureDetector(
                onTap: () {
                  if (descriptionController.text == "" ||
                      campaignNameController.text == "") {
                    Fluttertoast.showToast(msg: 'Please Input Details');
                  } else {
                    setState(() {
                      pageController.animateToPage(3,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn);
                    });
                  }
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
      required double finalRadius,
      required String date}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FadeAnimation(
            0.1,
            Text('Campaign Information',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color(0xff65BFB8))),
          ),
          SizedBox(
            height: 10,
          ),
          FadeAnimation(
            0.2,
            Text(
                'Input the City of the campaign, the meetup address and the desired date you want the campaign to start',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: Colors.grey)),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          FadeAnimation(
            0.3,
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
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        setState(() {
                          focused2 = !focused2;
                          if (focused2 == true) {
                            camCity = true;
                          } else {
                            camCity = false;
                          }
                        });
                      },
                      child: TextField(
                        controller: cityController,
                        onChanged: (value) => {
                          setState(() {
                            context.read(campaignProvider).setCityName(value);
                          })
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
          ),
          SizedBox(
            height: 10,
          ),
          FadeAnimation(
            0.4,
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
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        setState(() {
                          focused3 = !focused3;
                          if (focused3 == true) {
                            camAddress = true;
                          } else {
                            camAddress = false;
                          }
                        });
                      },
                      child: TextField(
                        controller: addressController,
                        onChanged: (value) {
                          setState(() {
                            context.read(campaignProvider).setAddress(value);
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
          ),
          SizedBox(
            height: 10,
          ),
          FadeAnimation(
            0.5,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date Start'),
                GestureDetector(
                  onTap: () async {
                    await _selectDate(context).whenComplete(() {
                      // ignore: unnecessary_null_comparison
                      if (selectedDate != null) {
                        context
                            .read(campaignProvider)
                            .setStartingDate(selectedDate.toString());
                      } else {
                        Fluttertoast.showToast(
                            msg: 'you did not select a date');
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.date_range),
                              SizedBox(width: 20),
                              Text(date)
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          FadeAnimation(
            0.6,
            GestureDetector(
              onTap: () {
                if (cityController.text == "" || addressController.text == "") {
                  Fluttertoast.showToast(msg: 'Please Complete Details');
                } else {
                  DateTime now = new DateTime.now();
                  const _chars =
                      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                  Random _rnd = Random();

                  String getRandomString(int length) =>
                      String.fromCharCodes(Iterable.generate(
                          length,
                          (_) =>
                              _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
                  String uniqueID = getRandomString(30);
                  setState(() {
                    dateCreated = now;

                    dateStart = formatDate(DateTime(2021, 10, 27, 2, 30, 50),
                        [yyyy, '-', mm, '-', dd]);

                    dateEnded = formatDate(DateTime(2021, 10, 27, 2, 30, 50),
                        [yyyy, '-', mm, '-', dd]);

                    time = formatDate(DateTime(2021, 09, 27, 2, 30, 50),
                        [HH, ':', nn, ':', ss]);
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
                        .then((value) {
                      context.read(authserviceProvider).deductInitialCampaign(
                          context
                              .read(authserviceProvider)
                              .getCurrentUserUID());
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Container(
                                margin: EdgeInsets.fromLTRB(10, 250, 10, 300),
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Text(
                                            'Thank you for creating a campaign organizer, once your campaign accepted, your campaign will be displayed in the application. this will take up to 2 - 3 days to accept.'),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff65BFB8)),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MapCampaign()));
                                              },
                                              child: Text('Back to Map')),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff65BFB8)),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/home');
                                              },
                                              child: Text('Back to home')),
                                        ],
                                      ),
                                    ],
                                  ),
                                ));
                          });
                    });
                  });
                }
              },
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xff65BFB8),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Text(
                    'Create Campaign Request',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
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
