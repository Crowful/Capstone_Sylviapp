import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/verification/verification_finalScreen.dart';
import 'package:sylviapp_project/widgets/snackbar_widgets/custom_snackbar.dart';
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

  Future requestForNewVerificationEmail() async {
    _loggedInUser!.sendEmailVerification();
  }

  //Service Methods

  Future signIn(String email, String password, context) async {
    try {
      final signedInUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _loggedInUser = signedInUser.user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "wrong-password":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Wrong Password",
              "The password you logged in is incorrect please try again, thank you.");
          break;
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Invalid Email",
              "The email you logged in is invalid, please try another email or create a new one");
          break;
        case "user-not-found":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops We cannot find your account",
              "If you're not registered yet, please create a new account to access sylviapp features");
          break;
        case "too-many-requests":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Try Again later",
              "You exceed the times of loging in, please try again later.");
          break;
      }
    } on PlatformException catch (e) {
      print(e.code);
      switch (e.code) {
        case "wrong-password":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Wrong Password",
              "The password you logged in is incorrect please try again, thank you.");
          break;
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Invalid Email",
              "The email you logged in is invalid, please try another email or create a new one");
          break;
        case "user-not-found":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops We cannot find your account",
              "If you're not registered yet, please create a new account to access sylviapp features");
          break;
        case "too-many-requests":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Try Again later",
              "You exceed the times of loging in, please try again later.");
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
      String gender, String phoneNumber, String username, context) async {
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
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Email is already taken",
              "Please log in to your old email, or try another email that has not registered before, thank you.");
          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orangeAccent,
              "Oops Email is already taken",
              "Please log in to your old email, or try another email that has not registered before, thank you.");

          break;
      }
    }
  }

  Future resetPass(String email, context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "unknown":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Something went wrong",
              "Sorry, Sylviapp encountered unknown error, don't worry we are this error is on our side, please try again, thank you");

          break;
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid email",
              "Please make sure that the email you typed is correct and make sure there are no mistyped word, please try again.");

          break;
        case "missing-android-pkg-name":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1056, this error is due to the missing android pkg name, please contact customer service, thankyou.");

          break;
        case "missing-continue-uri":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1057, this error is due to the missing Continue URI, please contact customer service, thankyou.");

          break;
        case "missing-ios-bundle-id":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1058, this error is due to the missing Ios bundle ID, please contact customer service, thankyou.");

          break;
        case "unauthorized-continue-uri":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1058, this error is due to the unauthorized continue URI, please contact customer service, thankyou.");

          break;
        case "user-not-found":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops We Cannot find that user",
              "Please make sure that you typed is correct for both email and password, Please try again.");

          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "unknown":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Something went wrong",
              "Sorry, Sylviapp encountered unknown error, don't worry we are this error is on our side, please try again, thank you");

          break;
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid email",
              "Please make sure that the email you typed is correct and make sure there are no mistyped word, please try again.");

          break;
        case "missing-android-pkg-name":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1056, this error is due to the missing android pkg name, please contact customer service, thankyou.");

          break;
        case "missing-continue-uri":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1057, this error is due to the missing Continue URI, please contact customer service, thankyou.");

          break;
        case "missing-ios-bundle-id":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1058, this error is due to the missing Ios bundle ID, please contact customer service, thankyou.");

          break;
        case "unauthorized-continue-uri":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.red,
              "Oops Encountered Error",
              "Error 1058, this error is due to the unauthorized continue URI, please contact customer service, thankyou.");

          break;
        case "user-not-found":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops We Cannot find that user",
              "Please make sure that you typed is correct for both email and password, Please try again.");

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
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Recent Login is required",
              "Please make sure that your account is logged in before, for more information contact customer support.");

          break;
        case "user-mismatch":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops User is Mismatch",
              "Please make sure all the credentials are correct, please try again.");

          break;
        case "invalid-credential":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Credential",
              "Please make sure all the credentials are correct, please try again. Thank you");

          break;
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Email",
              "Please make sure the email is correct, please try again. Thank you");

          break;
        case "wrong-password":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Wrong Password",
              "Please make sure the password is correct, please try again. Thank you");

          break;
        case "invalid-verification-code":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Verification Code",
              "Please make sure the Verification Code is correct, please try again. Thank you");

          break;
        case "invalid_verification_id":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Verification ID",
              "Please make sure the Verification ID is correct, please try again. Thank you");
          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "requires-recent-login":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Recent Login is required",
              "Please make sure that your account is logged in before, for more information contact customer support.");

          break;
        case "user-mismatch":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops User is Mismatch",
              "Please make sure all the credentials are correct, please try again.");

          break;
        case "invalid-credential":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Credential",
              "Please make sure all the credentials are correct, please try again. Thank you");

          break;
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Email",
              "Please make sure the email is correct, please try again. Thank you");

          break;
        case "wrong-password":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Wrong Password",
              "Please make sure the password is correct, please try again. Thank you");

          break;
        case "invalid-verification-code":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Verification Code",
              "Please make sure the Verification Code is correct, please try again. Thank you");

          break;
        case "invalid_verification_id":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Verification ID",
              "Please make sure the Verification ID is correct, please try again. Thank you");
          break;
      }
    }
  }

  Future updateAcc(String newFullName, String phoneNumber, String newAddress,
      context) async {
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
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Email",
              "Please make sure the email is a valid email format, please try again. Thank you");
          break;

        case "email-already-in-use":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Email is already in use",
              "Please try another email that not registered in the application before, Thank you");

          break;
        case "requires-recent-login":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Requires recent login",
              "Sylviapp says that your account needs recent login to proceed, Thank you.");

          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Email",
              "Please make sure the email is a valid email format, please try again. Thank you");
          break;

        case "email-already-in-use":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Email is already in use",
              "Please try another email that not registered in the application before, Thank you");

          break;
        case "requires-recent-login":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Requires recent login",
              "Sylviapp says that your account needs recent login to proceed, Thank you.");

          break;
      }
    }
  }

  Future updatePassword(String newpass, context) async {
    try {
      await _loggedInUser!.updatePassword(newpass).whenComplete(
          () => Fluttertoast.showToast(msg: "Password Sucessfully Changed"));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Email",
              "Please make sure the email is a valid email format, please try again. Thank you");
          break;
      }
    } on PlatformException catch (e) {
      switch (e.code) {
        case "invalid-email":
          CustomSnackBar().showCustomSnackBar(
              context,
              Colors.orange,
              "Oops Invalid Email",
              "Please make sure the email is a valid email format, please try again. Thank you");

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
        CustomSnackBar().showCustomSnackBar(
            context,
            Color(0xff65BFB8),
            "Application Success",
            "Your application was submitted successfully, please wait for your application to be approve. Thank you");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => VerificationFinalScreen()));
      });

      await DatabaseService(uid: _loggedInUser!.uid).updateApplication();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  joinCampaign(String campaignUID, volunteerUID, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .joinCampaign(campaignUID, volunteerUID)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Campaign Joined",
              "You joined a campaign, thank you for spreading love to earth. Check Activities in the home screen"));
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

  addAnnouncement(String campaignUID, String announcement, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .addAnnouncement(campaignUID, announcement)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Announcement Posted",
              "Hi Organizer, we've posted your announcement to your fellow volunteers. thank you"));
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

  startTheCampaign(String campaignUID, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .starTheCampaign(campaignUID)
          .then((value) => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Campaign Started",
              "Greeny green, the campaign is started go and be safe for spreading green to the earth."));
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
      String uidUser, String organizerUID) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .donatedToCampaign(uidOfCampaign, amount, dateDonated, uidUser)
          .whenComplete(() {
        DatabaseService(uid: _loggedInUser!.uid)
            .incrementDonation(uidOfCampaign, amount);

        DatabaseService(uid: _loggedInUser!.uid)
            .addDonationToOrganizer(organizerUID, amount);
      });
    } catch (e) {
      print(e);
    }
  }

  donateCampaignUser(String uidOfCampaign, int amount, String dateDonated,
      String uidUser, context) async {
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
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Successfully Donated",
              "Thank you for your wonderful donation, this means a lot for mother nature."));
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

  addReportScam(String uidOfCampaign, String uidOfVolunteer,
      String typeOfReport, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addReportScam(uidOfCampaign, uidOfVolunteer, typeOfReport)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Report Submitted",
              "Thank you for your concern, the report will be monitored accordingly by the system thank you."));
    } catch (e) {
      print(e);
    }
  }

  addReportAbuse(String uidOfCampaign, String uidOfVolunteer,
      String typeOfReport, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addReportAbuse(uidOfCampaign, uidOfVolunteer, typeOfReport)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Report Submitted",
              "Thank you for your concern, the report will be monitored accordingly by the system thank you."));
    } catch (e) {
      print(e);
    }
  }

  addReportUIW(String uidOfCampaign, String uidOfVolunteer, String typeOfReport,
      context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addReportUIW(uidOfCampaign, uidOfVolunteer, typeOfReport)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Report Submitted",
              "Thank you for your concern, the report will be monitored accordingly by the system thank you."));
    } catch (e) {
      print(e);
    }
  }

  addFeedback(
      String feedback, String uidOfVolunteer, String date, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addFeedbacks(feedback, uidOfVolunteer, date)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Feedback Submitted",
              "Thank you for your feedback, sylviapp is open for suggestion to improve the experience of user."));
    } catch (e) {
      print(e);
    }
  }

  addSuggestion(
      String suggestion, String uidOfVolunteer, String date, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addSuggestions(suggestion, uidOfVolunteer, date)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Suggestion Submitted",
              "Thank you for your Suggestion, sylviapp is open for suggestion to improve the experience of user."));
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
      String address,
      context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }

      await DatabaseService(uid: _loggedInUser!.uid)
          .addMessage(uidOfCampaign, uidOfOrganizer, uidOfVolunteer,
              devicetokenOfOrg, volunteerName, phoneNumber, gender, address)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Distress Submitted",
              "The organizer has receieved your distress, please stand by and go to safe place"));
    } catch (e) {
      print(e);
    }
  }

  addBalance(String volunteerUID, double newBalance, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addBalance(volunteerUID, newBalance)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Balance Updated",
              "Your new balance has been updated, to check your balance check the card and you will see your current balance."));
    } catch (e) {
      print(e);
    }
  }

  deductBalance(String volunteerUID, double newBalance, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deductBalance(volunteerUID, newBalance)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Balance Updated",
              "Your new balance has been updated, to check your balance check the card and you will see your current balance."));
    } catch (e) {
      print(e);
    }
  }

  deleteActivity(String uidActivity, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deleteRecentActivity(uidActivity)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Activity Deleted",
              "Deleting your activity means there are not turning back, you will not see this activity anymore."));
    } catch (e) {
      print(e);
    }
  }

  deleteRecentCampaign(String uidActivity, String volunteerUID, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deleteRecentCampaign(uidActivity, volunteerUID)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Recent Activity Deleted",
              "Deleting your recent activity means there are not turning back, you will not see this activity anymore."));
    } catch (e) {
      print(e);
    }
  }

  approveVolunteer(String campaignID, String volunteerID, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .approveVolunteer(campaignID, volunteerID)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Volunteer Approved",
              "The volunteer is approve to be part of the campaign, monitor them and take care of them."));
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

  deductInitialCampaign(String volunteerUID, context) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .deductInitialCamapaign(volunteerUID)
          .whenComplete(() => CustomSnackBar().showCustomSnackBar(
              context,
              Color(0xff65BFB8),
              "Balance Deducted",
              "This means that there are charge of the initial campaign that deducted to your account, thank you"));
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

  addJoinedLeaderboard(String volunteerUID, int amount) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addDonationLeaderboard(volunteerUID, amount);
    } catch (e) {
      print(e);
    }
  }

  addDonationLeaderBoard(String volunteerUID, int amount) async {
    try {
      if (_loggedInUser == null) {
        _loggedInUser = FirebaseAuth.instance.currentUser;
      }
      await DatabaseService(uid: _loggedInUser!.uid)
          .addDonationLeaderboard(volunteerUID, amount);
    } catch (e) {
      print(e);
    }
  }
}
