import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mtk;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/widgets/campaign_module/slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  double radius = 0;
  int circleID = 1;
  double finalRadius = 0;
  Completer<GoogleMapController> mapController = Completer();
  late LatLng testlatlng;
  bool showCreate = false;
  bool clicked = false;
  bool clickedRadius = false;
  final _initialCameraPosition =
      CameraPosition(target: LatLng(14.5995, 120.9842));

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
        setState(() {
          showCreate = true;
          clickedRadius = true;
        });
      },
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
        finalRadius = radiusProvider.valueRadius;
        return Scaffold(
          body: Stack(children: [
            Container(
              margin: showCreate
                  ? EdgeInsets.only(bottom: 0)
                  : EdgeInsets.only(bottom: 20),
              child: GoogleMap(
                  onCameraIdle: () {},
                  onTap: (latlng) {
                    Future<void> toCreate() async {
                      final GoogleMapController controller =
                          await mapController.future;
                      controller.moveCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                        target:
                            LatLng(latlng.latitude - .0050, latlng.longitude),
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

                    List<mtk.LatLng> mtkPolygon =
                        new List.empty(growable: true);
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
            ),
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
                              'Create Campaign',
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
                  radius: radius,
                  back: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        controller.reverse();
                      });
                    },
                  ),
                  done: ElevatedButton(
                    onPressed: () {
                      print(finalRadius);
                    },
                    child: Center(
                      child: Column(
                        children: [
                          Text('Slide na totoo'),
                          Slider(
                            activeColor: Colors.white,
                            value: radius,
                            onChanged: (radius1) {
                              setState(() {
                                radius = radius1;
                                context
                                    .read(mapProvider)
                                    .RadiusAssign(radius * 100);
                                putCircle(testlatlng, finalRadius, circleID);
                                print(circleID);
                              });
                            },
                          ),
                        ],
                      ),
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
