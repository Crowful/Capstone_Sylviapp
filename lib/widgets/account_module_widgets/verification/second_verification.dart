import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Experience { yes, no }

class GetVerify extends StatefulWidget {
  const GetVerify({Key? key}) : super(key: key);

  @override
  _GetVerifyState createState() => _GetVerifyState();
}

class _GetVerifyState extends State<GetVerify> {
  TextEditingController whydidyouController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();

  String urlForID = "";
  String urlForPic = "";
  String idNumber = "";
  String reasonForAppli = "";
  String doHaveExp = "";
  bool isVerify = false;

  UploadTask? task;
  File? _imageFile;
  File? _cameraFile;
  String uploadStatus = "";
  String urlTest = "";
  // ignore: unused_field
  File? _image;
  final picker = ImagePicker();
  //Gallery
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future takeImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _cameraFile = File(pickedFile!.path);
    });
  }

  Future uploadPicture(String uid) async {
    String fileName = "pic";
    final destination = 'files/users/$uid/verification/validID/$fileName';

    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    task = firebaseStorageRef.putFile(_imageFile!);

    final snapshot = await task!.whenComplete(() => {
          setState(() {
            uploadStatus = 'Sucessfully Uploaded (Wait for the Confirmation)';
            urlForID = destination;
          })
        });
    String urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      urlTest = urlDownload;
    });
  }

  Future uploadCamera(String uid) async {
    String fileName = "pic";
    final destination = 'files/users/$uid/verification/facePic/$fileName';

    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    task = firebaseStorageRef.putFile(_cameraFile!);

    final snapshot = await task!.whenComplete(() => {
          setState(() {
            uploadStatus = 'Sucessfully Uploaded (Wait for the Confirmation)';
            urlForPic = destination;
          })
        });
    String urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      urlTest = urlDownload;
    });
  }

  String _experience = "yes";
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff65BFB8),
                    )),
                Text(
                  'Account Verification',
                  style: TextStyle(
                      color: Color(0xff65BFB8),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.transparent,
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    await pickImage();
                    uploadPicture(
                        context.read(authserviceProvider).getCurrentUserUID());
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Upload Valid ID ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Color(0xff65BFB8),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.upload), Text('Upload ID')],
                          ))
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'ID number: ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.23),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextField(
                        controller: idNumberController,
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Take a picture',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await takeImage();
                        uploadCamera(context
                            .read(authserviceProvider)
                            .getCurrentUserUID());
                      },
                      child: Container(
                        height: 35,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Color(0xff65BFB8),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera),
                            Text('Take a picture')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Why did you apply for this role?',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.23),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        controller: whydidyouController,
                      ),
                    )
                  ],
                ),
                Text(
                  'Do you have any experience handling campaigns before?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2.5,
                ),
                Text(
                  'Being an organizer is not an easy job and you need to follow rules and procedures. Review the rules and procedures and make sure to read it carefully.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Transform.scale(
                        scale: 0.9,
                        child: RadioListTile<String>(
                            title: Text(
                              "Yes",
                            ),
                            value: "Yes",
                            groupValue: _experience,
                            onChanged: (value) {
                              setState(() {
                                _experience = value!;
                              });
                            }),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Transform.scale(
                        scale: 0.9,
                        child: RadioListTile<String>(
                            title: Text(
                              "No",
                            ),
                            value: "No",
                            groupValue: _experience,
                            onChanged: (value) {
                              setState(() {
                                _experience = value!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Text('I agree and accept with the rules and procedure.')
                  ],
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              isVerify = false;
              bool isAppplying = true;
              context.read(authserviceProvider).createApplication(
                  urlForID,
                  idNumberController.text,
                  urlForPic,
                  whydidyouController.text,
                  _experience,
                  isVerify,
                  isAppplying);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xff65BFB8),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Text(
                  'Submit Application',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          )
        ],
      ),
    )));
  }
}
