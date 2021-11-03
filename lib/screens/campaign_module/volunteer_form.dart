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
            margin: EdgeInsets.fromLTRB(0, 20, 190, 0),
            width: 180,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff65BFB8)),
              child: Row(
                  children: [Icon(Icons.attach_file), Text(" VACCINATION ID")]),
              onPressed: () {},
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 160, 0),
            width: 210,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff65BFB8)),
              child: Row(children: [
                Icon(Icons.attach_file),
                Text(" MEDICAL CERTIFICATE")
              ]),
              onPressed: () {},
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 130, 0),
              child: Text("SAFETY CHECKLIST",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w900))),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              "The following are the checklist you need to have in order to join this campaign, if you don't have any of this you can't join this campaign unless you complete the safety checklist of this campaign.",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Row(children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.greenAccent,
            ),
            Text("Bottled Water", style: TextStyle(color: Colors.black54))
          ]),
          Row(children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.greenAccent,
            ),
            Text("Proper Clothes", style: TextStyle(color: Colors.black54))
          ]),
          Row(children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.greenAccent,
            ),
            Text("Mobile Phone", style: TextStyle(color: Colors.black54))
          ]),
          Row(children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.greenAccent,
            ),
            Text("Gloves", style: TextStyle(color: Colors.black54))
          ]),
          Row(children: [
            Checkbox(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.greenAccent,
            ),
            Text("Face Mask and Face Shield",
                style: TextStyle(color: Colors.black54))
          ]),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: 350,
            child: Text(
              "By Clicking the Submit Button you automatically accept the terms and conditions in this campaign, I will plant keme and I will follow the rules on this campaign.",
            ),
          ),
          Container(
              height: 50,
              width: 300,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text("S U B M I T"),
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), primary: Color(0xff65BFB8)),
              ))
        ],
      )),
    );
  }
}
