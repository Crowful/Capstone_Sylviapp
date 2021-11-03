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
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 150, 0),
            child: Text(
              "FILL UP FORM",
              style: TextStyle(
                  color: Color(0xff65BFB8),
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Text(
              "As a Volunteer you need to submit the following in this form, also, you need to consider to bring the following safety gears and essentials items during the campaigns",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Container(
            width: 180,
            child: ElevatedButton(
              child: Row(
                  children: [Icon(Icons.attach_file), Text(" VACCINATION ID")]),
              onPressed: () {},
            ),
          ),
          Container(
            width: 210,
            child: ElevatedButton(
              child: Row(children: [
                Icon(Icons.attach_file),
                Text(" MEDICAL CERTIFICATE")
              ]),
              onPressed: () {},
            ),
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
          ElevatedButton(onPressed: () {}, child: Text("JOIN"))
        ],
      )),
    );
  }
}
