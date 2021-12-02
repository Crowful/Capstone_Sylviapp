import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampaignCompleted extends StatefulWidget {
  String uidOfCampaign;
  CampaignCompleted({Key? key, required this.uidOfCampaign}) : super(key: key);

  @override
  _CampaignCompletedState createState() => _CampaignCompletedState();
}

class _CampaignCompletedState extends State<CampaignCompleted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('campaigns')
                .doc(widget.uidOfCampaign)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (snapshot.data!.exists) {
                  return Column(
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
                        child: Text(snapshot.data!.get('duration').toString(),
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
                        child: Text(
                            snapshot.data!.get('current_volunteers').toString(),
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
                                primary: Color(0xff65BFB8),
                                shape: StadiumBorder()),
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            child: Text('Go back Home')),
                      )
                    ],
                  );
                } else {
                  return Column(children: [
                    Text(
                        'Something Went Wrong in retrieving the data, Please try again later'),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Go back home'))
                  ]);
                }
              }
            }),
      ),
    );
  }
}
