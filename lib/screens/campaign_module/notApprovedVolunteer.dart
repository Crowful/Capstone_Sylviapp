import 'package:flutter/material.dart';

class NotApprovedVolunteer extends StatefulWidget {
  const NotApprovedVolunteer({Key? key}) : super(key: key);

  @override
  _NotApprovedVolunteerState createState() => _NotApprovedVolunteerState();
}

class _NotApprovedVolunteerState extends State<NotApprovedVolunteer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'Thank you for submitting volunteer application, wait for the organizer to accept you as a volunteer. The organizer will review your credentials if you are qualified to join to this campaign. Thank you.'),
      ),
    );
  }
}
