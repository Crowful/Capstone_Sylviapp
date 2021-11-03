import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class VolunteerFormScreen extends StatefulWidget {
  const VolunteerFormScreen({Key? key}) : super(key: key);

  @override
  _VolunteerFormScreenState createState() => _VolunteerFormScreenState();
}

class _VolunteerFormScreenState extends State<VolunteerFormScreen> {
  UploadTask? task;
  String uploadStatus = "";
  String urlTest = "";
  File? _image;

  Future uploadPicture(String uid) async {
    String fileName = "pic";
    final destination =
        'files/users/$uid/campaign_joined/medical_picture/$fileName';

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
        body: Column(
      children: [
        Text("SUBMIT FORM"),
        ElevatedButton(
          child: Text("SUBMIT MEDICAL FORM"),
          onPressed: () {},
        ),
        Text("SAFETY CHECKLIST"),
        Row(children: [
          Checkbox(value: true, onChanged: (value) {}),
          Text("HELMET")
        ]),
        Row(children: [
          Checkbox(value: true, onChanged: (value) {}),
          Text("GAMOT")
        ]),
        Row(children: [
          Checkbox(value: true, onChanged: (value) {}),
          Text("PLASTIC")
        ]),
        Row(children: [
          Checkbox(value: true, onChanged: (value) {}),
          Text("GAMOT")
        ]),
        Row(children: [
          Checkbox(value: true, onChanged: (value) {}),
          Text("GLOVES")
        ]),
        Container(
          height: 200,
          width: 300,
          child: Row(children: [
            Checkbox(value: true, onChanged: (value) {}),
            Text(
              "I hereby accept the terms and conditions in this campaign, I will plant keme and I will follow the rules on this campaign",
              softWrap: true,
            )
          ]),
        ),
        ElevatedButton(
            onPressed: () {}, child: Text("Submit Information to Organizer"))
      ],
    ));
  }
}
