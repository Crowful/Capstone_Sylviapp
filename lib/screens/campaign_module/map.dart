import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/services/authservices.dart';
import 'package:sylviapp_project/widgets/campaign_module/slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:date_format/date_format.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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

  void putMarker(latlng) {
    check();
    Marker resultMarker = Marker(
      markerId: MarkerId("test"),
      infoWindow: InfoWindow(title: statusPoint, snippet: "test"),
      position: latlng,
    );
    markers.add(resultMarker);
  }

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

  void check() {
    final mtk1 =
        mtk.LatLng(pointFromGoogleMap1.latitude, pointFromGoogleMap1.longitude);
    final mtk2 =
        mtk.LatLng(pointFromGoogleMap2.latitude, pointFromGoogleMap2.longitude);
    final mtk3 =
        mtk.LatLng(pointFromGoogleMap3.latitude, pointFromGoogleMap3.longitude);

    List<mtk.LatLng> mtkPolygon = new List.empty(growable: true);
    mtkPolygon.add(mtk1);
    mtkPolygon.add(mtk2);
    mtkPolygon.add(mtk3);

    isPointValid =
        mtk.PolygonUtil.containsLocation(currentMark2, mtkPolygon, false);

    if (isPointValid == false) {
      print("nasa labas ng polyline");
      setState(() {
        statusPoint = "Nasa labas ng polyline";
      });
    } else if (isPointValid == true) {
      print("nasa loob ng polyline");
      setState(() {
        statusPoint = "Nasa loob ng polyline";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (context, watch, child) {
        final radiusProvider = watch(mapProvider);
        int finalVolunteers = radiusProvider.volunteersRequired;
        int finalSeeds = radiusProvider.seedsRequired;
        int finalFund = radiusProvider.fundRequired;
        finalRadius = radiusProvider.valueRadius;
        return Scaffold(
          body: Stack(children: [
            GoogleMap(
                onTap: (latlng) {
                  Fluttertoast.showToast(
                      msg: "Long Press inside the polygon to create campaign");
                },
                onCameraIdle: () {},
                onLongPress: (latlng) {
                  Future<void> toCreate() async {
                    final GoogleMapController controller =
                        await mapController.future;
                    controller.moveCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(latlng.latitude - .0050, latlng.longitude),
                      zoom: 16,
                    )));
                  }

                  mtk.LatLng latlngtoMTK =
                      mtk.LatLng(latlng.latitude, latlng.longitude);
                  final mtk1 = mtk.LatLng(pointFromGoogleMap1.latitude,
                      pointFromGoogleMap1.longitude);
                  final mtk2 = mtk.LatLng(pointFromGoogleMap2.latitude,
                      pointFromGoogleMap2.longitude);
                  final mtk3 = mtk.LatLng(pointFromGoogleMap3.latitude,
                      pointFromGoogleMap3.longitude);

                  List<mtk.LatLng> mtkPolygon = new List.empty(growable: true);
                  mtkPolygon.add(mtk1);
                  mtkPolygon.add(mtk2);
                  mtkPolygon.add(mtk3);

                  isPointValid = mtk.PolygonUtil.containsLocation(
                      latlngtoMTK, mtkPolygon, false);

                  if (isPointValid == true) {
                    // Navigator.of(context).push(
                    //     HeroDialogRoute(builder: (context) {
                    //   return SliderWidget(radius: radius);
                    // })).whenComplete(() => putCircle(
                    //     latlng, radiusNotifier.valueRadius.toInt(), circleID));

                    setState(() {
                      latitude = latlng.latitude;
                      longitude = latlng.longitude;
                      circleID++;
                      toCreate();
                      testlatlng = latlng;

                      putCircle(testlatlng, finalRadius, circleID);
                    });
                  } else if (isPointValid == false) {
                    Fluttertoast.showToast(
                        msg: "You cannot put campaign there");
                  }
                },
                polygons: myPolygon(),
                circles: circle,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
                zoomControlsEnabled: false,
                initialCameraPosition: _initialCameraPosition),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: clicked ? 1 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.transparent),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      toAngat();
                                      clicked = false;
                                    });
                                  },
                                  child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Center(
                                          child: Text('Angat\nWatershed')))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      print('angat');
                                      toLamesa();
                                      clicked = false;
                                    });
                                  },
                                  child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Center(
                                          child: Text('La Mesa \nWatershed')))),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      toPantabangan();
                                      clicked = false;
                                    });
                                  },
                                  child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
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
                                  BorderRadius.all(Radius.circular(5)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              color: Color(0xff65BFB8)),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              'Choose Forest',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            SlideTransition(
                position:
                    Tween<Offset>(begin: Offset(0, 1.2), end: Offset(0, 0.4))
                        .animate(
                  new CurvedAnimation(
                      parent: controller, curve: Curves.fastOutSlowIn),
                ),
                child: SliderWidget(
                  done: GestureDetector(
                    onTap: () {
                      const _chars =
                          'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                      Random _rnd = Random();

                      String getRandomString(int length) =>
                          String.fromCharCodes(Iterable.generate(
                              length,
                              (_) => _chars
                                  .codeUnitAt(_rnd.nextInt(_chars.length))));
                      String uniqueID = getRandomString(15);
                      setState(() {
                        dateCreated = formatDate(
                            DateTime.now(), [yyyy, '-', mm, '-', dd]);

                        dateStart = formatDate(
                            DateTime(2021, 10, 27, 2, 30, 50),
                            [yyyy, '-', mm, '-', dd]);

                        dateEnded = formatDate(
                            DateTime(2021, 10, 27, 2, 30, 50),
                            [yyyy, '-', mm, '-', dd]);

                        time = formatDate(DateTime(2021, 09, 27, 2, 30, 50),
                            [HH, ':', nn, ':', ss]);

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
                                userName,
                                latitude,
                                longitude,
                                finalSeeds,
                                currentDonations,
                                maxDonations,
                                currentVolunteers,
                                finalVolunteers,
                                radius)
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
                      Text("Volunteers: " + finalVolunteers.toString()),
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
                          onChanged: (radius1) {
                            setState(() {
                              radius = radius1;
                              context
                                  .read(mapProvider)
                                  .RadiusAssign(radius * 100);
                              putCircle(testlatlng, finalRadius, circleID);
                              print(circleID);
                              context
                                  .read(mapProvider)
                                  .checkVolunteersNeeded(finalRadius);
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
          ]),
        );
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
