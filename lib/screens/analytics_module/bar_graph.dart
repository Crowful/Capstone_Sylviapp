import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sylviapp_project/translations/locale_keys.g.dart';

// ignore: must_be_immutable
class Chart extends StatefulWidget {
  int activeCampaign;
  int doneCampaign;
  int campaignInProgress;
  Chart(
      {Key? key,
      required this.activeCampaign,
      required this.doneCampaign,
      required this.campaignInProgress})
      : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late List<CampaignData> _chartData;

  @override
  void initState() {
    _chartData = getCampaignData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SfCircularChart(
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
            position: LegendPosition.bottom),
        series: <CircularSeries>[
          DoughnutSeries<CampaignData, String>(
              dataSource: _chartData,
              xValueMapper: (CampaignData data, _) => data.campaign,
              yValueMapper: (CampaignData data, _) => data.status,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside))
        ],
      ),
      SizedBox(
        height: 20,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('isVerify', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  var numOfVolunteer = snapshot.data!.size;
                  return Container(
                      height: 100,
                      width: 170,
                      child: Card(
                        elevation: 5,
                        color: Colors.teal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$numOfVolunteer ' + LocaleKeys.volunteers.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ));
                }
              }),
          SizedBox(
            width: 20,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('isVerify', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  var numOfOrganizer = snapshot.data!.size;
                  return Container(
                      height: 100,
                      width: 170,
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.leaderboard,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$numOfOrganizer ' + LocaleKeys.organizers.tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        elevation: 5,
                        color: Colors.blueGrey,
                      ));
                }
              }),
        ],
      ),
      SizedBox(height: 30),
      Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('campaigns')
                  .where('campaignID', isNull: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  var numOfCampaigns = snapshot.data!.size;
                  return Container(
                      child: Text(
                    "$numOfCampaigns",
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
                  ));
                }
              })),
      Text(
        LocaleKeys.overallcampaign.tr(),
        style: TextStyle(color: Colors.black54),
      )
    ]);
  }

  List<CampaignData> getCampaignData() {
    final List<CampaignData> chartData = [
      CampaignData(LocaleKeys.activeCampaign.tr(), widget.activeCampaign),
      CampaignData(LocaleKeys.doneCampaign.tr(), widget.doneCampaign),
      CampaignData(
          LocaleKeys.campaignInProgress.tr(), widget.campaignInProgress),
    ];

    return chartData;
  }
}

class CampaignData {
  CampaignData(this.campaign, this.status);
  final String campaign;
  final int status;
}
