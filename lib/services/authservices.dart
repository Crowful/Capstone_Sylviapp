import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'database_service.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/register_basic_info.dart';

//Get Firestore instance
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

      await DatabaseService(uid: _loggedInUser!.uid)
          .addUserData(email, fullname, address, gender, phoneNumber, username);
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
}
