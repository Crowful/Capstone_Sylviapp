import 'package:flutter/material.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

// ignore: must_be_immutable
class InProgressCampaign extends StatefulWidget {
  String uidOfCampaign;
  InProgressCampaign({Key? key, required this.uidOfCampaign}) : super(key: key);

  @override
  _InProgressCampaignState createState() => _InProgressCampaignState();
}

class _InProgressCampaignState extends State<InProgressCampaign> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text('Campaign in Progress',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text(
                'Start planting trees, As an organizer guide the volunteers to the exact location of the forest. You are responsible for the execution of this campaign.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Text(
                'Dont leave your phone behind, distress from volunteers should be monitored accordingly.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                )),
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<int>(
              initialData: 0,
              stream: _stopWatchTimer.rawTime,
              builder: (context, snap) {
                final value = snap.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!);
                return Column(
                  children: [
                    Text(displayTime.toString()),
                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff65BFB8),
                              shape: StadiumBorder()),
                          onPressed: () async {
                            await context
                                .read(authserviceProvider)
                                .addDurationToCampaign(widget.uidOfCampaign,
                                    StopWatchTimer.getDisplayTime(value));
                            await context
                                .read(authserviceProvider)
                                .endTheCampaign(widget.uidOfCampaign);
                          },
                          child: Text('Campaign Done')),
                    )
                  ],
                );
              }),
        ],
      ),
    ));
  }
}
