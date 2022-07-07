import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sylviapp_project/Domain/aes_cryptography.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:sylviapp_project/providers/providers.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UploadTask? task;
  String uploadStatus = "";
  String? urlTest = "";
  File? _image;

  TextEditingController fullnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

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
    final destination = 'files/users/$uid/ProfilePicture/$fileName';

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

  Future showProfile(uid) async {
    String fileName = "pic";
    String destination = 'files/users/$uid/ProfilePicture/$fileName';
    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);

    try {
      taske = await firebaseStorageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.code);
      setState(() {
        urlTest = null;
        errorText = e.toString();
      });
    }
    if (this.mounted) {
      setState(() {
        urlTest = taske.toString();
      });
    }
  }

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) {
      fullnameController.value = fullnameController.value.copyWith(
          text: AESCryptography()
              .decryptAES(enc.Encrypted.fromBase64(value.get('fullname'))));

      addressController.value = emailController.value.copyWith(
          text: AESCryptography()
              .decryptAES(enc.Encrypted.fromBase64(value.get('address'))));

      phoneNumberController.value = phoneNumberController.value.copyWith(
          text: AESCryptography()
              .decryptAES(enc.Encrypted.fromBase64(value.get('phoneNumber'))));
    });

    showProfile(context.read(authserviceProvider).getCurrentUserUID());
    super.initState();
    showProfile(context.read(authserviceProvider).getCurrentUserUID());
  }

  String? taske;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.all(10),
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
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xff65BFB8),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/account_management");
                      },
                      color: Color(0xff403d55),
                    ),
                    Text(
                      'Edit Profile',
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
              SizedBox(
                height: 15,
              ),
              StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(
                          context.read(authserviceProvider).getCurrentUserUID())
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                          height: 200,
                          width: 200,
                          child: CircularProgressIndicator());
                    } else {
                      bool verify = snapshot.data!.get("isVerify");
                      var fullname = AESCryptography().decryptAES(
                          enc.Encrypted.fromBase64(
                              snapshot.data!.get('fullname')));

                      return Expanded(
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Stack(children: [
                                  urlTest != ""
                                      ? CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.green,
                                            size: 40,
                                          ),
                                          foregroundImage: urlTest != "null"
                                              ? Image.network(
                                                  urlTest.toString(),
                                                ).image
                                              : null,
                                          radius: 50,
                                          backgroundColor: Colors.white12,
                                        )
                                      : CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.green,
                                            size: 40,
                                          ),
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                        ),
                                  Positioned(
                                    top: 73,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await getImage();
                                        await uploadPicture(context
                                                .read(authserviceProvider)
                                                .getCurrentUserUID())
                                            .whenComplete(() => showProfile(
                                                (context
                                                    .read(authserviceProvider)
                                                    .getCurrentUserUID())));
                                      },
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                SizedBox(
                                  height: 13,
                                ),
                                Text(
                                  fullname,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  verify ? "Organizer" : "Volunteer",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Expanded(
                                    child: Container(
                                  padding: const EdgeInsets.all(40),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Fullname",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            height: 20,
                                            child: TextField(
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    30),
                                              ],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              controller: fullnameController,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            "Address",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            child: TextField(
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              controller: addressController,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Contact Number",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            height: 20,
                                            child: TextField(
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      11),
                                                ],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                controller:
                                                    phoneNumberController),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (fullnameController.text == "" ||
                                                fullnameController.text.length <
                                                    5 ||
                                                addressController.text == "" ||
                                                addressController.text.length <
                                                    5 ||
                                                phoneNumberController.text ==
                                                    "" ||
                                                phoneNumberController
                                                        .text.length <
                                                    11) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please Input valid information");
                                            } else {
                                              print(fullnameController.text);
                                              print(emailController.text);
                                              print(phoneNumberController.text);
                                              await context
                                                  .read(authserviceProvider)
                                                  .updateAcc(
                                                      AESCryptography()
                                                          .encryptAES(
                                                              fullnameController
                                                                  .text),
                                                      phoneNumberController
                                                          .text,
                                                      addressController.text
                                                          .trim(),
                                                      context);
                                            }
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Color(0xff65BFB8),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Center(
                                              child: Text(
                                                "Update",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            )),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
