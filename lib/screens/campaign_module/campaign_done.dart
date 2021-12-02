import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CampaignCompleted extends StatefulWidget {
  final String campaignUID;
  const CampaignCompleted({Key? key, required this.campaignUID})
      : super(key: key);

  @override
  _CampaignCompletedState createState() => _CampaignCompletedState();
}

class _CampaignCompletedState extends State<CampaignCompleted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_very_satisfied,
                    size: 100,
                    color: Color(0xff65BFB8),
                  ),
                  Text('Campaign Done',
                      style: TextStyle(
                        color: Color(0xff65BFB8),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Thank you for your efforts, time and dedicating yourself to save our forests in the Philippines.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('campaigns')
                          .doc(widget.campaignUID)
                          .snapshots(),
                      builder: (context, snapshoted) {
                        print(widget.campaignUID);
                        if (!snapshoted.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          var duration = snapshoted.data!.get('duration');
                          var volunteers =
                              snapshoted.data!.get('current_volunteers');
                          var seed = snapshoted.data!.get('number_of_seeds');
                          var donations =
                              snapshoted.data!.get('current_donations');
                          return Card(
                            color: Colors.transparent,
                            elevation: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text('Stats of your campaign',
                                      style: TextStyle(
                                          color: Color(0xff65BFB8),
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text('Duration: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          )),
                                      Text(duration.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text('Volunteers Participated: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          )),
                                      Text(volunteers.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text('Total seeds planted: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          )),
                                      Text(seed.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text('Total seeds planted: ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          )),
                                      Text(donations.toString(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/home');
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          color: Color(0xff65BFB8)),
                                      child: Center(
                                        child: Text('Go back Home'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
