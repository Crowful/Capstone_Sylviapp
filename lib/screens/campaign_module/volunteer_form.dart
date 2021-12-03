import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sylviapp_project/Domain/wrapperisApproved.dart';
import 'package:sylviapp_project/providers/providers.dart';

// ignore: must_be_immutable
class VolunteerFormScreen extends StatefulWidget {
  String campaignUID;
  String organizerUID;
  VolunteerFormScreen(
      {Key? key, required this.campaignUID, required this.organizerUID})
      : super(key: key);

  @override
  _VolunteerFormScreenState createState() => _VolunteerFormScreenState();
}

class _VolunteerFormScreenState extends State<VolunteerFormScreen> {
//bool checklist

  bool isHaveBottledWater = false;
  bool isHaveProperClothes = false;
  bool isHaveMobilePhone = false;
  bool isHaveGloves = false;
  bool isHaveFaceMaskandShield = false;

  UploadTask? task;
  String uploadStatus = "";
  String urlTest = "";
  File? _imageOfMed;
  File? _imageOfVac;

  Future uploadMedicPicture(
      String campaignuid, String organizerUid, String volunteerUID) async {
    String fileName = "pic";
    final destination =
        'files/users/$organizerUid/campaigns/$campaignuid/volunteers/$volunteerUID/medical_picture/$fileName';

    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    task = firebaseStorageRef.putFile(_imageOfMed!);

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

  Future getImageVac() async {
    var image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageOfVac = File(image!.path);
      print('image Path $_imageOfVac');
      uploadStatus = 'Uploading';
    });
  }

  Future getImageMed() async {
    var image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageOfMed = File(image!.path);
      print('image Path $_imageOfMed');
      uploadStatus = 'Uploading';
    });
  }

  Future uploadVaccID(
      String campaignuid, String organizerUid, String volunteerUID) async {
    String fileName = "pic";
    final destination =
        'files/users/$organizerUid/campaigns/$campaignuid/volunteers/$volunteerUID/vac_picture/$fileName';

    Reference firebaseStorageRef = FirebaseStorage.instance.ref(destination);
    task = firebaseStorageRef.putFile(_imageOfVac!);

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
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(
                  "FILL UP FORM",
                  style: TextStyle(
                      color: Color(0xff65BFB8),
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Text(
              "As a Volunteer you need to submit the following in this form, also, you need to consider to bring the following safety gears and essentials items during the campaigns",
            ),
          ),
          Row(children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
              width: 180,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xff65BFB8)),
                child: Row(children: [
                  Icon(Icons.attach_file),
                  Text(" VACCINATION ID")
                ]),
                onPressed: () {
                  getImageVac();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: _imageOfVac == null
                  ? Text("No Image Attached",
                      style: TextStyle(color: Colors.red))
                  : Text(
                      "Image Attached",
                      style: TextStyle(color: Colors.green),
                    ),
            ),
          ]),
          Row(children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              width: 210,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xff65BFB8)),
                child: Row(children: [
                  Icon(Icons.attach_file),
                  Text(" MEDICAL CERTIFICATE")
                ]),
                onPressed: () {
                  getImageMed();
                },
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: _imageOfMed == null
                    ? Text("No Image Attached",
                        style: TextStyle(color: Colors.red))
                    : Text(
                        "Image Attached",
                        style: TextStyle(color: Colors.green),
                      ))
          ]),
          Container(
              margin: EdgeInsets.fromLTRB(0, 20, 130, 0),
              child: Text("SAFETY CHECKLIST",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff65BFB8),
                      fontWeight: FontWeight.w900))),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              "The following are the checklist you need to have in order to join this campaign, if you don't have any of this you can't join this campaign unless you complete the safety checklist of this campaign.",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Row(children: [
            Checkbox(
              value: isHaveBottledWater,
              onChanged: (value) {
                setState(() {
                  isHaveBottledWater = !isHaveBottledWater;
                });
              },
              activeColor: Colors.greenAccent,
            ),
            Text(
              "Bottled Water",
            )
          ]),
          Row(children: [
            Checkbox(
              value: isHaveProperClothes,
              onChanged: (value) {
                setState(() {
                  isHaveProperClothes = !isHaveProperClothes;
                });
              },
              activeColor: Colors.greenAccent,
            ),
            Text(
              "Proper Clothes",
            )
          ]),
          Row(children: [
            Checkbox(
              value: isHaveMobilePhone,
              onChanged: (value) {
                setState(() {
                  isHaveMobilePhone = !isHaveMobilePhone;
                });
              },
              activeColor: Colors.greenAccent,
            ),
            Text(
              "Mobile Phone",
            )
          ]),
          Row(children: [
            Checkbox(
              value: isHaveGloves,
              onChanged: (value) {
                setState(() {
                  isHaveGloves = !isHaveGloves;
                });
              },
              activeColor: Colors.greenAccent,
            ),
            Text(
              "Gloves",
            )
          ]),
          Row(children: [
            Checkbox(
              value: isHaveFaceMaskandShield,
              onChanged: (value) {
                setState(() {
                  isHaveFaceMaskandShield = !isHaveFaceMaskandShield;
                });
              },
              activeColor: Colors.greenAccent,
            ),
            Text(
              "Face Mask and Face Shield",
            )
          ]),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: 350,
            child: Text(
              "By Clicking the Submit Button you automatically accept the terms and conditions in this campaign, I will plant keme and I will follow the rules on this campaign.",
              style: TextStyle(color: Colors.red[400]),
            ),
          ),
          Container(
              height: 50,
              width: 300,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_imageOfMed == null) {
                    Fluttertoast.showToast(
                        msg: "Please Upload Medical Picture");
                  } else if (_imageOfVac == null) {
                    Fluttertoast.showToast(
                        msg: "Please Upload Vaccination Picture");
                  } else if (_imageOfMed == null && _imageOfVac == null) {
                    Fluttertoast.showToast(
                        msg: "Please submit required pictures");
                  } else if (isHaveBottledWater == false ||
                      isHaveFaceMaskandShield == false ||
                      isHaveGloves == false ||
                      isHaveMobilePhone == false ||
                      isHaveProperClothes == false) {
                    Fluttertoast.showToast(
                        msg:
                            "you're not eligible for this campaign because you did not met the following safety gears");
                  } else if (_imageOfMed != null &&
                      _imageOfVac != null &&
                      isHaveBottledWater == true &&
                      isHaveFaceMaskandShield == true &&
                      isHaveGloves == true &&
                      isHaveMobilePhone == true &&
                      isHaveProperClothes == true) {
                    uploadMedicPicture(widget.campaignUID, widget.organizerUID,
                        context.read(authserviceProvider).getCurrentUserUID());
                    uploadVaccID(widget.campaignUID, widget.organizerUID,
                        context.read(authserviceProvider).getCurrentUserUID());

                    await context.read(authserviceProvider).joinCampaign(
                        widget.campaignUID,
                        context.read(authserviceProvider).getCurrentUserUID());

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WrapperUsApproved(
                                  campaignID: widget.campaignUID,
                                  volunteerUID: context
                                      .read(authserviceProvider)
                                      .getCurrentUserUID(),
                                )));
                  } else {
                    Fluttertoast.showToast(msg: "something went wrong");
                  }
                },
                child: Text("S U B M I T"),
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), primary: Color(0xff65BFB8)),
              ))
        ],
      )),
    );
  }
}
