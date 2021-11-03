import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:sylviapp_project/screens/campaign_module/volunteer_form.dart';

class JoinDonateCampaign extends StatefulWidget {
  final String? uidOfCampaign;
  const JoinDonateCampaign({Key? key, this.uidOfCampaign}) : super(key: key);

  @override
  _JoinDonateCampaignState createState() => _JoinDonateCampaignState();
}

class _JoinDonateCampaignState extends State<JoinDonateCampaign> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("campaigns")
                  .doc(widget.uidOfCampaign)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 270, 50),
                          child: Column(children: [
                            Text(
                              snapshot.data!.get("campaign_name"),
                              style: TextStyle(
                                  color: Color(0xff65BFB8),
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text("address"),
                          ])),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text("23/50" + " Volunteers"),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(
                            "lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum"),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text("Organizer Name: " + "Alfie C. Tribaco"),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text("Requirements: "),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text("Vaccination ID "),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text("Medical Record"),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text("Planting Tools "),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text("Proper Gears "),
                      ),
                      SizedBox(
                        height: 150,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VolunteerFormScreen()));
                              },
                              child: Text("Join Campaign")),
                          SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange),
                              onPressed: () async {
                                var request = BraintreeDropInRequest(
                                    tokenizationKey:
                                        'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                                    collectDeviceData: true,
                                    paypalRequest: BraintreePayPalRequest(
                                      amount: '10.00',
                                      displayName: 'SylviaApp',
                                    ),
                                    cardEnabled: true);

                                BraintreeDropInResult? result =
                                    await BraintreeDropIn.start(request);

                                if (result != null) {
                                  print(result.paymentMethodNonce.description);
                                  print(result.paymentMethodNonce.nonce);
                                } else {
                                  print("FAILED PAYMENT PROCESS");
                                }
                              },
                              child: Text("Donate to this Campaign")),
                        ],
                      )
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}
