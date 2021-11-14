import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'database_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Get Firestore instance
// ignore: unused_element
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Get Firestore Collection (USER)

class AuthService extends ChangeNotifier {
  //instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  //getUI
  static String? userUid = FirebaseAuth.instance.currentUser!.uid;

  //loggedInUser
  User? _loggedInUser;

  //Get Reference

  //UserChanges
  Stream<User?> get getauthStateChange {
    return _auth.authStateChanges();
  }

  Future<bool> get userVerified async {
    await _auth.currentUser!.reload();
    return _auth.currentUser!.emailVerified;
  }

  //getters

  User? get getUser {
    _loggedInUser = getauthStateChange as User;

    return _loggedInUser;
  }

  String getCurrentUserUID() {
    var currentUser = _auth.currentUser;

    if (currentUser == null) {
      return "No user";
    } else {
      return currentUser.uid.toString();
    }
  }

  String getCurrentUserDisplayName() {
    var currentUser = _auth.currentUser;
    return currentUser!.displayName.toString();
  }

  //Service Methods

  Future signIn(String email, String password) async {
    try {
      final signedInUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _loggedInUser = signedInUser.user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "wrong-password":
          Fluttertoast.showToast(
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);
          break;
        case "invalid-email":
          Fluttertoast.showToast(
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);
          break;
        case "user-not-found":
          Fluttertoast.showToast(
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);
          break;
      }
    } on PlatformException catch (e) {
      print(e.code);
      switch (e.code) {
        case "wrong-password":
          Fluttertoast.showToast(
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);
          break;
        case "invalid-email":
          Fluttertoast.showToast(
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);
          break;
        case "user-not-found":
          Fluttertoast.showToast(
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);
          break;
      }
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future signUp(String email, String password, String fullname, String address,
      String gender, String phoneNumber, String username) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _loggedInUser = newUser.user!;
      _loggedInUser!.sendEmailVerification();
      await FirebaseMessaging.instance.getToken().then((value) {
        DatabaseService(uid: _loggedInUser!.uid).addUserData(
            email, fullname, address, gender, phoneNumber, username, value!);
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future resetPass(String email) async {
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .whenComplete(() => print("Successully Sent"));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future deleteAcc() async {
    try {
      await DatabaseService(uid: _loggedInUser!.uid)
          .deleteUserData()
          .whenComplete(() => _loggedInUser!.delete());
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future updateAcc(String newFullName, int phoneNumber, String newEmail) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await _loggedInUser!.updateEmail(newEmail);
      await DatabaseService(uid: _loggedInUser!.uid)
          .updateUserData(newEmail, newFullName, phoneNumber);
    } catch (e) {
      print("EROOOOOOOOOOOOOOOOOOR" + e.toString());
    }
  }

  Future updatePassword(String newpass) async {
    try {
      await _loggedInUser!.updatePassword(newpass).whenComplete(
          () => Fluttertoast.showToast(msg: "Password Sucessfully Changed"));
    } catch (e) {
      print(e);
    }
  }

  Future createCampaign(
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
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: userUID)
          .addCampaign(
              title,
              description,
              campaignID,
              dateCreated,
              dateStart,
              dateEnded,
              address,
              city,
              time,
              _loggedInUser!.uid,
              userName,
              latitude,
              longitude,
              numSeeds,
              currentDonations,
              maxDonations,
              currentVolunteers,
              numberVolunteers,
              deviceTokenOfOrganizer,
              campaignRadius)
          .whenComplete(() =>
              Fluttertoast.showToast(msg: "Campaign Successfully Created"));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future createApplication(
      String validIDUrl,
      String idNumber,
      String pictureURL,
      String reasonForApplication,
      String doHaveExperience,
      bool isVerify,
      bool verified) async {
    try {
      await DatabaseService(uid: _loggedInUser!.uid)
          .saveVerification(validIDUrl, idNumber, pictureURL,
              reasonForApplication, doHaveExperience, verified)
          .whenComplete(() => Fluttertoast.showToast(
              msg: "Application for Organizer is Successfully sent"));

      await DatabaseService(uid: _loggedInUser!.uid).updateApplication();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  joinCampaign(String campaignUID, volunteerUID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .joinCampaign(campaignUID, volunteerUID)
          .whenComplete(() => Fluttertoast.showToast(msg: "J O I N E D"));
      await DatabaseService(uid: _loggedInUser!.uid)
          .addVolunteerNumber(campaignUID);
      await DatabaseService(uid: _loggedInUser!.uid)
          .addCampaigntoUser(campaignUID, volunteerUID);
    } catch (e) {
      print(e);
    }
  }

  leaveCampaign(String campaignUID, volunteerUID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .leaveCampaign(campaignUID, volunteerUID);

      await DatabaseService(uid: _loggedInUser!.uid)
          .removeVolunteerNumber(campaignUID);
      await DatabaseService(uid: _loggedInUser!.uid)
          .removeCampaigntoUser(campaignUID, volunteerUID);
    } catch (e) {
      print(e);
    }
  }

  addAnnouncement(String campaignUID, String announcement) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .addAnnouncement(campaignUID, announcement)
          .whenComplete(() => Fluttertoast.showToast(msg: "POSTED"));
    } catch (e) {
      print(e);
    }
  }

  setStartingDate(String campaignUID, String date) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .setStartDateCampaign(campaignUID, date)
          .whenComplete(() => Fluttertoast.showToast(msg: "DATE POSTED"));
    } catch (e) {
      print(e);
    }
  }

