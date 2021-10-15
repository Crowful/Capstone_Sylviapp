import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            await context
                                                .read(authserviceProvider)
                                                .updateAcc(
                                                    fullnameController.text,
                                                    addressController.text,
                                                    emailController.text)
                                                .whenComplete(() =>
                                                    Fluttertoast.showToast(
                                                        msg: "updated"));
                                          },
                                          child: Text("Update Account"))),
                                  ElevatedButton(
                                      onPressed: () {
                                        print(fullnameController.text);
                                      },
                                      child: Text("Update Password")),
                                  ElevatedButton(
                                      onPressed: () async {
                                        var currentUser = context
                                            .read(authserviceProvider)
                                            .getCurrentUserUID();
                                        await getImage();
                                        uploadPicture(currentUser).whenComplete(
                                            () => Fluttertoast.showToast(
                                                textColor: Color(0xff3F5856),
                                                msg:
                                                    "Picture Uploaded Sucessfully",
                                                backgroundColor:
                                                    Color(0xffF5C69D)));
                                      },
                                      child: Text("Upload Picture")),
                                ],
                              ),
                            ),
                          ],
                        ),
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
