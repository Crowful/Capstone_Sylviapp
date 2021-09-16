import 'package:flutter/material.dart';

class CampaignWidget {
  Widget makeCampaign() {
    return Container(
      padding: EdgeInsets.all(10),
      width: 100,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ]),
      child: Row(
        children: [],
      ),
    );
  }
}