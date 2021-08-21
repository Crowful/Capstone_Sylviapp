import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService extends ChangeNotifier {
  //instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  //loggedInUser
  late User _loggedInUser;

  //UserChanges

  Stream<User?> get getauthStateChange {
    return _auth.authStateChanges();
  }

  Future<bool> get userVerified async {
    await _auth.currentUser!.reload();
    return _auth.currentUser!.emailVerified;
  }

  //getters

  User get getUser {
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
      await _loggedInUser.reload();
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
      await _loggedInUser
          .delete()
          .whenComplete(() => print("Sucessfully Deleted"));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }
}
