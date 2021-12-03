import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sylviapp_project/screens/campaign_module/campaign_monitor_volunteer.dart';
import 'package:sylviapp_project/screens/campaign_module/notApprovedVolunteer.dart';
import 'package:sylviapp_project/screens/layout_screen.dart';

// ignore: must_be_immutable
class WrapperUsApproved extends StatefulWidget {
  String campaignID;
  String volunteerUID;
  WrapperUsApproved(
      {Key? key, required this.campaignID, required this.volunteerUID})
      : super(key: key);

  @override
  _WrapperUsApprovedState createState() => _WrapperUsApprovedState();
}

class _WrapperUsApprovedState extends State<WrapperUsApproved> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("campaigns")
            .doc(widget.campaignID)
            .collection('volunteers')
            .doc(widget.volunteerUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'No Data...',
            );
          } else {
            if (snapshot.data!.exists) {
              bool status = snapshot.data!.get('isApprove');
              if (status == true) {
                return CampaignMonitorVolunteer(
                  uidOfCampaign: widget.campaignID,
                );
              } else if (status == false) {
                return NotApprovedVolunteer();
              } else {
                return LayoutScreen();
              }
            } else {
              return LayoutScreen();
            }
          }
        });
  }
}
