import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      Row(children: [
        Text("RISK METER"),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 200,
          child: LinearProgressIndicator(
              semanticsLabel: "Donated",
              semanticsValue: "Donating",
              backgroundColor: Colors.grey.withOpacity(0.3),
              color: Colors.amber,
              minHeight: 15,
              value: 0.5),
        ),
      ]),
    ]);
  }

  List<CampaignData> getCampaignData() {
    final List<CampaignData> chartData = [
      CampaignData('Active Campaign', widget.activeCampaign),
      CampaignData('Done Campaign', widget.doneCampaign),
      CampaignData('Campaign in Progress', widget.campaignInProgress),
    ];

    return chartData;
  }
}

class CampaignData {
  CampaignData(this.campaign, this.status);
  final String campaign;
  final int status;
}
