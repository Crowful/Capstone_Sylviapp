import 'package:flutter/material.dart';

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
        child: Column(
          children: [
            Text("This is Recent Activity Screen"),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Center(child: Text("Date ---- Location ---- status"));
                })
          ],
        ),
      )),
    );
  }
}
