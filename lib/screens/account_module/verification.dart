import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/verification/first_verification.dart';
import 'package:sylviapp_project/widgets/account_module_widgets/verification/second_verification.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  PageController controller = PageController();
  UploadTask? task;
  // ignore: unused_field
  File? _imageFile;

  // ignore: unused_field
  File? _cameraFile;
  String uploadStatus = "";
  String urlTest = "";
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
    final destination = 'files/users/$uid/verification/$fileName';

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

  Future uploadCamera(String uid) async {
    String fileName = "pic";
    final destination = 'files/users/$uid/verification/$fileName';

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
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.all(10),
          child: PageView(
            controller: controller,
            physics: ClampingScrollPhysics(),
            children: [
              FirstVerification(
                nextButton: GestureDetector(
                  onTap: () {
                    controller.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn);
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Color(0xff65BFB8),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        'Get Verified',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              GetVerify()
            ],
          ),
        ),
      ),
    );
  }
}
