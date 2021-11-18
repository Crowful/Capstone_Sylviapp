import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:sylviapp_project/providers/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sylviapp_project/translations/locale_keys.g.dart';

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
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Text(
                "Sylviapp Wallet",
                style: TextStyle(
                    color: Color(0xff65BFB8),
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Text(LocaleKeys.addmoneymainsentence.tr(),
                  style: TextStyle(color: Colors.black54, fontSize: 12)),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read(authserviceProvider).getCurrentUserUID())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No data");
                  } else {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                      child: Text(
                        snapshot.data!.get('balance').toString() + " Pesos",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                }),
            Container(
              width: 200,
              height: 50,
              margin: EdgeInsets.fromLTRB(0, 30, 0, 400),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(), primary: Color(0xff65BFB8)),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          amountController.text = '00.00';
                          return Container(
                              margin: EdgeInsets.fromLTRB(60, 150, 60, 400),
                              child: Card(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 0, 10, 10),
                                      child: Text(
                                          'Enter Amount you would like to cash in'),
                                    ),
                                    Container(
                                        color: Colors.black12,
                                        width: 80,
                                        height: 30,
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          controller: amountController,
                                        )),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                      width: 150,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(0xff65BFB8)),
                                          onPressed: () async {
                                            var request =
                                                BraintreeDropInRequest(
                                                    tokenizationKey:
                                                        'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                                                    collectDeviceData: true,
                                                    paypalRequest:
                                                        BraintreePayPalRequest(
                                                      amount:
                                                          amountController.text,
                                                      displayName: 'SylviaApp',
                                                    ),
                                                    cardEnabled: true);

                                            BraintreeDropInResult? result =
                                                await BraintreeDropIn.start(
                                              request,
                                            );

                                            if (result != null) {
                                              print(result.paymentMethodNonce
                                                  .description);
                                              print(result
                                                  .paymentMethodNonce.nonce);
                                              print(result.deviceData);

                                              final http.Response response =
                                                  await http.post(Uri.tryParse(
                                                      '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}')!);

                                              final payResult =
                                                  jsonDecode(response.body);

                                              if (payResult["result"] ==
                                                  "success") {
                                                DateTime now = DateTime.now();
                                                DateTime currentTime =
                                                    new DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day,
                                                        now.hour,
                                                        now.minute);

                                                double amountTobeAdded =
                                                    double.parse(
                                                        amountController.text);
                                                await context
                                                    .read(authserviceProvider)
                                                    .addBalance(
                                                        context
                                                            .read(
                                                                authserviceProvider)
                                                            .getCurrentUserUID(),
                                                        amountTobeAdded);

                                                await context
                                                    .read(authserviceProvider)
                                                    .addBalanceToUserRecent(
                                                      'ownAccount',
                                                      amountTobeAdded.toInt(),
                                                      currentTime.toString(),
                                                      context
                                                          .read(
                                                              authserviceProvider)
                                                          .getCurrentUserUID(),
                                                    );
                                              }
                                            } else if (result == null) {
                                              print("Braintree Result is null");
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Something Went Wrong, Please Try Again later");
                                            }
                                          },
                                          child: Text("Confirm")),
                                    )
                                  ],
                                ),
                              ));
                        });
                  },
                  child: Text(LocaleKeys.addmoney.tr())),
            )
          ],
        ),
      ),
    );
  }
}
