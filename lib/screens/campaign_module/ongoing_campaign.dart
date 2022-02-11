import 'package:flutter/material.dart';

class OngoingCampaign extends StatefulWidget {
  const OngoingCampaign({Key? key}) : super(key: key);

  @override
  _OngoingCampaignState createState() => _OngoingCampaignState();
}

class _OngoingCampaignState extends State<OngoingCampaign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Column(
          children: [
            Text("This is ongoing Campaign Screen"),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Center(child: Text("Campaign"));
                })
          ],
        ),
      )),
    );
  }
}
