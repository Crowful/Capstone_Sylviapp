import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/register_basic_info.dart';

//Get Firestore instance
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Get Firestore Collection (USER)
final CollectionReference _firestoreUser = _firestore.collection('users');

class AuthService extends ChangeNotifier {
  //instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  //getUI
  static String? userUid = FirebaseAuth.instance.currentUser!.uid;

  //loggedInUser
  late User? _loggedInUser;

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
    return currentUser!.uid.toString();
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
      _loggedInUser = signedInUser.user!;
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      await _loggedInUser!.reload();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future signUp(String email, String password, String fullname) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _loggedInUser = newUser.user!;

      _loggedInUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future addUser(
      {required String name,
      required String address,
      required String gender,
      required int phoneNumber}) async {
    DocumentReference getUserDocument =
        _firestoreUser.doc(userUid).collection('info').doc(userUid);
    Map<String, dynamic> data = <String, dynamic>{
      "uid": userUid,
      "name": name,
      "address": address,
      "gender": gender,
      "phoneNumber": phoneNumber
    };
    await getUserDocument
        .set(data)
        .whenComplete(() => print("User created."))
        .catchError((e) => print("User not created"));
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
      await _loggedInUser!.delete();
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
