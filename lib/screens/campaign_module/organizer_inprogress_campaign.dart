import 'package:flutter/material.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InProgressCampaign extends StatefulWidget {
  String uidOfCampaign;
  InProgressCampaign({Key? key, required this.uidOfCampaign}) : super(key: key);

  @override
  _InProgressCampaignState createState() => _InProgressCampaignState();
}

class _InProgressCampaignState extends State<InProgressCampaign> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("CAMPAIGN IN PROGRESS"),
          ElevatedButton(
              onPressed: () {
                context
                    .read(authserviceProvider)
                    .endTheCampaign(widget.uidOfCampaign);
              },
              child: Text('Campaign Done'))
        ],
      ),
    ));
  }
}
