import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: StreamBuilder<QuerySnapshot>(
            stream: null,
            builder: (context, snapshot) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                    SizedBox(
                      height: 20,
                    ),
                    Text("data")
                  ],
                ),
              );
            }),
      ),
    );
  }
}
