import 'package:flutter/material.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _etEmailController = TextEditingController();
  final TextEditingController _etPasswordController = TextEditingController();
  final GlobalKey<FormState> _formLogin = GlobalKey<FormState>();
  LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: Color(0xff65BFB8),
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Form(
              key: _formLogin,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Welcome to Sylviapp',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          width: double.infinity,
                          child: TextField(
                            decoration: InputDecoration(
                                focusColor: Color(0xff65BFB8),
                                labelText: "Email",
                                hintText: "email@mail.com",
                                prefixIcon: Icon(Icons.email),
                                contentPadding: EdgeInsets.all(15),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15))),
                          width: double.infinity,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(accentColor: Color(0xff65BFB8)),
                            child: TextField(
                              decoration: InputDecoration(
                                  focusColor: Colors.black,
                                  hintText: "Password",
                                  prefixIcon: Icon(Icons.vpn_key),
                                  contentPadding: EdgeInsets.all(15),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
