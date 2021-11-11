import 'package:flutter/material.dart';

class CampaignInProgress extends StatefulWidget {
  const CampaignInProgress({Key? key}) : super(key: key);

  @override
  _CampaignInProgressState createState() => _CampaignInProgressState();
}

class _CampaignInProgressState extends State<CampaignInProgress> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text("INSTRUCTIONS"),
            ],
          ),
        ),
      ),
    );
  }
}
