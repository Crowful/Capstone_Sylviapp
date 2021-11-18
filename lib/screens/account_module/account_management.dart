import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/screens/account_module/add_money.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sylviapp_project/translations/locale_keys.g.dart';

class AccountManagementScreen extends StatefulWidget {
  final String uid;
  const AccountManagementScreen({Key? key, required this.uid})
      : super(key: key);
  @override
  _AccountManagementScreenState createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  UploadTask? task;
  String uploadStatus = "";
  String? urlTest = "";
  File? _image;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future getImage() async {
    var image =
        // ignore: invalid_use_of_visible_for_testing_member
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
        urlTest = null;
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
                            Navigator.pushNamed(context, '/home');
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
                      child: urlTest != ""
                          ? CircleAvatar(
                              child: Icon(
                                Icons.person,
                                color: Colors.red,
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
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object object,
                                          StackTrace? stacktrace) {
                                        return Text("handle");
                                      },
                                    ).image
                                  : null)
                          : CircularProgressIndicator(),
                    ),
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

                              bool isVerify = snapshot.data!.get('isVerify');

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
                                        isVerify == true
                                            ? Icon(
                                                Icons.verified,
                                                size: 15,
                                                color: Color(0xff65BFB8),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                    Text(email,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600)),
                                    isVerify == true
                                        ? Text(" Organizer",
                                            style: TextStyle(
                                                color: Color(0xff65BFB8),
                                                fontWeight: FontWeight.bold))
                                        : Text("Volunteer",
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
                                onPressed: () {
                                  Navigator.pushNamed(context, "/edit_profile");
                                },
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
                              LocaleKeys.editprofile.tr(),
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
                                        context, "/WrapperVerify");
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
                                  Navigator.pushNamed(
                                      context, "/WrapperVerify");
                                });
                              },
                              child: Text(
                                LocaleKeys.getverified.tr(),
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
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/recent_activity');
                                },
                                icon: Icon(Icons.restore, color: Colors.white)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.recentactivity.tr(),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
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
                            backgroundColor: Colors.green,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddmoneyScreen()));
                                },
                                icon: Icon(Icons.attach_money,
                                    color: Colors.white)),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.addmoney.tr(),
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
                        LocaleKeys.myaccount.tr(),
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('campaigns')
                              .where('uid',
                                  isEqualTo: context
                                      .read(authserviceProvider)
                                      .getCurrentUserUID())
                              .snapshots(),
                          builder: (context, snapshot) {
                            var numberOfCampaigns = snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0;
                            return GestureDetector(
                              onTap: () {
                                showCupertinoDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: Text(
                                            "Are You sure you want to Delete your account?"),
                                        content: Text(
                                            "There's no turning back once this deletion is done."),
                                        actions: [
                                          CupertinoDialogAction(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("no")),
                                          CupertinoDialogAction(
                                              onPressed: () async {
                                                if (numberOfCampaigns > 0) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'you have have campaigns to finish, you cannot delete your account');
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        TextEditingController
                                                            emailReAuthController =
                                                            TextEditingController();
                                                        TextEditingController
                                                            passwordReAuthController =
                                                            TextEditingController();
                                                        return Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(50, 100,
                                                                  50, 200),
                                                          child: Card(
                                                            child: Column(
                                                              children: [
                                                                TextField(
                                                                  controller:
                                                                      emailReAuthController,
                                                                ),
                                                                TextField(
                                                                  controller:
                                                                      passwordReAuthController,
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await context.read(authserviceProvider).deleteAcc(
                                                                          emailReAuthController
                                                                              .text,
                                                                          passwordReAuthController
                                                                              .text,
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        'Delete'))
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                }
                                              },
                                              child: Text("yes")),
                                        ],
                                      );
                                    });
                              },
                              child: Text('Delete Account',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                            );
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/reset_password");
                        },
                        child: Text(LocaleKeys.resetpassword.tr(),
                            style: TextStyle(
                                color: Color(0xff65BFB8),
                                fontWeight: FontWeight.w500,
                                fontSize: 15)),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Text(
                                      "Are You sure you want to log out ?"),
                                  content: Text(
                                      "this will log out your account in this device"),
                                  actions: [
                                    CupertinoDialogAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("no")),
                                    CupertinoDialogAction(
                                        onPressed: () async {
                                          await context
                                              .read(authserviceProvider)
                                              .signOut();

                                          await Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/wrapperAuth',
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        child: Text("yes")),
                                  ],
                                );
                              });
                        },
                        child: Text(LocaleKeys.logout.tr(),
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 15)),
                      ),
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
