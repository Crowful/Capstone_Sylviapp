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

//User
  Future addUserData(
    String email,
    String fullname,
    String address,
    String gender,
    String phoneNumber,
    String username,
  ) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'fullname': fullname,
      'address': address,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'username': username,
    });
  }

  Future deleteUserData() async {
    return await userCollection.doc(uid).delete();
  }

  Future updateUserData(
    String email,
    String fullname,
    String address,
  ) async {
    return await userCollection.doc(uid).update({
      'email': email,
      'fullname': fullname,
      'address': address,
    });
  }

//Campaign
  Future addCampaign(
      String title,
      String description,
      String campaignID,
      String dateCreated,
      String dateStart,
      String dateEnded,
      String address,
      String city,
      String time,
      String userUID,
      String userName,
      String latitude,
      String longitude,
      int numSeeds,
      String currentDonations,
      String maxDonations,
      int currentVolunteers,
      int numberVolunteers) async {
    return await campaignCollection.doc(uid).set({
      'campaignID': campaignID,
      'campaign_name': title,
      'description': description,
      'date_created': dateCreated,
      'date_start': dateStart,
      'date_ended': dateEnded,
      'address': address,
      'city': city,
      'time': time,
      'uid': userUID,
      'username': userName,
      'latitude': latitude,
      'longitude': longitude,
      'number_of_seeds': numSeeds,
      'current_donations': currentDonations,
      'max_donation': maxDonations,
      'current_volunteers': currentVolunteers,
      'number_volunteers': numberVolunteers,
    });
  }
}
