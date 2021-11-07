import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/rendering.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/animation/FadeAnimation.dart';
import 'package:http/http.dart' as http;
import 'package:sylviapp_project/screens/campaign_module/volunteer_form.dart';

class JoinDonateCampaign extends StatefulWidget {
  final String uidOfCampaign;
  final String? address;
  final String? nameOfCampaign;
  final String description;
  final String uidOfOrganizer;
  final String city;
  final int currentVolunteer;
  final int totalVolunteer;
  final int currentFund;
  final int maxFund;
  const JoinDonateCampaign({
    Key? key,
    required this.uidOfCampaign,
    required this.address,
    required this.description,
    required this.uidOfOrganizer,
    required this.nameOfCampaign,
    required this.city,
    required this.currentVolunteer,
    required this.totalVolunteer,
    required this.currentFund,
    required this.maxFund,
  }) : super(key: key);

  @override
  _JoinDonateCampaignState createState() => _JoinDonateCampaignState();
}

class _JoinDonateCampaignState extends State<JoinDonateCampaign>
    with TickerProviderStateMixin {
  late AnimationController _hide =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  var url =
      'https://us-central1-sylviapp-77c5e.cloudfunctions.net/paypalPayment';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hide =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _hide.forward();
  }

  @override
  void dispose() {
    _hide.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 01) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _hide.forward();
            break;
          case ScrollDirection.reverse:
            _hide.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    _hide.forward();
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("campaigns")
                .doc(widget.uidOfCampaign)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return Stack(
                  children: [
                    NotificationListener(
                      onNotification: _handleScrollNotification,
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FadeAnimation(
                                0.3,
                                Stack(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4.5,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                "https://images.unsplash.com/photo-1425913397330-cf8af2ff40a1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1374&q=80",
                                              ))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.white,
                                          child: FittedBox(
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black,
                                                  size: 30,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                  height:
                                      MediaQuery.of(context).size.height / 1.39,
                                  child: SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          FadeAnimation(
                                            0.4,
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Stack(children: [
                                                  CircleAvatar(
                                                    radius: 35,
                                                    backgroundColor:
                                                        Color(0xff65BFB8),
                                                    child: CircleAvatar(
                                                      radius: 32,
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0.5),
                                                      child: Icon(
                                                        Icons.person,
                                                        color:
                                                            Color(0xff65BFB8),
                                                        size: 50,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                SizedBox(
                                                  width: 13,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.nameOfCampaign
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      widget.city,
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "₱" +
                                                        "0" +
                                                        " of " +
                                                        "₱" +
                                                        widget.maxFund
                                                            .toString() +
                                                        " raised",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            Color(0xff65BFB8)),
                                                  ),
                                                  SizedBox(
                                                    width: 3.5,
                                                  ),
                                                  Tooltip(
                                                    message: "dsada",
                                                    child: Icon(
                                                      Icons.help_rounded,
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      size: 13,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: 13,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  child:
                                                      LinearProgressIndicator(
                                                    semanticsLabel: "Donated",
                                                    semanticsValue: "Donating",
                                                    backgroundColor: Colors.grey
                                                        .withOpacity(0.3),
                                                    color: Color(0xff65BFB8),
                                                    minHeight: 10,
                                                    value: 0.2,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                widget.currentVolunteer
                                                        .toString() +
                                                    " / " +
                                                    widget.totalVolunteer
                                                        .toString() +
                                                    " volunteers.",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              FadeAnimation(
                                                0.5,
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey
                                                          .withOpacity(0.35),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  padding: EdgeInsets.all(20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          var request =
                                                              BraintreeDropInRequest(
                                                                  tokenizationKey:
                                                                      'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                                                                  collectDeviceData:
                                                                      true,
                                                                  paypalRequest:
                                                                      BraintreePayPalRequest(
                                                                    amount:
                                                                        '10.00',
                                                                    displayName:
                                                                        'SylviaApp',
                                                                  ),
                                                                  cardEnabled:
                                                                      true);

                                                          BraintreeDropInResult?
                                                              result =
                                                              await BraintreeDropIn
                                                                  .start(
                                                                      request);

                                                          if (result != null) {
                                                            print(result
                                                                .paymentMethodNonce
                                                                .description);
                                                            print(result
                                                                .paymentMethodNonce
                                                                .nonce);

                                                            final http.Response
                                                                response =
                                                                await http.post(
                                                                    Uri.tryParse(
                                                                        '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}')!);
                                                          } else {
                                                            print(
                                                                "FAILED PAYMENT PROCESS");
                                                          }
                                                        },
                                                        child: Column(
                                                          children: [
                                                            CircleAvatar(
                                                              radius: 20,
                                                              backgroundColor:
                                                                  Colors.orange,
                                                              child: FittedBox(
                                                                  child:
                                                                      IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  var request =
                                                                      BraintreeDropInRequest(
                                                                          tokenizationKey:
                                                                              'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                                                                          collectDeviceData:
                                                                              true,
                                                                          paypalRequest:
                                                                              BraintreePayPalRequest(
                                                                            amount:
                                                                                '10.00',
                                                                            displayName:
                                                                                'SylviaApp',
                                                                          ),
                                                                          cardEnabled:
                                                                              true);

                                                                  BraintreeDropInResult?
                                                                      result =
                                                                      await BraintreeDropIn
                                                                          .start(
                                                                    request,
                                                                  );

                                                                  if (result !=
                                                                      null) {
                                                                    print(result
                                                                        .paymentMethodNonce
                                                                        .description);
                                                                    print(result
                                                                        .paymentMethodNonce
                                                                        .nonce);
                                                                    print(result
                                                                        .deviceData);

                                                                    final http
                                                                            .Response
                                                                        response =
                                                                        await http
                                                                            .post(Uri.tryParse('$url?payment_method_nonce=${result.paymentMethodNonce.nonce}')!);

                                                                    final payResult =
                                                                        jsonDecode(
                                                                            response.body);

                                                                    if (payResult[
                                                                            "result"] ==
                                                                        "success") {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                              msg: "SUCCESSFULLY DONATED");
                                                                    }
                                                                  } else if (result ==
                                                                      null) {
                                                                    print(
                                                                        "Braintree Result is null");
                                                                  }
                                                                },
                                                                icon: Icon(Icons
                                                                    .monetization_on_outlined),
                                                                color: Colors
                                                                    .white,
                                                                iconSize: 25,
                                                              )),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                              "Donate",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor:
                                                                Color(
                                                                    0xffFF683A),
                                                            child: FittedBox(
                                                                child:
                                                                    IconButton(
                                                              onPressed: () {},
                                                              icon: Icon(
                                                                  Icons.report),
                                                              color:
                                                                  Colors.white,
                                                              iconSize: 25,
                                                            )),
                                                          ),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            "Report",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 400,
                                                  child: Divider(
                                                    height: 35,
                                                    thickness: 1.5,
                                                  ),
                                                ),
                                              ),
                                              FadeAnimation(
                                                0.6,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "About Campaign",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.5),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.35),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Text(
                                                        widget.description
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.75)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 400,
                                                  child: Divider(
                                                    height: 35,
                                                    thickness: 1.5,
                                                  ),
                                                ),
                                              ),
                                              FadeAnimation(
                                                0.7,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "About the Organizer",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.5),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    StreamBuilder<
                                                            DocumentSnapshot>(
                                                        stream: FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(
                                                                "Rat6RS0t3Scj76VRXFMzrwzuhMr1")
                                                            .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          var fullname = AESCryptography()
                                                              .decryptAES(enc
                                                                      .Encrypted
                                                                  .fromBase64(
                                                                      snapshot
                                                                          .data!
                                                                          .get(
                                                                              'fullname')));

                                                          var address = AESCryptography()
                                                              .decryptAES(enc
                                                                      .Encrypted
                                                                  .from64(snapshot
                                                                      .data!
                                                                      .get(
                                                                          'address')));
                                                          var gender = AESCryptography()
                                                              .decryptAES(enc
                                                                      .Encrypted
                                                                  .from64(snapshot
                                                                      .data!
                                                                      .get(
                                                                          'gender')));
                                                          var phoneNumber = AESCryptography()
                                                              .decryptAES(enc
                                                                      .Encrypted
                                                                  .from64(snapshot
                                                                      .data!
                                                                      .get(
                                                                          'phoneNumber')));
                                                          return Container(
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                CircleAvatar(
                                                                  radius: 30,
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xff65BFB8),
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 27,
                                                                    child: Icon(
                                                                        Icons
                                                                            .person),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(
                                                                                0.35),
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5))),
                                                                    child: Text(
                                                                      "The campaign is all about this and that and there you go.",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.7)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 400,
                                                  child: Divider(
                                                    height: 35,
                                                    thickness: 1.5,
                                                  ),
                                                ),
                                              ),
                                              FadeAnimation(
                                                0.9,
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "More information",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.5),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.35),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Text(
                                                        "The campaign is all about this and that and there you go.",
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child: Container(
                                                  width: 400,
                                                  child: Divider(
                                                    height: 35,
                                                    thickness: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    FadeAnimation(
                      1,
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizeTransition(
                          sizeFactor: _hide,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 85,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color(0xff65BFB8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  VolunteerFormScreen(
                                                    campaignUID:
                                                        widget.uidOfCampaign,
                                                    organizerUID:
                                                        widget.uidOfOrganizer,
                                                  )));
                                    },
                                    child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Center(
                                        child: Text(
                                          'Join Campaign',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: Color(0xff65BFB8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "More Volunteers needed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(0.4)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
