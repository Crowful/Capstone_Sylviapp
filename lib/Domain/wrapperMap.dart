import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/campaign_module/map.dart';
import 'package:sylviapp_project/screens/campaign_module/mapviewonly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WrapperMap extends StatefulWidget {
  const WrapperMap({Key? key}) : super(key: key);

  @override
  _WrapperMapState createState() => _WrapperMapState();
}

class _WrapperMapState extends State<WrapperMap> {
  @override
  Widget build(BuildContext context) {
    dynamic userUID = context.read(authserviceProvider).getCurrentUserUID();
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userUID)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text(
              'No Data...',
            );
          } else {
            bool status = snapshot.data!.get('isVerify');
            if (status == true) {
              return MapScreen();
            } else {
              return MapViewOnly();
            }
          }
        });
  }
}
