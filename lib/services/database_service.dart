import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

// Collections Reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference campaignCollection =
      FirebaseFirestore.instance.collection('admin_campaign_requests');

  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedbacks');

  final CollectionReference verificationCollection =
      FirebaseFirestore.instance.collection('verification');

  final CollectionReference approvedCampaignCollection =
      FirebaseFirestore.instance.collection('campaigns');

  final CollectionReference messageCollection =
      FirebaseFirestore.instance.collection('message');

//methods

//User
  Future addUserData(
      String email,
      String fullname,
      String address,
      String gender,
      String phoneNumber,
      String username,
      String deviceToken) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'fullname': fullname,
      'address': address,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'username': username,
      'isApplying': false,
      'isVerify': false,
      'deviceToken': deviceToken,
      'balance': 00.00,
    });
  }

  Future deleteUserData() async {
    return await userCollection.doc(uid).delete();
  }

  Future updateUserData(
    String email,
    String fullname,
    int phoneNumber,
  ) async {
    return await userCollection.doc(uid).update({
      'email': email,
      'fullname': fullname,
      'phoneNumber': phoneNumber,
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
      double latitude,
      double longitude,
      int numSeeds,
      double currentDonations,
      double maxDonations,
      int currentVolunteers,
      int numberVolunteers,
      String deviceTokenOfOrganizer,
      double campaignRadius) async {
    return await campaignCollection.doc(campaignID).set({
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
      'deviceTokenofOrganizer': deviceTokenOfOrganizer,
      'radius': campaignRadius,
      'isActive': false,
      'isDone': false,
      'inProgress': false,
    });
  }

  Future saveVerification(
    String validIDUrl,
    String idNumber,
    String pictureURL,
    String reasonForApplication,
    String doHaveExperience,
    bool verified,
  ) async {
    return await verificationCollection.doc(uid).set({
      'validIDUrl': validIDUrl,
      'idNumber': idNumber,
      'pictureURL': pictureURL,
      'reasonForApplication': reasonForApplication,
      'doHaveExperience': doHaveExperience,
      'getVerified': verified
    });
  }

  Future updateApplication() async {
    return await userCollection.doc(uid).update({
      'isApplying': true,
    });
  }

  Future addAnnouncement(String uidOfCampaign, String announcement) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .collection("announcement")
        .doc('announcement')
        .set({"currentAnnouncement": announcement});
  }

//Join Campaign
  Future joinCampaign(String uidOfCampaign, String registeredUID) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .collection("volunteers")
        .doc(registeredUID)
        .set({"volunteerUID": registeredUID, "isApprove": false});
  }

  Future addVolunteerNumber(String uidOfCampaign) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .update({'current_volunteers': FieldValue.increment(1)});
  }

  Future addCampaigntoUser(String uidOfCampaign, String registeredUID) async {
    return await userCollection
        .doc(registeredUID)
        .collection("campaigns")
        .doc(uidOfCampaign)
        .set({"campaign": uidOfCampaign});
  }

//LEAVE CAMPAIGN
  Future removeCampaigntoUser(
      String uidOfCampaign, String registeredUID) async {
    return await userCollection
        .doc(registeredUID)
        .collection("campaigns")
        .doc(uidOfCampaign)
        .delete();
  }

  Future removeVolunteerNumber(String uidOfCampaign) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .update({'current_volunteers': FieldValue.increment(-1)});
  }

  Future leaveCampaign(String uidOfCampaign, String registeredUID) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .collection("volunteers")
        .doc(registeredUID)
        .delete();
  }

  Future setStartDateCampaign(String uidOfCampaign, String dateCampaign) async {
    return await approvedCampaignCollection.doc(uidOfCampaign).update({
      'date_start': dateCampaign,
    });
  }

  Future starTheCampaign(String uidOfCampaign) async {
    return await approvedCampaignCollection.doc(uidOfCampaign).update({
      'inProgress': true,
    });
  }

  Future donatedToCampaign(
    String uidOfCampaign,
    int amount,
    String dateDonated,
    String uidUser,
  ) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .collection('donations')
        .doc(uidUser)
        .set({
      'uid': uidUser,
      'amount': amount,
      'dateDonated': dateDonated,
      'campaignUID': uidOfCampaign
    });
  }

  Future donatedToCampaignUser(
    String uidOfCampaign,
    int amount,
    String dateDonated,
    String uidUser,
  ) async {
    return await userCollection
        .doc(uid)
        .collection('recent_activities')
        .doc(dateDonated)
        .set({
      'uid': uidUser,
      'amount': amount,
      'dateDonated': dateDonated,
      'campaignUID': uidOfCampaign
    });
  }

  Future incrementDonation(
    String uidOfCampaign,
    int amount,
  ) async {
    return await approvedCampaignCollection.doc(uidOfCampaign).update({
      'current_donations': FieldValue.increment(amount),
    });
  }

  Future addReports(
      String uidOfCampaign, String registeredUID, String typeOfReport) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .collection("reports")
        .doc(registeredUID)
        .set({"report": typeOfReport});
  }

  Future addMessage(String uidOfCampaign, String uidOfOrganizer,
      String uidOfVolunteer, String devicetokenOfOrg) async {
    return await approvedCampaignCollection
        .doc(uidOfCampaign)
        .collection('distress')
        .doc(uidOfVolunteer)
        .set({
      "timeStamp": FieldValue.serverTimestamp(),
      'volunteerUID': uidOfVolunteer,
      'organizerUID': uidOfOrganizer,
      'deviceToken': devicetokenOfOrg,
      'title': 'DISTRESS HELP HELP',
      'body': 'BODY DISTRESS HELP HELP'
    });
  }

  Future addBalance(String volunteerUID, double newBalance) async {
    return await userCollection
        .doc(volunteerUID)
        .update({"balance": FieldValue.increment(newBalance)});
  }

  Future deductBalance(String volunteerUID, double newBalance) async {
    return await userCollection
        .doc(volunteerUID)
        .update({"balance": FieldValue.increment(-newBalance)});
  }
}
