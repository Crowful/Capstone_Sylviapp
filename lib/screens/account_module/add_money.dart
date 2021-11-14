import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:sylviapp_project/providers/providers.dart';

class AddmoneyScreen extends StatefulWidget {
  const AddmoneyScreen({Key? key}) : super(key: key);

  @override
  _AddmoneyScreenState createState() => _AddmoneyScreenState();
}

class _AddmoneyScreenState extends State<AddmoneyScreen> {
  TextEditingController amountController = TextEditingController();
  var url =
      'https://us-central1-sylviapp-77c5e.cloudfunctions.net/paypalPayment';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read(authserviceProvider).getCurrentUserUID())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No data");
                  } else {
                    return Text(
                        snapshot.data!.get('balance').toString() + " Pesos");
                  }
                }),
            ElevatedButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Container(
                            margin: EdgeInsets.fromLTRB(70, 100, 70, 300),
                            child: Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 50,
                                      height: 20,
                                      child: TextField(
                                        controller: amountController,
                                      )),
                                  ElevatedButton(
                                      onPressed: () async {
                                        var request = BraintreeDropInRequest(
                                            tokenizationKey:
                                                'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                                            collectDeviceData: true,
                                            paypalRequest:
                                                BraintreePayPalRequest(
                                              amount: amountController.text,
                                              displayName: 'SylviaApp',
                                            ),
                                            cardEnabled: true);

                                        BraintreeDropInResult? result =
                                            await BraintreeDropIn.start(
                                          request,
                                        );

                                        if (result != null) {
                                          print(result
                                              .paymentMethodNonce.description);
                                          print(
                                              result.paymentMethodNonce.nonce);
                                          print(result.deviceData);

                                          final http.Response response =
                                              await http.post(Uri.tryParse(
                                                  '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}')!);

                                          final payResult =
                                              jsonDecode(response.body);

                                          if (payResult["result"] ==
                                              "success") {
                                            DateTime now = DateTime.now();
                                            DateTime currentTime = new DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                now.hour,
                                                now.minute);

                                            double amountTobeAdded =
                                                double.parse(
                                                    amountController.text);
                                            context
                                                .read(authserviceProvider)
                                                .addBalance(
                                                    context
                                                        .read(
                                                            authserviceProvider)
                                                        .getCurrentUserUID(),
                                                    amountTobeAdded);
                                          }
                                        } else if (result == null) {
                                          print("Braintree Result is null");
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Something Went Wrong, Please Try Again later");
                                        }
                                      },
                                      child: Text("Confirm"))
                                ],
                              ),
                            ));
                      });
                },
                child: Text("ADD MONEY"))
          ],
        ),
      ),
    );
  }
}
