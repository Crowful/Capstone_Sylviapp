import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

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
    ]);
  }

  List<CampaignData> getCampaignData() {
    final List<CampaignData> chartData = [
      CampaignData('Active Campaign', 25),
      CampaignData('Inactive Campaign', 10),
      CampaignData('Campaign Done', 30),
    ];

    return chartData;
  }
}

class CampaignData {
  CampaignData(this.campaign, this.status);
  final String campaign;
  final int status;
}
