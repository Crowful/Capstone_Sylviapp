import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/providers/providers.dart';

class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen({Key? key}) : super(key: key);

  @override
  _SendFeedbackScreenState createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  TextEditingController _feedbackController = TextEditingController();

  String nameOfUser = "";

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(context.read(authserviceProvider).getCurrentUserUID())
        .get()
        .then((value) {
      setState(() {
        nameOfUser = value.get('fullname');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Send Feedback",
              style: TextStyle(
                  color: Color(0xff65BFB8),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            Text(
              "Send feedback to the application, limit of 100 characters only!",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  maxLines: 5,
                  controller: _feedbackController,
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                String dateCreated =
                    formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
                if (_feedbackController.text == "") {
                  Fluttertoast.showToast(msg: 'Please Input feedback');
                } else {
                  context.read(authserviceProvider).addFeedback(
                      _feedbackController.text,
                      context.read(authserviceProvider).getCurrentUserUID(),
                      dateCreated,
                      context);
                  _feedbackController.clear();
                }
              },
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xff65BFB8),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text("Submit"),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
