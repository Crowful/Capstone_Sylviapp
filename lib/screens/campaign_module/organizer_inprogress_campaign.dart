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
  bool allows = false;
  @override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    allows = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () {
        return Future.value(allows); // if true allow back else block it
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Campaign in Progress',
                  style: TextStyle(
                    color: Color(0xff65BFB8),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                  'Start planting trees, As an organizer guide the volunteers to the exact location of the forest. You are responsible for the execution of this campaign.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                  'Dont leave your phone behind, distress from volunteers should be monitored accordingly.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  )),
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
                        Row(
                          children: [
                            Text(
                              'Duration: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(displayTime.toString()),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              allows = true;
                            });
                            await context
                                .read(authserviceProvider)
                                .addDurationToCampaign(widget.uidOfCampaign,
                                    StopWatchTimer.getDisplayTime(value));
                            await context
                                .read(authserviceProvider)
                                .endTheCampaign(widget.uidOfCampaign);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xff65BFB8),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Text('Campaign Done'),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}
