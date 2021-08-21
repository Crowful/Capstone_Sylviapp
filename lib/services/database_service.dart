import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

// Collections Reference

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference campaignCollection =
      FirebaseFirestore.instance.collection('campaigns');

  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedbacks');

//methods

  Future addUserData(String email, String fullname) async {
    return await userCollection
        .doc(uid)
        .set({'email': email, 'fullname': fullname});
  }

  Future addCampaign(String title, String description) async {
    return await campaignCollection.doc(uid).set({
      'title': title,
      'description': description,
    });
  }
}
