import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/Domain/wrapperAuth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:encrypt/encrypt.dart' as enc;

class AccountManagementScreen extends StatefulWidget {
  @override
  _AccountManagementScreenState createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  UploadTask? task;
  String uploadStatus = "";
  String urlTest = "";
  File? _image;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future getImage() async {
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
      print('image Path $_image');
      uploadStatus = 'Uploading';
    });
  }

  Future uploadPicture(String uid) async {
    String fileName = "pic";
    final destination = 'files/users/$uid/verification/validid/$fileName';

    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    task = firebaseStorageRef.putFile(_image!);

    final snapshot = await task!.whenComplete(() => {
          setState(() {
            uploadStatus = 'Sucessfully Uploaded (Wait for the Confirmation)';
          })
        });
    String urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      urlTest = urlDownload;
    });
  }

  String? taske;
  String? errorText;

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
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Color(0xff65BFB8),
                          )),
                      Text(
                        'Sylviapp',
                        style: TextStyle(
                            color: Color(0xff65BFB8),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit, color: Colors.transparent))
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: urlTest == ""
                            ? CircleAvatar(
                                radius: 45,
                                backgroundImage: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: urlTest,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return CircleAvatar(
                                      radius: 100,
                                      child: Icon(Icons.account_circle),
                                    );
                                  },
                                ).image,
                              )
                            : CircularProgressIndicator()),
                    Wrap(children: [
                      StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(context
                                  .read(authserviceProvider)
                                  .getCurrentUserUID())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                  height: 200,
                                  width: 200,
                                  child: CircularProgressIndicator());
                            } else {
                              var fullname = AESCryptography().decryptAES(
                                  enc.Encrypted.fromBase64(
                                      snapshot.data!.get('fullname')));

                              var email = snapshot.data!.get('email');

                              fullnameController.text = fullname;
                              emailController.text = email;

                              return Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          fullname,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.verified,
                                          size: 15,
                                          color: Color(0xff65BFB8),
                                        )
                                      ],
                                    ),
                                    Text(email,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600)),
                                    Text("Not Verified",
                                        style: TextStyle(
                                            color: Color(0xff65BFB8),
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              );
                            }
                          }),
                    ]),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xff65BFB8),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                )),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xffFF683A),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.pushNamed(
                                        context, "/getverified");
                                  });
                                },
                                icon: Icon(Icons.security,
                                    size: 20, color: Colors.white)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.pushNamed(context, "/getverified");
                                });
                              },
                              child: Text(
                                'Get Verified',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xffFFD337),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.restore, color: Colors.white)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Recent Activities',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'My Account',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Reset Password',
                          style: TextStyle(
                              color: Color(0xff65BFB8),
                              fontWeight: FontWeight.w500,
                              fontSize: 15)),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Log Out',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 15)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
