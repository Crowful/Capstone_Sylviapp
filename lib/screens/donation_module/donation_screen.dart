import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class DonationScreen extends StatefulWidget {
  const DonationScreen({Key? key}) : super(key: key);

  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var request = BraintreeDropInRequest(
                tokenizationKey: 'sandbox_mf5kvmgw_mhmfxcfrgwwftpcq',
                collectDeviceData: true,
                paypalRequest: BraintreePayPalRequest(
                  amount: '10.00',
                  displayName: 'SylviaApp',
                ),
                cardEnabled: true);

            BraintreeDropInResult? result =
                await BraintreeDropIn.start(request);

            if (result != null) {
            } else {}
          },
          child: Text("Donate"),
        ),
      ),
    );
  }
}
