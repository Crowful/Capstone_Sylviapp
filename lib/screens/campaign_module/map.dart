import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> mapController = Completer();
  bool clicked = false;
  final _initialCameraPosition =
      CameraPosition(target: LatLng(14.5995, 120.9842));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                        child:
                                            Text('Pantabangan \nWatershed')))),
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
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
          )
        ]),
      ),
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
