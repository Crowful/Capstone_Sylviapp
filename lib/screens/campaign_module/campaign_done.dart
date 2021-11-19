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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                  'Thank you for your efforts, time and dedicating yourself to save our forests in the philippines. In this Screen you can be able to see some information about your campaign.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('Duration: ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('24:00',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('Volunteers Participated: ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text('50 Volunteers',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xff65BFB8), shape: StadiumBorder()),
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('Go back Home')),
            )
          ],
        ),
      ),
    );
  }
}
