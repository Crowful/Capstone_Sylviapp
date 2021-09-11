import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/sidebar_module/menu_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';

class DrawerScreen extends StatefulWidget {
  final AnimationController controller;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DrawerScreen({Key? key, required this.controller}) : super(key: key);

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
  String urlTest = "";
  Future showProfile(uid) async {
    String fileName = "pic";
    String destination = 'files/users/$uid/ProfilePicture/$fileName';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    try {
      taske = await firebaseStorageRef.getDownloadURL();
    } catch (e) {
      setState(() {
        errorText = e.toString();
      });
    }
    setState(() {
      urlTest = taske.toString();
    });
  }

  @override
  void initState() {
    showProfile(context.read(authserviceProvider).getCurrentUserUID());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_scaleAnimation == null) {
      _scaleAnimation =
          Tween<double>(begin: 0.6, end: 1).animate(widget.controller);
    }
    if (_slideAnimation == null) {
      _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
          .animate(widget.controller);
    }

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            SizedBox(height: 50),
            Row(children: [
              urlTest != ""
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: urlTest,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return CircularProgressIndicator();
                        },
                      ).image,
                    )
                  : CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(
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
                        var name = snapshot.data!.get('username');
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
                route: "/settings",
                title: 'Recent Activity',
                icon: Icons.history),
            MenuItem(
                route: "/settings",
                title: 'Ongoing Campaign',
                icon: Icons.campaign),
            MenuItem(
              route: "/settings",
              title: 'Settings',
              icon: Icons.settings,
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                context.read(authserviceProvider).signOut();
                Navigator.pushNamed(context, "/wrapperAuth");
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
                    style: TextStyle(fontSize: 12, color: Colors.red),
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
