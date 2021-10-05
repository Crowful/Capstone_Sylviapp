import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: urlTest != ""
                      ? CircleAvatar(
                          radius: 70,
                          backgroundImage: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: urlTest,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return CircularProgressIndicator();
                            },
                          ).image,
                        )
                      : CircularProgressIndicator(),
                ),
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
                        var address = AESCryptography().decryptAES(
                            enc.Encrypted.fromBase64(
                                snapshot.data!.get('address')));
                        var gender = AESCryptography().decryptAES(
                            enc.Encrypted.fromBase64(
                                snapshot.data!.get('gender')));
                        var email = snapshot.data!.get('email');

                        fullnameController.text = fullname;
                        addressController.text = address;
                        emailController.text = email;

                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Column(
                            children: [
                              Text(fullname),
                              Text(address),
                              Text(gender),
                              Text(email),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                                child: Column(
                                  children: [
                                    Container(
                                      child: TextField(
                                        controller: fullnameController,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.person),
                                            onPressed: null,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: "Full Name",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextField(
                                        controller: addressController,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.person),
                                            onPressed: null,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: "Address",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          prefixIcon: IconButton(
                                            icon: Icon(Icons.person),
                                            onPressed: null,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.black)),
                                          hintText: "Email",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: ElevatedButton(
                        onPressed: () async {
                          await context
                              .read(authserviceProvider)
                              .updateAcc(fullnameController.text,
                                  addressController.text, emailController.text)
                              .whenComplete(
                                  () => Fluttertoast.showToast(msg: "updated"));
                        },
                        child: Text("Update Account"))),
                ElevatedButton(
                    onPressed: () {
                      print(fullnameController.text);
                    },
                    child: Text("Update Password")),
                ElevatedButton(
                    onPressed: () async {
                      var currentUser =
                          context.read(authserviceProvider).getCurrentUserUID();
                      await getImage();
                      uploadPicture(currentUser).whenComplete(() =>
                          Fluttertoast.showToast(
                              textColor: Color(0xff3F5856),
                              msg: "Picture Uploaded Sucessfully",
                              backgroundColor: Color(0xffF5C69D)));
                    },
                    child: Text("Upload Picture")),
                ElevatedButton(
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: Text("Are You sure about that?"),
                              content: Text("there's no turning back brother"),
                              actions: [
                                CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("no")),
                                CupertinoDialogAction(
                                    onPressed: () {
                                      context
                                          .read(authserviceProvider)
                                          .deleteAcc()
                                          .whenComplete(() =>
                                              Navigator.pushNamed(
                                                  context, "/wrapperAuth"));
                                    },
                                    child: Text("yes")),
                              ],
                            );
                          });
                    },
                    child: Text("Delete Account")),
                Container(
                  color: Colors.white,
                  height: 200,
                  width: 300,
                  child: urlTest == ""
                      ? Center(child: Text('Preview'))
                      : Image.network(
                          urlTest,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(child: Text("No Image"));
                          },
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
