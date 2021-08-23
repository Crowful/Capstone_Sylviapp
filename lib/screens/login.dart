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
        
        Container(
                margin: EdgeInsets.fromLTRB(20, 150, 20, 0),
          child:Text("Login Now")),

          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _etEmailController,
                onChanged: (email) => {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "Email",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),


SizedBox(height: 20),

             Container(
               margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
            controller: _etPasswordController,
                onChanged: (email) => {},
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "Password",
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(onPressed:(){
              print("Login");
            } ,child: Text("Login"),)
        ],
      ),
    ));
  }
}
