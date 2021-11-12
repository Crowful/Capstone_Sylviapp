import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/services/authservices.dart';
import 'package:sylviapp_project/widgets/campaign_module/slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_format/date_format.dart';
import 'package:encrypt/encrypt.dart' as enc;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection("polygon").doc("Angat_Forest");

//FAB
  bool isOrganizer = false;
  bool createMode = false;
  bool isOpened = false;
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
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  var usernames;

//campaign variables
  String title = "title test";
  String description = " description test";
  late String dateCreated;
  late String dateStart;
  late String dateEnded;
  String address = "address test";
  String city = "city test";
  late String time;
  String userUID = AuthService().getCurrentUserUID();
  String userName = AuthService().getCurrentUserDisplayName();
  double latitude = 0;
  double longitude = 0;
  int numSeeds = 0;
  double currentDonations = 10000.00;
  double maxDonations = 10000.00;
  int currentVolunteers = 0;
  int numberVolunteers = 0;

  var circleList = [];

//===============

  double radius = 0;
  int circleID = 1;
  double finalRadius = 0;
  Completer<GoogleMapController> mapController = Completer();
  late LatLng testlatlng;
  bool showCreate = false;
  bool clicked = false;
  bool clickedRadius = false;
  final _initialCameraPosition =
      CameraPosition(target: LatLng(14.5995, 120.9842), zoom: 5);

  late bool isPointValid;
  late AnimationController controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  Set<Polygon> polygon = Set();

  late List<dynamic> pointlist = List.empty(growable: true);

  List<LatLng> latlngpolygonlistLamesa = List.empty(growable: true);
  List<LatLng> latlngpolygonlistAngat = List.empty(growable: true);
  List<LatLng> latlngpolygonlistPantabangan = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    //FAB
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
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
    _translateButton = Tween<double>(
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

    //CIRCLES
    FirebaseFirestore.instance
        .collection('admin_campaign_requests')
        .get()
        .then((QuerySnapshot snaps) {
      print(snaps);
      snaps.docs.forEach((circ) {
        circle.add(Circle(
          onTap: () {
            print("test");
          },
          circleId: CircleId(circ['campaignID']),
          center: LatLng(circ['latitude'], circ['longitude']),
          strokeWidth: 1,
          strokeColor: Colors.pink,
          fillColor: Colors.pink.withOpacity(0.5),
          radius: circ['radius'] * 100,
        ));
      });
    });

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService.userUid)
        .get()
        .then((data) async {
      usernames = AESCryptography()
          .decryptAES(enc.Encrypted.fromBase64(data['fullname']));
    });

    FirebaseFirestore.instance
        .collection('polygon')
        .doc('Lamesa_Forest')
        .get()
        .then((data) async {
      pointlist = List<dynamic>.from(await data.get("points"));

      pointlist.forEach((element) {
        latlngpolygonlistLamesa
            .add(LatLng(element["latitude"], element["longitude"]));
      });

      polygon.add(Polygon(
          strokeWidth: 1,
          strokeColor: Colors.red,
          fillColor: Colors.green.withOpacity(0.4),
          polygonId: PolygonId("Lamesa_Forest"),
          points: latlngpolygonlistLamesa));
    });

    FirebaseFirestore.instance
        .collection('polygon')
        .doc('Angat_Forest')
        .get()
        .then((data) async {
      pointlist = List<dynamic>.from(await data.get("points"));

      pointlist.forEach((element) {
        latlngpolygonlistAngat
            .add(LatLng(element["latitude"], element["longitude"]));
      });

      polygon.add(Polygon(
          strokeWidth: 1,
          strokeColor: Colors.red,
          fillColor: Colors.green.withOpacity(0.4),
          polygonId: PolygonId("Angat_Forest"),
          points: latlngpolygonlistAngat));
    });

    FirebaseFirestore.instance
        .collection('polygon')
        .doc('Pantabangan_Forest')
        .get()
        .then((data) async {
      pointlist = List<dynamic>.from(await data.get("points"));

      pointlist.forEach((element) {
        latlngpolygonlistPantabangan
            .add(LatLng(element["latitude"], element["longitude"]));
      });

      polygon.add(Polygon(
          strokeWidth: 1,
          strokeColor: Colors.red,
          fillColor: Colors.green.withOpacity(0.4),
          polygonId: PolygonId("PantabanganForest"),
          points: latlngpolygonlistPantabangan));
    });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  final pointFromGoogleMap1 = LatLng(14.718598, 121.071495);
  final pointFromGoogleMap2 = LatLng(14.729223, 121.071839);
  final pointFromGoogleMap3 = LatLng(14.711292, 121.082653);

  late String statusPoint = "none";

  late LatLng currentMark;
  late mtk.LatLng currentMark2;

  Set<Circle> circle = Set();

  void putCircle(latlng, double radius1, circleID) {
    controller.forward();

    circle.add(Circle(
      onTap: () {
        print('clicked');
      },
      consumeTapEvents: true,
      circleId: CircleId(circleID.toString()),
      center: latlng,
      strokeWidth: 1,
      strokeColor: Colors.pink,
      fillColor: Colors.pink.withOpacity(0.5),
      radius: radius1,
    ));
  }

  Set<Marker> markers = Set();

  Set<Polygon> myPolygon() {
    List<LatLng> polygonCoords = new List.empty(growable: true);
    polygonCoords.add(pointFromGoogleMap1);
    polygonCoords.add(pointFromGoogleMap2);
    polygonCoords.add(pointFromGoogleMap3);

    Set<Polygon> polygonSet = new Set();

    polygonSet.add(Polygon(
        polygonId: PolygonId("test"),
        points: polygonCoords,
        strokeColor: Colors.green,
        strokeWidth: 1,
        fillColor: Colors.green.withOpacity(0.2)));

    return polygonSet;
  }

  @override
  Widget build(BuildContext context) {
    dynamic userUID = context.read(authserviceProvider).getCurrentUserUID();
    return SafeArea(
      child: Consumer(builder: (context, watch, child) {
        final radiusProvider = watch(mapProvider);
        int finalVolunteers = radiusProvider.volunteersRequired;
        int finalSeeds = radiusProvider.seedsRequired;
        int finalFund = radiusProvider.fundRequired;
        finalRadius = radiusProvider.valueRadius;
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userUID)
                .get(),
            builder: (BuildContext builder, snapshot) {
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
                      absorbing: isVerified ? false : true,
                      child: FloatingActionButton(
                        heroTag: "herotag1",
                        backgroundColor:
                            isVerified ? Colors.grey : Color(0xff65BFB8),
                        onPressed: () {
                          setState(() {
                            createMode = true;
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
                          child: Icon(Icons.image),
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
                  body: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('quarantineStatus')
                          .doc('status')
                          .snapshots(),
                      builder: (context, statusQuarantine) {
                        var status = statusQuarantine.data!.get('status');
                        return Stack(children: [
                          GoogleMap(
                              onTap: (latlng) async {
                                if (createMode = false) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please enter in create mode first.");
                                }
                              },
                              onCameraIdle: () {
                                setState(() {
                                  createMode = false;
                                });
                              },
                              onLongPress: (latlng) {
                                if (createMode = true) {
                                  if (status == "ECQ" ||
                                      status == "MECQ" ||
                                      status == "GCQ") {
                                    Fluttertoast.showToast(
                                        msg: "The area is still in lockdown.");
                                  } else {
                                    Future<void> toCreate() async {
                                      final GoogleMapController controller =
                                          await mapController.future;
                                      controller.moveCamera(
                                          CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                        target: LatLng(latlng.latitude - .0050,
                                            latlng.longitude),
                                        zoom: 16,
                                      )));
                                    }

                                    mtk.LatLng latlngtoMTK = mtk.LatLng(
                                        latlng.latitude, latlng.longitude);
                                    final mtk1 = mtk.LatLng(
                                        pointFromGoogleMap1.latitude,
                                        pointFromGoogleMap1.longitude);
                                    final mtk2 = mtk.LatLng(
                                        pointFromGoogleMap2.latitude,
                                        pointFromGoogleMap2.longitude);
                                    final mtk3 = mtk.LatLng(
                                        pointFromGoogleMap3.latitude,
                                        pointFromGoogleMap3.longitude);

                                    List<mtk.LatLng> mtkPolygon =
                                        new List.empty(growable: true);
                                    mtkPolygon.add(mtk1);
                                    mtkPolygon.add(mtk2);
                                    mtkPolygon.add(mtk3);

                                    List<mtk.LatLng> mtkPolygonAngat =
                                        List.empty(growable: true);
                                    latlngpolygonlistAngat.forEach((element) {
                                      mtkPolygonAngat.add(mtk.LatLng(
                                          element.latitude, element.longitude));
                                    });

                                    List<mtk.LatLng> mtkPolygonLamesa =
                                        List.empty(growable: true);
                                    latlngpolygonlistLamesa.forEach((element) {
                                      mtkPolygonLamesa.add(mtk.LatLng(
                                          element.latitude, element.longitude));
                                    });

                                    List<mtk.LatLng> mtkPolygonPanbatanbangan =
                                        List.empty(growable: true);
                                    latlngpolygonlistPantabangan
                                        .forEach((element) {
                                      mtkPolygonPanbatanbangan.add(mtk.LatLng(
                                          element.latitude, element.longitude));
                                    });

                                    isPointValid =
                                        mtk.PolygonUtil.containsLocation(
                                                latlngtoMTK,
                                                mtkPolygonAngat,
                                                false) ||
                                            mtk.PolygonUtil.containsLocation(
                                                latlngtoMTK,
                                                mtkPolygonLamesa,
                                                false) ||
                                            mtk.PolygonUtil.containsLocation(
                                                latlngtoMTK,
                                                mtkPolygonPanbatanbangan,
                                                false);

                                    if (isPointValid == true) {
                                      setState(() {
                                        latitude = latlng.latitude;
                                        longitude = latlng.longitude;
                                        circleID++;
                                        toCreate();
                                        testlatlng = latlng;

                                        putCircle(
                                            testlatlng, finalRadius, circleID);
                                      });
                                    } else if (isPointValid == false) {
                                      Fluttertoast.showToast(
                                          msg: "You cannot put campaign there");
                                    }
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not verified yet, please submit application first.");
                                }
                              },
                              polygons: polygon,
                              circles: circle,
                              mapType: MapType.normal,
                              onMapCreated: (GoogleMapController controller) {
                                mapController.complete(controller);
                              },
                              zoomControlsEnabled: false,
                              initialCameraPosition: _initialCameraPosition),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                  offset: Offset(0, -.1),
                                ),
                              ], color: Colors.white),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    AnimatedDefaultTextStyle(
                                      duration: Duration(milliseconds: 500),
                                      child: Text('Welcome Organizer'),
                                      style: TextStyle(
                                          shadows: <Shadow>[],
                                          fontSize: 25,
                                          color: Color(0xff65BFB8),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
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
                                    //Get Username

                                    const _chars =
                                        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                                    Random _rnd = Random();

                                    String getRandomString(int length) =>
                                        String.fromCharCodes(Iterable.generate(
                                            length,
                                            (_) => _chars.codeUnitAt(
                                                _rnd.nextInt(_chars.length))));
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
                                            putCircle(testlatlng, finalRadius,
                                                circleID);
                                            print(circleID);
                                            context
                                                .read(mapProvider)
                                                .checkVolunteersNeeded(
                                                    finalRadius);
                                            context
                                                .read(mapProvider)
                                                .checkseedsNeeded(finalRadius);
                                            context
                                                .read(mapProvider)
                                                .checkFundRequired(finalRadius);
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ]);
                      }),
                );
              }
            });
      }),
    );
  }

  Future<void> toAngat() async {
    final GoogleMapController controller = await mapController.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(14.918990, 121.165563),
      zoom: 13,
    )));
  }

  Future<void> toLamesa() async {
    final GoogleMapController controller = await mapController.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(14.7452, 121.0984),
      zoom: 13,
    )));
  }

  Future<void> toPantabangan() async {
    final GoogleMapController controller = await mapController.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(15.780574, 121.121838),
      zoom: 13,
    )));
  }
}
