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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                            String amount = user.get('amount');
                            String type = user.get('type');

                            return Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                              child: Row(
                                children: [
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
                                              ? Text("Donated To Campaign")
                                              : Text("Added Balance"))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
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
