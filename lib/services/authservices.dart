import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/verification/verification_finalScreen.dart';
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
      switch (e.code) {
        case "email-already-in-use":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);
          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    }
  }

  Future resetPass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "unknown":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "missing-android-pkg-name":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "missing-continue-uri":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "missing-ios-bundle-id":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "unauthorized-continue-uri":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "user-not-found":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "unknown":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "missing-android-pkg-name":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "missing-continue-uri":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "missing-ios-bundle-id":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "unauthorized-continue-uri":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "user-not-found":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    }
  }

  Future deleteAcc(String email, String password, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      var credential =
          EmailAuthProvider.credential(email: email, password: password);
      await _loggedInUser!
          .reauthenticateWithCredential(credential)
          .then((value) => {
                _loggedInUser!.delete().then((value) {
                  Navigator.pushNamed(context, '/wrapperAuth');
                  DatabaseService(uid: _loggedInUser!.uid).deleteUserData();
                })
              });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "requires-recent-login":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "user-mismatch":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-credential":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "wrong-password":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-verification-code":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid_verification_id":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "requires-recent-login":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "user-mismatch":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-credential":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "wrong-password":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid-verification-code":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "invalid_verification_id":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    }
  }

  Future updateAcc(
      String newFullName, String phoneNumber, String newAddress) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .updateUserData(AESCryptography().encryptAES(newAddress), newFullName,
              AESCryptography().encryptAES(phoneNumber))
          .whenComplete(() => Fluttertoast.showToast(msg: 'Updated'));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "email-already-in-use":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "requires-recent-login":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "email-already-in-use":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
        case "requires-recent-login":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    }
  }

  Future updatePassword(String newpass) async {
    try {
      await _loggedInUser!.updatePassword(newpass).whenComplete(
          () => Fluttertoast.showToast(msg: "Password Sucessfully Changed"));
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "invalid-email":
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              msg: e.message.toString(),
              backgroundColor: Colors.orangeAccent,
              textColor: Colors.black);

          break;
      }
    }
  }

  Future createCampaign(
      String title,
      String description,
      String campaignID,
      DateTime dateCreated,
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
              Fluttertoast.showToast(msg: "Campaign Successfully Submitted"));
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
      bool verified,
      context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .saveVerification(validIDUrl, idNumber, pictureURL,
              reasonForApplication, doHaveExperience, verified)
          .then((value) {
        Fluttertoast.showToast(
            msg: "Application for Organizer is Successfully sent");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerificationFinalScreen()));
      });

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
          .setStartDateCampaign(campaignUID, date);
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
          .then((value) => Fluttertoast.showToast(msg: "CAMPAIGN STARTED"));
    } catch (e) {
      print(e);
    }
  }

  willPopBack(bool allow) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      allow = true;
    } catch (e) {
      print(e);
    }
  }

  endTheCampaign(String campaignUID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .endTheCampaign(campaignUID);
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

  addBalanceToUserRecent(
    String uidOfCampaign,
    int amount,
    String dateDonated,
    String uidUser,
  ) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid).addBalanceToUser(
        uidOfCampaign,
        amount,
        dateDonated,
        uidUser,
      );
    } catch (e) {
      print(e);
    }
  }

  addReportScam(
      String uidOfCampaign, String uidOfVolunteer, String typeOfReport) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addReportScam(uidOfCampaign, uidOfVolunteer, typeOfReport)
          .whenComplete(() =>
              Fluttertoast.showToast(msg: "Thank you for Submitting Report"));
    } catch (e) {
      print(e);
    }
  }

  addReportAbuse(
      String uidOfCampaign, String uidOfVolunteer, String typeOfReport) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addReportAbuse(uidOfCampaign, uidOfVolunteer, typeOfReport)
          .whenComplete(() =>
              Fluttertoast.showToast(msg: "Thank you for Submitting Report"));
    } catch (e) {
      print(e);
    }
  }

  addReportUIW(
      String uidOfCampaign, String uidOfVolunteer, String typeOfReport) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addReportUIW(uidOfCampaign, uidOfVolunteer, typeOfReport)
          .whenComplete(() =>
              Fluttertoast.showToast(msg: "Thank you for Submitting Report"));
    } catch (e) {
      print(e);
    }
  }

  addFeedback(String feedback, String uidOfVolunteer, String date) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addFeedbacks(feedback, uidOfVolunteer, date)
          .whenComplete(() => Fluttertoast.showToast(msg: "Submitted"));
    } catch (e) {
      print(e);
    }
  }

  addMessage(
      String uidOfCampaign,
      String uidOfOrganizer,
      String uidOfVolunteer,
      String devicetokenOfOrg,
      String volunteerName,
      String phoneNumber,
      String gender,
      String address) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .addMessage(uidOfCampaign, uidOfOrganizer, uidOfVolunteer,
              devicetokenOfOrg, volunteerName, phoneNumber, gender, address)
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

  deleteActivity(String uidActivity) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deleteRecentActivity(uidActivity)
          .whenComplete(() => Fluttertoast.showToast(msg: "Activity Deleted"));
    } catch (e) {
      print(e);
    }
  }

  deleteRecentCampaign(String uidActivity, String volunteerUID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deleteRecentCampaign(uidActivity, volunteerUID)
          .whenComplete(() => Fluttertoast.showToast(msg: "Campaign Removed"));
    } catch (e) {
      print(e);
    }
  }

  approveVolunteer(String campaignID, String volunteerID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .approveVolunteer(campaignID, volunteerID)
          .whenComplete(
              () => Fluttertoast.showToast(msg: "volunteer approved"));
    } catch (e) {
      print(e);
    }
  }

  declineVolunteer(String campaignID, String volunteerID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .declineVolunteer(campaignID, volunteerID)
          .then((value) {
        DatabaseService(uid: _loggedInUser!.uid)
            .deleteRecentCampaign(campaignID, volunteerID);
        DatabaseService(uid: _loggedInUser!.uid)
            .removeVolunteerNumber(campaignID);
      });
    } catch (e) {
      print(e);
    }
  }

  deductInitialCampaign(String volunteerUID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deductInitialCamapaign(volunteerUID)
          .whenComplete(() => Fluttertoast.showToast(msg: "Balance Deducted"));
    } catch (e) {
      print(e);
    }
  }

  addDurationToCampaign(String campaignID, String duration) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addDurationToCampaign(campaignID, duration);
    } catch (e) {
      print(e);
    }
  }
}
