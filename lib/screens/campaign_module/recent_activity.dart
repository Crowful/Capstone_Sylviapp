import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({Key? key}) : super(key: key);

  @override
  _RecentActivityState createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                " Recent Activities ",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff65BFB8)),
              ),
              alignment: Alignment.topLeft,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Text(
                " Recent Activities would be display here, it includes the adding balance of your account and deduction of your balance if you donate a campaign ",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54),
              ),
              alignment: Alignment.topLeft,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(context.read(authserviceProvider).getCurrentUserUID())
                    .collection('recent_activities')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot user = snapshot.data!.docs[index];

                            Timestamp date = user.get('dateDonated');
                            String amount = user.get('amount').toString();
                            String type = user.get('type');

                            return Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  type == 'donated'
                                      ? Icon(
                                          Icons.campaign_rounded,
                                          size: 40,
                                          color: Colors.grey,
                                        )
                                      : Icon(
                                          Icons.monetization_on,
                                          size: 40,
                                          color: Colors.green,
                                        ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          DateTime.parse(
                                                  date.toDate().toString())
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.black54,
                                          )),
                                      Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 0),
                                          child: type == 'donated'
                                              ? Text(
                                                  "Donated $amount to Campaign ")
                                              : Text(
                                                  "Added Balance of $amount"))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await context
                                          .read(authserviceProvider)
                                          .deleteActivity(user.id);
                                    },
                                    child: Text("Delete"),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                  )
                                ],
                              ),
                            );
                          }),
                    );
                  }
                })
          ],
        ),
      )),
    );
  }
}
