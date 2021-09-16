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
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                      child: Row(
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Color(0xff65BFB8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: Icon(Icons.access_alarm)),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              Text("04 March, 2021 | 2:03 pm",
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: Text("Joined Campaign"))
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("Delete"),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      )),
    );
  }
}
