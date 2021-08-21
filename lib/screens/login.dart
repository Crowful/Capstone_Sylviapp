import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _etEmailController = TextEditingController();
  final TextEditingController _etPasswordController = TextEditingController();
  final GlobalKey<FormState> _formLogin = GlobalKey<FormState>();
  LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formLogin,
      child: Column(
        children: [
          Text("Email"),
          TextFormField(
            controller: _etEmailController,
          ),
          Text("Password"),
          TextFormField(
            controller: _etPasswordController,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Login"),
          )
        ],
      ),
    ));
  }
}
