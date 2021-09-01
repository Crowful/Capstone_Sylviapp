import 'package:flutter/material.dart';

class CampaignWidget {
  Widget makeCampaign() {
    return Container(
      height: 200,
      width: double.infinity,
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
