import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/sidebar_module/menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encrypt/encrypt.dart' as enc;

// ignore: must_be_immutable
class DrawerScreen extends StatefulWidget {
  final String uid;
  final AnimationController controller;
  // ignore: unused_field
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DrawerScreen({required this.controller, required this.uid});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  late Animation<double> _scaleAnimation =
      Tween<double>(begin: 0.6, end: 1).animate(widget.controller);
  late Animation<Offset> _slideAnimation =
      Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(widget.controller);

  String? taske;
  String? errorText;
  String? urlTest = "";
  Future showProfile(uid) async {
    try {
      String fileName = "pic";
      String destination = 'files/users/$uid/ProfilePicture/$fileName';
      Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);

      taske = await firebaseStorageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.code);
      if (e.code == 'object-not-found') {
        setState(() {
          urlTest = "";
        });
      }
    }
    if (this.mounted) {
      setState(() {
        urlTest = taske.toString();
      });
    }
  }

  @override
  void initState() {
    showProfile(context.read(authserviceProvider).getCurrentUserUID());
    super.initState();
    print("URLLLLLLLLL" + urlTest.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          color: Color(0xff65BFB8),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            SizedBox(height: 50),
            Row(children: [
              urlTest != ""
                  ? CircleAvatar(
                      child: Icon(
                        Icons.person,
                        color: Colors.green,
                        size: 40,
                      ),
                      backgroundColor: Colors.white,
                      radius: 30,
                      foregroundImage: urlTest != "null"
                          ? Image.network(
                              urlTest.toString(),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context,
                                  Object object, StackTrace? stacktrace) {
                                return Text("handle");
                              },
                            ).image
                          : null)
                  : CircularProgressIndicator(),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  print(urlTest);
                },
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(context
                            .read(authserviceProvider)
                            .getCurrentUserUID())
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator());
                      } else {
                        var name = AESCryptography().decryptAES(
                            enc.Encrypted.fromBase64(
                                snapshot.data!.get("fullname")));
                        return Text(name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold));
                      }
                    }),
              )
            ]),
            SizedBox(height: 30),
            MenuItem(
                route: "/account_management",
                title: 'My Account',
                icon: Icons.person),
            MenuItem(
                route: "/recent_activity",
                title: 'Recent Activity',
                icon: Icons.history),
            MenuItem(route: "/donation", title: 'Donate', icon: Icons.campaign),
            MenuItem(
              route: "/settings",
              title: 'Settings',
              icon: Icons.settings,
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text("Are You sure you want to log out ?"),
                        content: Text(
                            "this will log out your account in this device"),
                        actions: [
                          CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("no")),
                          CupertinoDialogAction(
                              onPressed: () {
                                context.read(authserviceProvider).signOut();
                                Navigator.pushNamed(context, "/wrapperAuth");
                              },
                              child: Text("yes")),
                        ],
                      );
                    });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.red[400],
                    size: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                      child: Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.red,
                        fontWeight: FontWeight.w500),
                  ))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
