import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampaignCompleted extends StatefulWidget {
  const CampaignCompleted({Key? key}) : super(key: key);

  @override
  _CampaignCompletedState createState() => _CampaignCompletedState();
}

class _CampaignCompletedState extends State<CampaignCompleted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('Campaign Done',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('Campaign Duration',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('Campaign organizer',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('Campaign volunteers',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
