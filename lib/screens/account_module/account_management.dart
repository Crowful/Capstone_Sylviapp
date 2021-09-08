import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sylviapp_project/Domain/wrapperAuth.dart';

import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({Key? key}) : super(key: key);

  @override
  _AccountManagementScreenState createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  UploadTask? task;
  String uploadStatus = "";
  String urlTest = "";
  File? _image;

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
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: Image.network(
                            "https://images.unsplash.com/photo-1552058544-f2b08422138a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=644&q=80")
                        .image,
                  ),
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
                        var fullname = snapshot.data!.get('fullname');
                        var address = snapshot.data!.get('address');
                        var gender = snapshot.data!.get('gender');
                        var email = snapshot.data!.get('email');
                        return Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: Column(
                            children: [
                              Text(fullname),
                              Text(address),
                              Text(gender),
                              Text(email),
                            ],
                          ),
                        );
                      }
                    }),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 50),
                  child: Column(
                    children: [
                      Container(
                        child: TextField(
                          controller: null,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: Icon(Icons.person),
                              onPressed: null,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            hintText: "Full Name",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: null,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: Icon(Icons.person),
                              onPressed: null,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            hintText: "Address",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: null,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: Icon(Icons.person),
                              onPressed: null,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            hintText: "Email",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: null,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: Icon(Icons.person),
                              onPressed: null,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black)),
                            hintText: "Password",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text("Update Account")),
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
                        : Image.network(urlTest)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
