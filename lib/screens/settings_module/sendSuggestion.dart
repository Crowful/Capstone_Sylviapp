import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sylviapp_project/providers/providers.dart';

class SendSuggestion extends StatefulWidget {
  const SendSuggestion({Key? key}) : super(key: key);

  @override
  _SendSuggestionState createState() => _SendSuggestionState();
}

class _SendSuggestionState extends State<SendSuggestion> {
  TextEditingController _suggestionController = TextEditingController();
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
              "Send Forest Area Suggestion",
              style: TextStyle(
                  color: Color(0xff65BFB8),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            Text(
              "Input the name of the forest that have the most deforestation activities. Sylviapp is automatically adjusting where the available forest to plant trees, however sylviapp is glad to hear some suggestions of the places you wanted to have in our application. ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.normal),
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
                  controller: _suggestionController,
                  inputFormatters: [LengthLimitingTextInputFormatter(50)],
                )),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                String dateCreated =
                    formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
                if (_suggestionController.text == "") {
                  Fluttertoast.showToast(
                      msg: 'Please Input Place of the forest');
                } else {
                  context.read(authserviceProvider).addSuggestion(
                      _suggestionController.text,
                      context.read(authserviceProvider).getCurrentUserUID(),
                      dateCreated,
                      context);
                  _suggestionController.clear();
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
