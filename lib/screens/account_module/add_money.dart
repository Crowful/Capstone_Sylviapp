import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/rendering.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:encrypt/encrypt.dart' as enc;

import 'package:http/http.dart' as http;
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/animation/pop_up.dart';
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xff65BFB8),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          color: Color(0xff403d55),
                        ),
                        Text(
                          'Sylviapp',
                          style: TextStyle(
                              color: Color(0xff65BFB8),
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_outline),
                          onPressed: () {},
                          color: Colors.transparent,
                        ),
                      ]),
                  Container(
                    padding: EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sylviapp Wallet",
                          style: TextStyle(
                              color: Color(0xff65BFB8),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(LocaleKeys.addmoneymainsentence.tr(),
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(context
                                    .read(authserviceProvider)
                                    .getCurrentUserUID())
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("No Balance");
                              } else {
                                return Card(
                                  color: Colors.transparent,
                                  elevation: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                              Color(0xff65BFB8),
                                              Color(0xff81dbd4),
                                            ],
                                            begin: FractionalOffset.topLeft,
                                            end: FractionalOffset.bottomRight,
                                            tileMode: TileMode.repeated),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Sylviapp',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30),
                                                ),
                                                Text(
                                                  AESCryptography().decryptAES(
                                                      enc.Encrypted.fromBase64(
                                                          snapshot.data!.get(
                                                              "fullname"))),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  AESCryptography().decryptAES(
                                                      enc.Encrypted.fromBase64(
                                                          snapshot.data!
                                                              .get("gender"))),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/ohayafullwhite.png'),
                                                      fit: BoxFit.contain)),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "₱" +
                                                  snapshot.data!
                                                      .get('balance')
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              AESCryptography().decryptAES(
                                                  enc.Encrypted.fromBase64(
                                                      snapshot.data!
                                                          .get("phoneNumber"))),
                                              style: TextStyle(
                                                  letterSpacing: 5,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(HeroDialogRoute(builder: (context) {
                      return addBalance();
                    }));
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: Center(
                        child: Text(
                      LocaleKeys.addmoney.tr(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addBalance() {
    amountController.text = '00.00';
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        height: 200,
        width: double.infinity,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Add Money',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Enter Amount you would like to cash in',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(),
                controller: amountController,
              ),
            ),
            GestureDetector(
              onTap: () async {
                var request = BraintreeDropInRequest(
                    tokenizationKey: 'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                    collectDeviceData: true,
                    paypalRequest: BraintreePayPalRequest(
                      amount: amountController.text,
                      displayName: 'SylviaApp',
                    ),
                    cardEnabled: true);

                BraintreeDropInResult? result = await BraintreeDropIn.start(
                  request,
                );

                if (result != null) {
                  final http.Response response = await http.post(Uri.tryParse(
                      '$url?payment_method_nonce=${result.paymentMethodNonce.nonce}&device_data=${result.deviceData}')!);

                  final payResult = jsonDecode(response.body);

                  if (payResult["result"] == "success") {
                    DateTime now = DateTime.now();
                    DateTime currentTime = new DateTime(
                        now.year, now.month, now.day, now.hour, now.minute);

                    double amountTobeAdded =
                        double.parse(amountController.text);

                    Navigator.pop(context);
                    await context.read(authserviceProvider).addBalance(
                        context.read(authserviceProvider).getCurrentUserUID(),
                        amountTobeAdded,
                        context);

                    await context
                        .read(authserviceProvider)
                        .addBalanceToUserRecent(
                          'ownAccount',
                          amountTobeAdded.toInt(),
                          currentTime.toString(),
                          context.read(authserviceProvider).getCurrentUserUID(),
                        );
                  }
                } else if (result == null) {
                  Fluttertoast.showToast(
                      msg: "Something Went Wrong, Please Try Again later");
                }
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xff65BFB8),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(child: Text("Confirm")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
