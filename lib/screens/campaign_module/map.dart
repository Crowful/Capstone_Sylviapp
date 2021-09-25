import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool clicked = false;
  final _initialCameraPosition =
      CameraPosition(target: LatLng(14.5995, 120.9842));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
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
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
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

  moveToAngat() {}
}
