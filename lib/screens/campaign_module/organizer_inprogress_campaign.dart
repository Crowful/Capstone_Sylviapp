import 'package:flutter/material.dart';

class InProgressCampaign extends StatefulWidget {
  const InProgressCampaign({Key? key}) : super(key: key);

  @override
  _InProgressCampaignState createState() => _InProgressCampaignState();
}

class _InProgressCampaignState extends State<InProgressCampaign> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Text("CAMPAIGN IN PROGRESS"),
          ElevatedButton(onPressed: () {}, child: Text('Campaign Done'))
        ],
      ),
    ));
  }
}
