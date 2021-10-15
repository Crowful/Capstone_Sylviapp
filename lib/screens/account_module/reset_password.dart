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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              children: [
                Container(
                  child: TextField(
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (checkVerification() == true) {
                            await context
                                .read(authserviceProvider)
                                .updatePassword(newPasswordController.text);
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
    ));
  }
}
