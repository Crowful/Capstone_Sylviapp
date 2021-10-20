import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/Domain/wrapperRole.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/account_module/login.dart';
import 'package:sylviapp_project/screens/account_module/onboarding.dart';
import 'package:sylviapp_project/screens/account_module/verification.dart';
import 'package:sylviapp_project/screens/account_module/verify_email.dart';
import 'package:sylviapp_project/screens/campaign_module/map.dart';
import 'package:sylviapp_project/screens/campaign_module/mapviewonly.dart';
import 'package:sylviapp_project/screens/home.dart';
import 'package:sylviapp_project/screens/layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/verification/statusRole.dart';

class WrapperVerify extends StatefulWidget {
  const WrapperVerify({Key? key}) : super(key: key);

  @override
  _WrapperVerifyState createState() => _WrapperVerifyState();
}

class _WrapperVerifyState extends State<WrapperVerify> {
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
              return StatusRoleScreen();
            } else {
              return VerificationPage();
            }
          }
        });
  }
}
