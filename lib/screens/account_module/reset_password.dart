import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/providers/providers.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController verifyCurrentPasswordController =
      TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  checkVerification() {
    if (currentPasswordController.text ==
        verifyCurrentPasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff65BFB8),
                ),
                onPressed: () {
                  Navigator.pop(context);
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
                icon: Icon(Icons.bookmark_outline),
                onPressed: () {},
                color: Colors.transparent,
              ),
            ]),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset your Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Type your current password:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextField(
                            style:
                                TextStyle(color: Theme.of(context).cardColor),
                            controller: currentPasswordController,
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
                              hintText: "Type your Current Password",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Type your current password again:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextField(
                            style:
                                TextStyle(color: Theme.of(context).cardColor),
                            controller: verifyCurrentPasswordController,
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
                              hintText: "Type your Current Password Again",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Type your new password:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextField(
                            style:
                                TextStyle(color: Theme.of(context).cardColor),
                            controller: newPasswordController,
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
                              hintText: "Type your New Password",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff65BFB8)),
                                onPressed: () async {
                                  if (checkVerification() == true) {
                                    await context
                                        .read(authserviceProvider)
                                        .updatePassword(
                                            newPasswordController.text);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "INVALID PASSWORD INPUT");
                                  }
                                },
                                child: Text("Change Password"))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