  startTheCampaign(String campaignUID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .starTheCampaign(campaignUID)
          .whenComplete(() => Fluttertoast.showToast(msg: "CAMPAIGN STARTED"));
    } catch (e) {
      print(e);
    }
  }

  donateCampaign(String uidOfCampaign, int amount, String dateDonated,
      String uidUser) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .donatedToCampaign(uidOfCampaign, amount, dateDonated, uidUser)
          .whenComplete(() => DatabaseService(uid: _loggedInUser!.uid)
              .incrementDonation(uidOfCampaign, amount));
    } catch (e) {
      print(e);
    }
  }

  donateCampaignUser(
    String uidOfCampaign,
    int amount,
    String dateDonated,
    String uidUser,
  ) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .donatedToCampaignUser(
            uidOfCampaign,
            amount,
            dateDonated,
            uidUser,
          )
          .whenComplete(() => Fluttertoast.showToast(msg: "Donated"));
    } catch (e) {
      print(e);
    }
  }

  addReport(
      String uidOfCampaign, String uidOfVolunteer, String typeOfReport) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addReports(uidOfCampaign, uidOfVolunteer, typeOfReport)
          .whenComplete(() => Fluttertoast.showToast(msg: "Reported"));
    } catch (e) {
      print(e);
    }
  }

  addMessage(String uidOfCampaign, String uidOfOrganizer, String uidOfVolunteer,
      String devicetokenOfOrg) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addMessage(
              uidOfCampaign, uidOfOrganizer, uidOfVolunteer, devicetokenOfOrg)
          .whenComplete(() =>
              Fluttertoast.showToast(msg: "DISTRESS SUBMITTED TO ORGANIZER"));
    } catch (e) {
      print(e);
    }
  }

  addBalance(String volunteerUID, double newBalance) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addBalance(volunteerUID, newBalance)
          .whenComplete(() => Fluttertoast.showToast(msg: "Balance Updated"));
    } catch (e) {
      print(e);
    }
  }

  deductBalance(String volunteerUID, double newBalance) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deductBalance(volunteerUID, newBalance)
          .whenComplete(() => Fluttertoast.showToast(msg: "Balance Updated"));
    } catch (e) {
      print(e);
    }
  }
}
